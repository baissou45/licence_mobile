import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/pages/Matieres/epreuves_list.dart';

class Annees extends StatelessWidget {
  const Annees({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Choix de la promotion"),
        automaticallyImplyLeading: false,
        leading: HiddenDrawerIcon(
          mainIcon: Icon(Icons.menu),
        ),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: width / 45.0,
              mainAxisSpacing: width / 45.0,
              crossAxisCount: 2,
              children: <Widget>[
                InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Epreuves())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Text(
                      '2020 - 2021',
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.cyan,
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => Matiere())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Text(
                      '2018 - 2019',
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.green[400],
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => Matiere())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Text(
                      "2017 - 2018",
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.indigo,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
