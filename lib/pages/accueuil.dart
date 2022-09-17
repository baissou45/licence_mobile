import 'dart:convert';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:licence_mobile/loginMiddle.dart';
// import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:licence_mobile/model/annonce.dart';
import 'package:licence_mobile/pages/Annonce/annonce.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  TextEditingController _promoController = TextEditingController();
  late Future<List<Annonce>> annonces;
  final List<Map<String, dynamic>> _items = [];
  bool charge = false;
  List promotions = [];
  var promotion;
  late String externaLink;
  // bool offline = true;

  // offflineCeck() async {
  //   if (await Widgets.checkConnexion()) {
  //     setState(() {
  //       offline = false;
  //     });
  //   }
  // }

  getData() async {
    promotions = jsonDecode(await Widgets.getPref('promotions'));
    var _promotion = jsonDecode(await Widgets.getPref('promotion'));
    externaLink = await Api.externalGeturl();
    setState(() {
      promotion = _promotion;
    });
    for (var promo in promotions) {
      _items.add({
        'value': jsonEncode(promo),
        'label': promo['filiere'],
        'icon': Icon(Icons.arrow_forward_outlined),
        // 'enable': promo['promo'] != promotion['promo'] ? true : false
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // offflineCeck();
    getData();
    annonces = Annonce.all();
    // permRequest();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;

    void filtreAnnonce(String type) async {
      setState(() {
        if (type == 'Tout') {
          annonces = Annonce.all();
        } else {
          annonces = Annonce.categorie(type);
        }
      });
    }

    Container headerWidget(BuildContext context) => Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Widgets.bouttonAccueuil(
                  filtreAnnonce, "Tout", height, widht, Colors.blue[800]),
              Widgets.bouttonAccueuil(
                  filtreAnnonce, "Générale", height, widht, Colors.teal),
              Widgets.bouttonAccueuil(
                  filtreAnnonce, "Exercice", height, widht, Colors.cyan[600]),
              Widgets.bouttonAccueuil(
                  filtreAnnonce, "Tp", height, widht, Colors.orange[600]),
            ],
          ),
        );

    ListView listView(List<Annonce> annonces) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 0),
        physics: NeverScrollableScrollPhysics(),
        itemCount: annonces.length,
        shrinkWrap: true,
        itemBuilder: (context, index) => Card(
          color: Colors.white70,
          margin: EdgeInsets.only(bottom: height / 40),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: widht / 50, vertical: height / 50),
            child: InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => AnnonceDetail(
                        annonce: annonces[index],
                      ))),
              child: ListTile(
                title: Text(
                  annonces[index].titre + ' ( ${annonces[index].type} )',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[800],
                  ),
                ),
                subtitle: Column(
                  children: [
                    SizedBox(height: height / 50),
                    if (annonces[index].img != 'null')
                      Hero(
                          tag: "photo ${annonces[index].id}",
                          child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                child: Image.network(
                                  // "assets/images/img.jpg",
                                  // "http://10.0.2.2:8000/${annonces[index].img}",
                                  externaLink + "${annonces[index].img}",
                                  fit: BoxFit.contain,
                                ),
                              ))),
                    SizedBox(height: height / 80),
                    // Text(annonces[index].description),
                    HtmlWidget(annonces[index].description),
                    SizedBox(height: height / 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: widht / 2.2,
                          child: Text("Publier par ${annonces[index].auteur}"),
                        ),
                        Container(
                          width: widht / 2.5,
                          child: Text(
                              "Publier le ${annonces[index].datePublication}"),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    func() {
      return
          // offline
          //     ? Center(
          //         child: Padding(
          //             padding: EdgeInsets.only(top: height / 5.0),
          //             child: Text("Vous n'avez pas access à interrnet")),
          //       )
          //     :
          FutureBuilder<List<Annonce>>(
        future: annonces,
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: height / 2.5,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.only(top: height / 20),
                child: Text(
                  'Echec de connexion au serveur, Veuillez vérifier votre connexion internet',
                  textAlign: TextAlign.center,
                ),
              );
            } else if (snapshot.hasData) {
              List<Annonce>? data = snapshot.data;
              return listView(data!);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.grey,
      // ),
      home: Scaffold(
          body: DraggableHome(
        leading: HiddenDrawerIcon(
          backIcon: null,
          mainIcon: Icon(Icons.menu),
        ),
        title: Text("Accueil"),
        actions: [
          IconButton(
              onPressed: () {
                filtreAnnonce('Tout');
              },
              icon: Icon(Icons.refresh)),
        ],
        headerWidget: headerWidget(context),
        headerBottomBar: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: widht / 20.0),
                margin: EdgeInsets.symmetric(vertical: height / 90.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.0),
                        bottomRight: Radius.circular(40.0),
                        topLeft: Radius.circular(40.0),
                        bottomLeft: Radius.circular(40.0))),
                // color: Colors.white,
                child: Align(
                  child: SelectFormField(
                    type: SelectFormFieldType.dialog,
                    // type: SelectFormFieldType.dropdown,
                    controller: _promoController,
                    dialogTitle: 'Choisissez votre promotion',
                    dialogCancelBtn: 'Annuler',
                    items: _items,
                    onChanged: (val) async {
                      await Widgets.setPref('promotion', val);
                      Widgets.navigate(context, LoginMiddle());
                    },
                    decoration: InputDecoration(
                      hintText: promotion == null
                          ? "Promotion"
                          : promotion['filiere'].toString(),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: widht / 15.0),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications,
                  color: Colors.white,
                )),
            IconButton(
                onPressed: () async {
                  Widgets.delPref('token');
                  Widgets.navigate(context, LoginMiddle());
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ))
          ],
        ),
        body: [
          // listView(),
          func(),
        ],
        fullyStretchable: true,
        expandedBody: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Taïrou Baïssou",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                "18254587",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Text(
                "ENEAM - IG3",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              Image.asset("assets/images/img.jpg"),
              // Image.network("https://pngimg.com/uploads/qr_code/qr_code_PNG3.png"),
            ],
          ),
        )),
      )),
    );
  }
}
