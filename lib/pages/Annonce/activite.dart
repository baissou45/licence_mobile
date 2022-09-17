import 'package:flutter/material.dart';
import 'package:licence_mobile/model/annonce.dart';
import 'package:licence_mobile/pages/Annonce/annonce.dart';
import 'package:licence_mobile/service/api.dart';

class Activite extends StatefulWidget {
  // const Activite({Key? key}) : super(key: key);
  Activite({required this.type, required this.matiere});
  String type;
  String matiere;

  @override
  State<Activite> createState() => _ActiviteState(type: type, matiere: matiere);
}

class _ActiviteState extends State<Activite> {
  String type;
  String matiere;
  _ActiviteState({required this.type, required this.matiere});

  late List<Annonce> annonces;
  bool load = true;
  late var externaLink;

  getData() async {
    // await Annonce.categorie(type).then((_annonces) {
    externaLink = await Api.externalGeturl();
    Annonce.categorie(type).then((_annonces) {
      setState(() {
        annonces = _annonces;
        load = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double widht = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("$matiere ($type)"),
      ),
      body: load
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.only(top: 0),
              physics: NeverScrollableScrollPhysics(),
              itemCount: annonces.length,
              shrinkWrap: true,
              itemBuilder: (context, index) => Card(
                color: Colors.white70,
                elevation: 8.0,
                margin: EdgeInsets.only(top: height / 80, bottom: height / 80),
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
                                        externaLink + "${annonces[index].img}",
                                        height: height / 3,
                                        fit: BoxFit.contain,
                                      ),
                                    ))),
                          // : Hero(
                          //     tag: "photo ${annonces[index].id}",
                          //     child: Image.network(annonces[index].fichier)),
                          SizedBox(height: height / 80),
                          Text(annonces[index].description),
                          SizedBox(height: height / 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Publier par ${annonces[index].auteur}"),
                              Text(
                                  "Publier le ${annonces[index].datePublication}"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
