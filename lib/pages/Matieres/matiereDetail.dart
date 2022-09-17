import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/pages/Annonce/activite.dart';
import 'package:licence_mobile/pages/Matieres/annees.dart';
import 'package:licence_mobile/pages/Matieres/cours_list.dart';
import 'package:licence_mobile/pages/pdf/pdf.dart';

class MatiereDetails extends StatelessWidget {
  late Matiere matiere;
  MatiereDetails({required this.matiere});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text(matiere.libelle),
          centerTitle: true,
          leading: HiddenDrawerIcon(
            mainIcon: Icon(Icons.menu),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.4), BlendMode.luminosity),
                  image: AssetImage("assets/images/books.jpeg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: height / 50.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        color: Colors.blue[700],
                        elevation: 9.0,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: height / 50.0),
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  "Masse Horaire",
                                  style: TextStyle(
                                    // color: Colors.blue,
                                    color: Colors.white,
                                    fontSize: width / 15,
                                  ),
                                ),
                                SizedBox(height: height / 80.0),
                                Row(
                                  children: [
                                    Container(
                                      width: width / 3.1,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Total",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            matiere.heure.toString(),
                                            style: TextStyle(
                                                color: Colors.white70),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width / 3.1,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Consommée",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            matiere.heureConsommee.toString(),
                                            style: TextStyle(
                                                color: Colors.white70),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: width / 3.1,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Restante",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Text(
                                            (matiere.heure -
                                                    matiere.heureConsommee)
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white70),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height / 50.0),
                                Text(
                                  "Enseignant",
                                  style: TextStyle(
                                    // color: Colors.blue,
                                    color: Colors.white,
                                    fontSize: width / 15,
                                  ),
                                ),
                                SizedBox(height: height / 100.0),
                                Text(
                                  "${matiere.enseignant.nom + ' ' + matiere.enseignant.prenom}",
                                  style: TextStyle(
                                      fontSize: width / 25.0,
                                      color: Colors.white70),
                                ),
                                SizedBox(height: height / 300.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      // width: width / 2.1,
                                      child: Text(
                                        // "Mail : ${matiere.enseignant.mail}",
                                        matiere.enseignant.mail,
                                        style: TextStyle(
                                            fontSize: width / 25.0,
                                            color: Colors.white70),
                                      ),
                                    ),
                                    Container(
                                      // width: width / 2.1,
                                      child: Text(
                                        matiere.enseignant.tel,
                                        style: TextStyle(
                                            fontSize: width / 25.0,
                                            color: Colors.white70),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height / 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Pdf(matiere: matiere, type: "Cours"))),
                            child: Container(
                              // padding: EdgeInsets.all(8),
                              width: width / 2.2,
                              height: height / 4,
                              child: Center(
                                  child: Text(
                                "Cours",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 23.0),
                              )),
                              color: Colors.indigo,
                            ),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Activite(
                                        type: 'ex', matiere: matiere.libelle))),
                            child: Container(
                              // padding: EdgeInsets.all(8),
                              height: height / 4,
                              width: width / 2.2,
                              child: Center(
                                  child: Text(
                                'Exercices',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 23.0),
                              )),
                              color: Colors.green[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height / 50.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) => Activite(
                                        type: 'tp', matiere: matiere.libelle))),
                            child: Container(
                              // padding: EdgeInsets.all(8),
                              height: height / 4,
                              width: width / 2.2,
                              child: Center(
                                  child: Text(
                                'Traveaux pratique',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 23.0),
                              )),
                              color: Colors.cyan[700],
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) => Pdf(
                                          matiere: matiere,
                                          type: "Epreuves",
                                        ))),
                            child: Container(
                              // padding: EdgeInsets.all(8),
                              height: height / 4,
                              width: width / 2.2,
                              child: Center(
                                  child: Text(
                                'Epreuves',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width / 23.0),
                              )),
                              color: Colors.red[700],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
