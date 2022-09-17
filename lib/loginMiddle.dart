// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:licence_mobile/bottom_nav.dart';
import 'package:licence_mobile/pages/connexion.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/service/local_notification.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LoginMiddle extends StatefulWidget {
  const LoginMiddle({Key? key}) : super(key: key);

  @override
  _LoginMiddleState createState() => _LoginMiddleState();
}

class _LoginMiddleState extends State<LoginMiddle> {
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  String message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    redirect();

    LocalNotificationService.initialise();

    FirebaseMessaging.instance.getInitialMessage().then((event) {
      if (event != null) {
        setState(() {
          message = event.notification!.body.toString();
        });
      }
    });

    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.showNotificationOnForground(event);
      setState(() {
        message = event.notification!.body.toString();
      });
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      setState(() {
        message = event.notification!.body.toString();
      });
    });
  }

  topicSuscribe(String filiere, String promotion) {
    firebaseMessaging.subscribeToTopic('all');
    firebaseMessaging.subscribeToTopic(filiere);
    firebaseMessaging.subscribeToTopic(promotion);
  }

  @override
  redirect() async {
    // await Widgets.delPref('promotion');
    var token = await Widgets.getPref('token');
    if (token == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Connexion()),
          (route) => false);
    } else {
      List promotions = await Api.get('users/promotions');
      String role = await Api.get('users/role');

      await Widgets.setPref('role', role);
      await Widgets.setPref('promotions', jsonEncode(promotions));

      var data = await Widgets.getPref('promotion');

      if (data == null) {
        await Widgets.setPref('promotion', jsonEncode(promotions.last));
        var _data = promotions.last['filiere'].split("-");

        firebaseMessaging.getToken();

        firebaseMessaging.subscribeToTopic('all');
        firebaseMessaging.subscribeToTopic(_data[0] + "-" + _data[1][0]);
        firebaseMessaging.subscribeToTopic(_data[0]);
      }

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => Botom_Nav()),
          (route) => false);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
