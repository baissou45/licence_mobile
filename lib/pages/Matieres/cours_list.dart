import 'package:flutter/material.dart';
import 'package:licence_mobile/pages/Matieres/matiereDetail.dart';

class ListCours extends StatelessWidget {
  // const ListCours({Key? key}) : super(key: key);
  // String title;
  // ListCours({required this.title});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cours de \"C++\""),
        centerTitle: true,
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
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => MatiereDetails())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Text(
                      "Introduction au C++",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.indigo,
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => MatiereDetails())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: Center(
                        child: Text(
                      'C++ programmation orientée objet',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )),
                    color: Colors.green[400],
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
