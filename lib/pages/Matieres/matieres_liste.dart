import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/pages/Matieres/annees.dart';
import 'package:licence_mobile/pages/Matieres/cours_list.dart';
import 'package:licence_mobile/pages/Matieres/matiereDetail.dart';
import 'package:licence_mobile/widget/widget.dart';

class MatieresList extends StatefulWidget {
  const MatieresList({Key? key}) : super(key: key);

  @override
  State<MatieresList> createState() => _MatieresListState();
}

class _MatieresListState extends State<MatieresList> {
  List<Matiere> matieres = [];
  bool load = false;
  bool offline = true;

  checkOffline() async {
    if (await Widgets.checkConnexion()) {
      offline = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    load = true;
    Matiere.all().then((value) {
      for (var matiere in value) {
        matieres.add(matiere);
      }
      setState(() {
        load = false;
      });
    });
    // checkOffline();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return load
        ? Center(
            child: CircularProgressIndicator(),
          )
        // : offline
        //     ? Scaffold(
        //         appBar: AppBar(
        //           title: Text("Matières"),
        //         ),
        //         body: Center(
        //           child: Text("Vous n'êtes pas connecté à internet"),
        //         ),
        //       )
        : Scaffold(
            appBar: AppBar(
              title: Text("Liste des matières"),
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
                GridView.builder(
                    padding: EdgeInsets.all(width / 50.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: width / 50,
                      crossAxisSpacing: width / 50,
                    ),
                    itemCount: matieres.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Widgets.matiereCard(context, matieres[index]);
                    }),
              ],
            ));
  }
}
