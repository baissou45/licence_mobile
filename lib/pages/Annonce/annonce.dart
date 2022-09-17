import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:licence_mobile/model/annonce.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';

class AnnonceDetail extends StatefulWidget {
  late Annonce annonce;
  AnnonceDetail({required this.annonce});

  @override
  State<AnnonceDetail> createState() => _AnnonceDetailState(annonce: annonce);
}

class _AnnonceDetailState extends State<AnnonceDetail> {
  Annonce annonce;

  _AnnonceDetailState({required this.annonce});
  List files = [];
  late Directory path;
  bool downloading = false;
  String progressString = "0%";

  Future<bool> _hasAcceptedPermissions() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
      await Permission.accessMediaLocation.request();
      // await Permission.manageExternalStorage.request();
      if (await Permission.storage.isGranted &&
              await Permission.accessMediaLocation.isGranted
          // await Permission.manageExternalStorage.isGranted
          ) {
        return true;
      } else {
        return false;
      }
    }
    if (Platform.isIOS) {
      await Permission.photos.request();
      if (await Permission.photos.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      // not android or ios
      return false;
    }
  }

  getData() async {
    path = (await getExternalStorageDirectory())!;
    path =
        await Directory(path.path + '/' + annonce.type).create(recursive: true);
    List<FileSystemEntity> _folders =
        await path.listSync(recursive: true, followLinks: false);
    if (_folders.isNotEmpty) {
      for (var folder in _folders) {
        List _datas = folder.path.split('/');
        setState(() {
          files.add(_datas[_datas.length - 1]);
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Annonce de ${widget.annonce.auteur}"),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.luminosity),
                  image: AssetImage("assets/images/books.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: largeur / 50.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: longeur / 20),
                    Text(
                      widget.annonce.titre,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: largeur / 20,
                      ),
                    ),
                    SizedBox(height: longeur / 30),
                    if (widget.annonce.img != 'null')
                      Card(
                        elevation: 8.0,
                        child: Hero(
                            tag: "photo ${widget.annonce.id}",
                            // child: Image.network(widget.annonce.fichier)),
                            child: Image.network(
                              Api.externalGeturl() + "${annonce.img}",
                              // "assets/images/img.jpg",
                              fit: BoxFit.cover,
                              // height: longeur / 3,
                            )),
                      ),
                    SizedBox(height: longeur / 40),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(
                          horizontal: largeur / 40, vertical: longeur / 40),
                      child: HtmlWidget(annonce.description),
                      // child: Text(
                      //   widget.annonce.description,
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     color: Colors.white,
                      //   ),
                      // ),
                    ),
                    SizedBox(height: longeur / 20),
                    if (annonce.fichier != "null")
                      Card(
                        elevation: 5.0,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 50),
                        child: Container(
                          color: files.contains('${annonce.titre}.pdf')
                              ? Colors.greenAccent
                              : Colors.white,
                          height: MediaQuery.of(context).size.height / 12,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              files.contains('${annonce.titre}.pdf')
                                  ? IconButton(
                                      onPressed: () async {
                                        if (files
                                            .contains('${annonce.titre}.pdf')) {
                                          await OpenFile.open(
                                              '${path.path}/${annonce.titre}.pdf');
                                        }
                                      },
                                      icon: Icon(Icons.remove_red_eye_outlined))
                                  : Icon(
                                      Icons.picture_as_pdf_outlined,
                                      color: Colors.red,
                                    ),
                              InkWell(
                                onTap: () async {
                                  if (files.contains('${annonce.titre}.pdf')) {
                                    await OpenFile.open(
                                        '${path.path}/${annonce.titre}.pdf');
                                  }
                                },
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width / 1.9,
                                  child: Text(
                                    annonce.titre,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () async {
                                    Dio dio = Dio();

                                    try {
                                      // if (await Widgets.checkConnexion()) {
                                      if (await _hasAcceptedPermissions()) {
                                        setState(() {
                                          downloading = true;
                                        });
                                        await dio.download(
                                            Api.externalGeturl() +
                                                annonce.fichier,
                                            // 'http://10.0.2.2:8000/pdf/cv.pdf',
                                            "${path.path}/${annonce.titre}.pdf",
                                            onReceiveProgress: (rec, total) {
                                          setState(() {
                                            progressString =
                                                ((rec / total) * 100)
                                                        .toStringAsFixed(0) +
                                                    "%";
                                          });
                                        });
                                      }
                                      setState(() {
                                        downloading = false;
                                        progressString = "Completed";
                                        files.add('${annonce.titre}.pdf');
                                      });
                                      Widgets.mySnack(
                                          context,
                                          'Fichier télécharger avec success',
                                          "success");
                                      // } else {
                                      //   ScaffoldMessenger.of(context)
                                      //       .showSnackBar(SnackBar(
                                      //           content: Text(
                                      //     'Vous n\'êtes pas connecter à internet',
                                      //     textAlign: TextAlign.center,
                                      //   )));
                                      // }
                                    } catch (e) {
                                      throw (e.toString());
                                    }
                                  },
                                  child: files.contains('${annonce.titre}.pdf')
                                      ? IconButton(
                                          icon: Icon(Icons.share_outlined),
                                          onPressed: () async {
                                            await FlutterShare.shareFile(
                                              title: 'Example share',
                                              text: 'Example share text',
                                              filePath:
                                                  "${path.path}/${annonce.titre}.pdf",
                                            );
                                          },
                                        )
                                      : downloading
                                          ? Text(progressString)
                                          : Icon(Icons.download))
                            ],
                          ),
                        ),
                      ),
                    SizedBox(height: longeur / 50),
                    Divider(),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //   children: [
                    //     Text(
                    //       'publier par le ${annonce.auteur}',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //     Text(
                    //       'publier le ${annonce.datePublication}',
                    //       style: TextStyle(
                    //         color: Colors.white,
                    //       ),
                    //     ),
                    //   ],
                    // )
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: Text(
                            'publier par le ${annonce.auteur}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: Text(
                            'publier le ${annonce.datePublication}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
