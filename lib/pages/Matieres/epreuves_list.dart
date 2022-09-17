import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/pages/Matieres/matiereDetail.dart';

class Epreuves extends StatefulWidget {
  const Epreuves({Key? key}) : super(key: key);

  @override
  State<Epreuves> createState() => _EpreuvesState();
}

class _EpreuvesState extends State<Epreuves> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Liste des epreuves"),
        leading: HiddenDrawerIcon(
          mainIcon: Icon(Icons.menu),
        ),
      ),
      body: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: EdgeInsets.only(
                left: width / 25.0, right: width / 25.0, top: height / 6.0),
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
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pdf.webp'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Partiels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 15.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // color: Colors.blue,
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => MatiereDetails())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pdf.webp'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Rattrapages',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 15.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // color: Colors.blue,
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => MatiereDetails())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pdf.webp'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'Reprises',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 15.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // color: Colors.blue,
                  ),
                ),
                InkWell(
                  // onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (BuildContext context) => MatiereDetails())),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/pdf.webp'),
                          fit: BoxFit.cover),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        "Reprise - Rattrapage",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: width / 25.0,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black,
                              offset: Offset(5.0, 5.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // color: Colors.blue,
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
