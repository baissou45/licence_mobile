import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  const NoInternet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Veuillez vérifier votre connexion internet"),
        Image.asset("assets/images/internet.jpg"),
        ElevatedButton(
            onPressed: () {}, child: Text("Accéder à la bibliotheque"))
      ],
    ));
  }
}
