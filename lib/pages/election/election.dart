import 'package:flutter/material.dart';
import 'package:licence_mobile/loginMiddle.dart';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/model/vote.dart';
import 'package:licence_mobile/pages/election/participant.dart';
import 'package:licence_mobile/pages/election/paticipant_liste.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';

class Election extends StatefulWidget {
  const Election({Key? key}) : super(key: key);

  @override
  State<Election> createState() => _ElectionState();
}

class _ElectionState extends State<Election> {
  var election;

  getData() async {
    await Widgets.getPref("election").then((data) {
      setState(() {
        election = data;
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
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Election de responssable"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (election != 'voter')
              InkWell(
                  onTap: () async {
                    if (election == "postulant") {
                      var postulant = await Vote.stat();
                      Widgets.navigate(
                          context, Participant(postulant: postulant));
                    } else {
                      Vote.postuler();
                      await Widgets.setPref('election', "postulant");
                      Widgets.navigate(context, LoginMiddle());
                    }
                  },
                  child: Widgets.cadPerso(
                      election == 'postulant'
                          ? "Mes statistiques"
                          : 'Postuler aux élections',
                      height,
                      width)),
            InkWell(
              onTap: () async {
                Widgets.navigate(context, PaticipantListe());
              },
              child: Widgets.cadPerso(
                  election == 'postulant'
                      ? "Statistiques globales"
                      : 'Voter un responssable',
                  height,
                  width,
                  color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}
