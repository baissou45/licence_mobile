import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/model/pdf.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';
// import 'package:flutter_share/flutter_share.dart';

class Pdf extends StatefulWidget {
  Pdf({required this.matiere, required this.type});
  Matiere matiere;
  String type;

  @override
  PdfState createState() {
    return PdfState(matiere: matiere, type: type);
  }
}

class PdfState extends State<Pdf> {
  String type;
  Matiere matiere;

  PdfState({required this.matiere, required this.type});

  final imgUrl = "http://www.cplusplus.com/files/tutorial.pdf";
  var path;
  bool offline = false;
  Map downloading = {};
  Map progressString = {};
  List<Fichier> pdfs = [];
  List files = [];

  getData() async {
    path = await getExternalStorageDirectory();
    List<FileSystemEntity> _folders =
        await path!.listSync(recursive: true, followLinks: false);
    if (_folders.isNotEmpty) {
      for (var folder in _folders) {
        await folder.stat().then((value) {
          if (value.type.toString() == "file") {
            List _datas = folder.path.split('/');
            setState(() {
              files.add(_datas[_datas.length - 1]);
            });
          }
        });
      }
    }
    if (await Widgets.checkConnexion()) {
      offline = false;
      await Fichier.all().then((value) {
        setState(() {
          pdfs = value;
        });
      });
    } else {
      offline = true;
      files.forEach((file) {
        List _tmpFile = file.toString().split('.');
        setState(() {
          pdfs.add(Fichier(titre: file));
        });
      });
    }
    for (var i = 0; i < pdfs.length; i++) {
      downloading[i] = false;
      progressString[i] = "0%";
    }
  }

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

  // getPath() async {
  //   var dir = await getExternalStorageDirectory();
  //   List dirs = dir!.path.split('/');
  //   for (int i = 1; i < dirs.length; i++) {
  //     if (dirs[i] == 'Android') {
  //       break;
  //     }
  //     path += dirs[i];
  //   }
  //   // print(path);
  //   // path = await getApplicationDocumentsDirectory();
  //   // if (!await path.exists()) {
  //   new Directory(path + '/' + 'Licence')
  //       .create(recursive: true)
  //       .then((Directory directory) {
  //     print('Path of New Dir: ' + directory.path);
  //   });
  //   // }
  // }

  @override
  void initState() {
    super.initState();

    getData();
    // getPath();
  }

  // Future<void> downloadFile() async {
  //   Dio dio = Dio();

  //   try {
  //     var dir = await getExternalStorageDirectory();
  //     // PathProvider

  //     final status = await Permission.storage.request();
  //     print(dir!.path);
  //     if (status.isGranted) {
  //       // await dio.download(imgUrl, "${dir.path}/C-Tut-4.02.pdf",
  //       await dio.download(imgUrl, "${dir.path}/tutorial.pdf",
  //           onReceiveProgress: (rec, total) {
  //         print("Rec: $rec , Total: $total " +
  //             ((rec / total) * 100).toStringAsFixed(0) +
  //             "%");

  //         setState(() {
  //           downloading = true;
  //           progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
  //         });
  //       });
  //     }
  //   } catch (e) {
  //     print(e);
  //   }

  //   setState(() {
  //     downloading = false;
  //     progressString = "Completed";
  //   });
  //   print("Download completed");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("${matiere.libelle} ($type)"),
          centerTitle: true,
          elevation: 5.0,
        ),
        body: Stack(children: [
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
          pdfs.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: pdfs.length,
                  itemBuilder: (BuildContext context, int index) {
                    // downloading[index] = false;
                    // progressString;
                    return Card(
                      elevation: 5.0,
                      margin: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 50),
                      child: Container(
                        color: files.contains('${pdfs[index].titre}.pdf') ||
                                offline
                            ? Colors.greenAccent
                            : Colors.white,
                        height: MediaQuery.of(context).size.height / 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            files.contains('${pdfs[index].titre}.pdf') ||
                                    offline
                                ? IconButton(
                                    onPressed: () async {
                                      if (files.contains(
                                          '${pdfs[index].titre}.pdf')) {
                                        await OpenFile.open(
                                            '${path!.path}/${pdfs[index].titre}.pdf');
                                      }
                                    },
                                    icon: Icon(Icons.remove_red_eye_outlined))
                                : Icon(
                                    Icons.picture_as_pdf_outlined,
                                    color: Colors.red,
                                  ),
                            InkWell(
                              onTap: () async {
                                if (files
                                    .contains('${pdfs[index].titre}.pdf')) {
                                  await OpenFile.open(
                                      '${path!.path}/${pdfs[index].titre}.pdf');
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width / 1.5,
                                child: Text(
                                  pdfs[index].titre,
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
                                        downloading[index] = true;
                                      });
                                      await dio.download(
                                          Api.externalGeturl() +
                                              pdfs[index].fichier,
                                          // 'http://10.0.2.2:8000/pdf/cv.pdf',
                                          "${path!.path}/${pdfs[index].titre}.pdf",
                                          onReceiveProgress: (rec, total) {
                                        setState(() {
                                          progressString[index] =
                                              ((rec / total) * 100)
                                                      .toStringAsFixed(0) +
                                                  "%";
                                        });
                                      });
                                    }
                                    setState(() {
                                      downloading[index] = false;
                                      progressString[index] = "Completed";
                                      files.add('${pdfs[index].titre}.pdf');
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
                                child: files.contains(
                                            '${pdfs[index].titre}.pdf') ||
                                        offline
                                    ? IconButton(
                                        icon: Icon(Icons.share_outlined),
                                        onPressed: () async {
                                          await FlutterShare.shareFile(
                                            title: 'Example share',
                                            text: 'Example share text',
                                            filePath:
                                                "${path!.path}/${pdfs[index].titre}.pdf",
                                          );
                                        },
                                      )
                                    : downloading[index]
                                        ? Text(progressString[index])
                                        : Icon(Icons.download))
                          ],
                        ),
                      ),
                    );
                  })
        ]));
  }
}






  // void _download() async {
  //   final status = await Permission.storage.request();
  //   if (status.isGranted) {
  //     final baseStorage = await getExternalStorageDirectory();
  //     final id = FlutterDownloader.enqueue(
  //         url: "http://www.cplusplus.com/files/tutorial.pdf",
  //         savedDir: baseStorage!.path,
  //         openFileFromNotification: true,
  //         showNotification: true,
  //         saveInPublicStorage: true,
  //         fileName: 'file');
  //     print("perm");
  //   } else {
  //     print("No permission");
  //   }
  // }