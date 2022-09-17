import 'package:flutter/material.dart';

class Participant extends StatelessWidget {
  // const Participant({Key? key}) : super(key: key);
  var postulant;
  Participant({required this.postulant});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Candidat : ${postulant['user'].nom} ${postulant['user'].prenom}"),
      ),
      body: Center(
        child: Column(
          children: [
            Card(
              elevation: 8.0,
              child: Container(
                height: height / 1.5,
                width: width,
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage('assets/images/3.jpg')),
                  // DecorationImage(
                  //     image: NetworkImage(postulant['user'].img)),
                ),
              ),
            ),
            SizedBox(height: height / 50),
            Text.rich(TextSpan(children: <TextSpan>[
              TextSpan(
                  text:
                      postulant['rang'] == 1 ? "1er" : "${postulant['rang']}e",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: width / 25)),
              TextSpan(text: ' evec '),
              TextSpan(
                  text: postulant['vote(s)'].toString(),
                  style: TextStyle(color: Colors.blue)),
              TextSpan(text: ' vôtes sur '),
              TextSpan(
                  text: postulant['total'].toString(),
                  style: TextStyle(color: Colors.blue)),
              TextSpan(text: ' au total.'),
            ])),
          ],
        ),
      ),
    );
  }
}
