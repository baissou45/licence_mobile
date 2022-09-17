import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hidden_drawer/flutter_hidden_drawer.dart';
import 'package:licence_mobile/bottom_nav.dart';
import 'package:licence_mobile/loginMiddle.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

Future<void> backgroundHandlerMessage(RemoteMessage message) async {
  print(message.notification);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandlerMessage);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: LoginMiddle(),
      // navigateRoute: Connexion(),
      duration: 5000,
      imageSize: 130,
      pageRouteTransition: PageRouteTransition.CupertinoPageRoute,
      imageSrc: "assets/images/logo.png",
      text: "SGIME - Etudiants",
      textType: TextType.TyperAnimatedText,
      textStyle: TextStyle(
        fontSize: 30.0,
      ),
      colors: [
        Colors.purple,
        Colors.blue,
        Colors.yellow,
        Colors.red,
      ],
      backgroundColor: Colors.white,
    );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => DrawerMenuState(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Licence Mobile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: example1,
        home: Botom_Nav(),
        // home: Activite(type: "ex"),
      ),
    );
  }
}
