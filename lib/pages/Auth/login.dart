import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Center(
      child: Container(
        height: height / 2.0,
        width: width / 1.2,
        child: Card(
          elevation: 8.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Connexion',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: width / 20.0,
                      decoration: TextDecoration.underline)),
            ],
          ),
        ),
      ),
    ));
  }
}
