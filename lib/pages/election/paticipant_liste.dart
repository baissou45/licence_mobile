import 'dart:async';

import 'package:flutter/material.dart';
import 'package:licence_mobile/bottom_nav.dart';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/model/vote.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';

class PaticipantListe extends StatefulWidget {
  const PaticipantListe({Key? key}) : super(key: key);

  @override
  PaticipantListeState createState() => PaticipantListeState();
}

class PaticipantListeState extends State<PaticipantListe> {
  List<User> participants = [];
  List votes = [];

  List votants = [];
  bool vote = false;
  num voteTotale = 0;
  bool load = true;

  getData() async {
    votants = await Vote.getVotes();
    print(votants);
    votants.sort(
        (b, a) => (int.parse(a['votes'])).compareTo(int.parse(b['votes'])));
    print(votants);
    for (var votant in votants) {
      voteTotale += int.parse(votant['votes']);
    }

    var _voteEtat = await Widgets.getPref('election');
    if (_voteEtat == "voter" || _voteEtat == "postulant") {
      setState(() {
        vote = true;
        load = false;
      });
    }
  }

  voter(_id) async {
    var result = await Vote.voter(_id);

    Widgets.setPref("election", "voter");
    setState(() {
      vote = true;
    });

    return result;
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: Text("Liste des paticipants")),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     // await Widgets.delPref("election");
      //     setState(() {
      //       vote = false;
      //     });
      //   },
      //   child: Icon(Icons.delete),
      //   backgroundColor: Colors.red,
      // ),
      body: load
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(width / 50.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: width / 50,
                  crossAxisSpacing: width / 50,
                  childAspectRatio: width / 730),
              itemCount: votants.length,
              // itemCount: participants.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Card(
                      elevation: 7.0,
                      child: Container(
                        height: height / 4.0,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/images/2.jpg"),
                          // image: NetworkImage(Api.externalGeturl() +
                          //     votants[index]['user'].img),
                          fit: BoxFit.cover,
                        )),
                        padding: EdgeInsets.all(8),
                      ),
                    ),
                    SizedBox(height: height / 100),
                    Text(
                        "${votants[index]['user'].nom} ${votants[index]['user'].prenom}"),
                    SizedBox(height: height / 100),
                    Text.rich(TextSpan(children: <TextSpan>[
                      TextSpan(
                          text: index == 0 ? "${index + 1}er" : "${index + 1}e",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: width / 25)),
                      TextSpan(text: ' evec '),
                      TextSpan(
                          text: votants[index]['votes'].toString(),
                          style: TextStyle(color: Colors.blue)),
                      TextSpan(text: ' vôtes sur '),
                      TextSpan(
                          text: voteTotale.toString(),
                          style: TextStyle(color: Colors.blue)),
                      const TextSpan(text: ' vôtants'),
                    ])),
                    ElevatedButton(
                        onPressed: () async {
                          if (!vote) {
                            var _data = await voter(votants[index]['user'].id);
                            if (_data['code'] == 200) {
                              Widgets.mySnack(
                                  context,
                                  '"Félicitation !!! Vous venez de vôter ${votants[index]['user'].nom} ${votants[index]['user'].prenom}"',
                                  "success");
                              Widgets.navigateAsolue(context, Botom_Nav());
                            } else {
                              Widgets.mySnack(context,
                                  "Désolé, une erreure est survenue", "error");
                            }
                          } else {
                            Widgets.mySnack(
                                context,
                                "Désolé, vous avez déjà fait votre vôte",
                                "error");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            primary: vote ? Colors.grey : Colors.blue),
                        child: Text("Voter ${votants[index]['user'].nom}"))
                  ],
                );
              }),
    );
  }
}
