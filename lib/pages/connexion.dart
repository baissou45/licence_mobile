import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:licence_mobile/loginMiddle.dart';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/service/db.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Connexion extends StatefulWidget {
  @override
  _ConnexionState createState() => _ConnexionState();
}

class _ConnexionState extends State<Connexion> {
  final GlobalKey<FormState> _formController = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldController =
      GlobalKey<ScaffoldState>();

  final TextEditingController _matriculeController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldController,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/4.jpg"),
                    fit: BoxFit.cover)),
          ),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: largeur / 15, vertical: longeur / 15),
                  child: Column(
                    children: [
                      Card(
                        elevation: 20,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 50.0),
                          child: Form(
                            key: _formController,
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: largeur / 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Connexion",
                                    style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: longeur / 20.0,
                                  ),
                                  TextFormField(
                                    controller: _matriculeController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Veuillez saisir vote matricule";
                                      } else if (value.length < 8) {
                                        return "Enter 8 chiffres minimum";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(CupertinoIcons.number),
                                        labelText: 'N° Matricule',
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(height: longeur / 100.0),
                                  TextFormField(
                                    obscureText: true,
                                    controller: _passController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Veuillez entrer votre mot de passe";
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.lock_outline,
                                        ),
                                        labelText: "Mot de passe",
                                        border: OutlineInputBorder()),
                                  ),
                                  SizedBox(
                                    height: longeur / 20.0,
                                  ),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.0)))),
                                    onPressed: () async {
                                      if (_formController.currentState!
                                          .validate()) {
                                        // try {
                                        // String value =
                                        //     await Widgets.getPref('token');
                                        var data = await Api.post({
                                          'email': _matriculeController.text,
                                          'pass': _passController.text
                                        }, 'users/login');

                                        if (data['code'] == 200) {
                                          Widgets.setPref('token',
                                              data['data']['data']['token']);
                                          Widgets.setPref(
                                              'role',
                                              data['data']['data']['user']
                                                  ['role']);
                                          Widgets.mySnack(
                                              context,
                                              data['data']["0"]['message'],
                                              "success");
                                          Widgets.navigate(
                                              context, LoginMiddle());
                                        } else {
                                          Widgets.mySnack(context,
                                              data['data']['message'], "error");
                                        }
                                      }
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: largeur / 7),
                                        child: Text('Se Connecter')),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: longeur / 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
