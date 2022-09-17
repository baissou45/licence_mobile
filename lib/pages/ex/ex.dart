import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:licence_mobile/service/local_notification.dart';

class Ex extends StatefulWidget {
  const Ex({Key? key}) : super(key: key);

  @override
  ExState createState() => ExState();
}

class ExState extends State<Ex> {
  String message = "RAS";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(message),
      ),
    );
  }
}
