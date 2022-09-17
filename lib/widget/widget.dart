import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/pages/Matieres/matiereDetail.dart';
import 'package:licence_mobile/pages/Annonce/newPost.dart';
import 'package:licence_mobile/pages/election/election.dart';
import 'package:licence_mobile/pages/election/participant.dart';
import 'package:licence_mobile/pages/election/paticipant_liste.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Widgets {
  static Widget studentDawer(var context, change) {
    TextEditingController _promoController = TextEditingController();

    List promotions;
    var promotion;

    getdata() async {
      final List<Map<String, dynamic>> _items = [];
      //   Widgets.getPref('promotions').then((value) {
      //     print(value);
      //     promotions = jsonDecode(value);
      //     for (var promo in promotions) {
      //       _items.add({
      //         'value': promo.promo,
      //         'label': promo.filiere,
      //         'icon': Icon(Icons.arrow_forward_outlined)
      //       });
      //     }
      //   });
      //   Widgets.getPref('promotion').then((value) {
      //     _promoController.text = value.filiere;
      //   });

      promotions = await Widgets.getPref('promotions');
      promotion = await Widgets.getPref('promotion');
      _promoController.text = promotion.filiere;
      for (var promo in promotions) {
        _items.add({
          'value': promo.promo,
          'label': promo.filiere,
          'icon': Icon(Icons.arrow_forward_outlined)
        });
      }

      return _items;
    }

    return HiddenDrawerMenu(
      // drawerDecoration: BoxDecoration(color: Colors.grey),
      drawerDecoration: BoxDecoration(color: Colors.blue),
      menuColor: Colors.white,
      menuActiveColor: Colors.white54,
      menu: <DrawerMenu>[
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Accueil",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              change(0);
            }),
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Liste des matières",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              change(1);
            }),
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Election de responsable",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () async {
              var election;
              election = await Widgets.getPref("election");
              if (election == "voter") {
                Widgets.navigate(context, PaticipantListe());
              } else {
                Widgets.navigate(context, Election());
              }
            }),
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Nouveau communiqué",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              Widgets.navigate(context, NewCommunique());
            }),
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Emploi du temps",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              change(2);
            }),
        // DrawerMenu(
        //     child: Padding(
        //       padding: EdgeInsets.all(16.0),
        //       child: Text("Faire une réclammation"),  //     ),
        //     onPressed: () {
        //       change(1);
        //     }),
        DrawerMenu(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "FAQ",
                // style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: () {
              change(1);
            }),
      ],
      header: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height / 10,
            left: MediaQuery.of(context).size.width / 30),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/logo.png'),
          // minRadius: MediaQuery.of(context).size.width / 1000,
          maxRadius: MediaQuery.of(context).size.width / 8,
        ),
      ),
      // footer: Container(
      //   child: SelectFormField(
      //     type: SelectFormFieldType.dialog,
      //     controller: _promoController,
      //     dialogTitle: 'Type de communiqué',
      //     dialogCancelBtn: 'Annuler',
      //     items: _items,
      //     // onChanged: (val) => setState(() => _matiereController.text = val),
      //     // onChanged: (val) => setState(() => _matiereController.text = val),
      //     validator: (val) {
      //       if (val!.isEmpty) {
      //         return "Le type est obligatoire";
      //       }
      //     },
      //     // onSaved: (val) =>
      //     //     setState(() => _matiereController.text = val ?? ''),
      //     decoration: InputDecoration(
      //       border: OutlineInputBorder(),
      //       suffixIcon: Icon(Icons.arrow_drop_down),
      //       // label: Text("Type"),
      //     ),
      //   ),
      // )
    );
  }

  static Card cadPerso(String text, height, width,
      {Color color = Colors.blue}) {
    return Card(
      color: color,
      child: Container(
        height: height / 6,
        width: width / 1.6,
        child: Center(
            child: Text(
          text,
          style: TextStyle(color: Colors.white),
        )),
      ),
    );
  }

  static navigate(context, to) {
    return Navigator.of(context)
        .push((MaterialPageRoute(builder: (BuildContext context) => to)));
  }

  static navigateAsolue(context, to) {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => to),
        (route) => false);
  }

  static setPref(String key, String value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key, value);
  }

  static getPref(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = await preferences.get(key);
    return data;
  }

  static setIntPref(String key, int value) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt(key, value);
  }

  static getAllPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getKeys();
  }

  static delPref(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(key);
  }

  static clearPref(String key) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  static getPromotion() async {
    return await Widgets.getPref('promotion');
  }

  static bouttonAccueuil(
      var filtreAnnonce, String type, height, widht, couleur) {
    return InkWell(
      onTap: () {
        switch (type) {
          case 'Tout':
            filtreAnnonce('Tout');
            break;

          case 'Tp':
            filtreAnnonce('tp');
            break;

          case 'Générale':
            filtreAnnonce('generale');

            break;

          case 'Exercice':
            filtreAnnonce('excercice');
            break;

          default:
        }
      },
      child: Card(
        elevation: 8.0,
        child: Container(
          color: couleur,
          height: height / 15,
          width: widht / 4.7,
          child: Center(
              child: Text(
            type,
            style: TextStyle(color: Colors.white),
          )),
        ),
      ),
    );
  }

  static matiereCard(var context, Matiere matiere) {
    List couleurs = [
      Colors.indigo,
      Colors.green,
      Colors.cyan,
      Colors.amber,
      Colors.purple,
      Colors.red
    ];
    int randomIndex = Random().nextInt(couleurs.length);

    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => MatiereDetails(matiere: matiere))),
      child: Card(
        elevation: 8.0,
        child: Container(
          padding: EdgeInsets.all(8),
          child: Center(
              child: Text(
            matiere.libelle,
            style: TextStyle(color: Colors.white),
          )),
          color: couleurs[randomIndex],
        ),
      ),
    );
  }

  static Future<bool> checkConnexion() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }

  static mySnack(var context, String message, String type) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: type == "success" ? Colors.green : Colors.red,
        content: Text(
          message,
          textAlign: TextAlign.center,
        )));
  }
}
