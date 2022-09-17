import 'dart:async';
import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:licence_mobile/loginMiddle.dart';
import 'package:licence_mobile/model/annonce.dart';
import 'package:licence_mobile/model/matiere.dart';
import 'package:licence_mobile/pages/accueuil.dart';
import 'package:licence_mobile/widget/widget.dart';
import 'package:select_form_field/select_form_field.dart';

class NewCommunique extends StatefulWidget {
  const NewCommunique({Key? key}) : super(key: key);

  @override
  _NewCommuniqueState createState() => _NewCommuniqueState();
}

class _NewCommuniqueState extends State<NewCommunique> {
  final GlobalKey<FormState> _formController = GlobalKey<FormState>();

  TextEditingController _titreController = TextEditingController();
  TextEditingController _matiereController = TextEditingController();
  TextEditingController _typeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  late String matiere;
  List<Matiere> matieres = [];
  List<Map<String, dynamic>> listMatiere = [];

  final List<Map<String, dynamic>> _items = [
    {
      'value': 'general',
      'label': 'Géneral',
      'icon': Icon(Icons.arrow_forward_outlined)
    },
    {
      'value': 'excercice',
      'label': 'Exercice',
      'icon': Icon(Icons.arrow_forward_outlined)
    },
    {
      'value': 'tp',
      'label': 'Traveaux pratique',
      'icon': Icon(Icons.arrow_forward_outlined)
    },
    {
      'value': 'cours',
      'label': 'Cours',
      'icon': Icon(Icons.arrow_forward_outlined)
    }
  ];

  getData() async {
    matieres = await Matiere.all();
    for (var matiere in matieres) {
      listMatiere.add({
        'value': matiere.libelle,
        'label': matiere.libelle,
        'icon': Icon(Icons.menu_book_rounded)
      });
    }
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
    double widht = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: Text("Ajouter un communiqué"),
        ),
        body: Stack(children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.4), BlendMode.luminosity),
                // image: AssetImage("assets/images/books.jpeg"),
                image: AssetImage("assets/images/com.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
                child: Form(
                    key: _formController,
                    child: Card(
                      elevation: 5.0,
                      margin: EdgeInsets.symmetric(
                          horizontal: widht / 30.0, vertical: height / 30.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: widht / 30.0, vertical: height / 30.0),
                        child: Column(
                          children: [
                            Text(
                              "Nouveau communiqué",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: widht / 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: height / 25.0),
                            TextFormField(
                              controller: _titreController,
                              validator: (value) {
                                if (value!.length <= 0) {
                                  return 'Le titre du communiqué est obligatoire';
                                }
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Titre'),
                              ),
                            ),
                            SizedBox(height: height / 50.0),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: widht / 2.4,
                                    child: SelectFormField(
                                      type: SelectFormFieldType.dialog,
                                      enabled: (_typeController.text ==
                                                  "excercice" ||
                                              _typeController.text == "tp" ||
                                              _typeController.text == "cours")
                                          ? true
                                          : false,
                                      controller: _matiereController,
                                      dialogTitle: 'Matière concernée',
                                      dialogCancelBtn: 'Annuler',
                                      items: listMatiere,
                                      onChanged: (val) => setState(
                                          () => _matiereController.text = val),
                                      onSaved: (val) => setState(() =>
                                          _matiereController.text = val ?? ''),
                                      style: TextStyle(
                                          color: (_typeController.text ==
                                                      "excercice" ||
                                                  _typeController.text ==
                                                      "tp" ||
                                                  _typeController.text ==
                                                      "cours")
                                              ? Colors.black
                                              : Colors.grey[400]),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        label: Text(
                                          "Matière",
                                          style: TextStyle(
                                              color: (_typeController.text ==
                                                          "excercice" ||
                                                      _typeController.text ==
                                                          "tp" ||
                                                      _typeController.text ==
                                                          "cours")
                                                  ? Colors.black
                                                  : Colors.grey[400]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: widht / 2.4,
                                    child: SelectFormField(
                                      type: SelectFormFieldType.dialog,
                                      controller: _typeController,
                                      dialogTitle: 'Type de communiqué',
                                      dialogCancelBtn: 'Annuler',
                                      items: _items,
                                      onChanged: (val) => setState(
                                          () => _matiereController.text = val),
                                      validator: (val) {
                                        if (val!.isEmpty) {
                                          return "Le type est obligatoire";
                                        }
                                      },
                                      onSaved: (val) => setState(() =>
                                          _matiereController.text = val ?? ''),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        suffixIcon: Icon(Icons.arrow_drop_down),
                                        label: Text("Type"),
                                      ),
                                    ),
                                  )
                                ]),
                            SizedBox(height: height / 50.0),
                            TextFormField(
                              controller: _descriptionController,
                              minLines: 3,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                label: Text('Description du communiqué'),
                              ),
                            ),
                            // SizedBox(height: height / 50.0),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                            //   children: [
                            //     ElevatedButton.icon(
                            //         onPressed: () {},
                            //         icon: Icon(Icons.photo_camera_outlined),
                            //         label: Text("Ajouter une photo")),
                            //     ElevatedButton.icon(
                            //         style: ButtonStyle(
                            //             backgroundColor: ),
                            //         onPressed: () {},
                            //         icon: Icon(Icons.picture_as_pdf_outlined),
                            //         label: Text("PDF"))
                            //   ],
                            // ),
                            SizedBox(height: height / 50.0),
                            ElevatedButton(
                                onPressed: () async {
                                  if (_formController.currentState!
                                      .validate()) {
                                    Map data = {
                                      'titre': _titreController.text,
                                      'matiere': _matiereController.text,
                                      'type': _typeController.text,
                                      'description':
                                          _descriptionController.text,
                                      'promotion': jsonDecode(
                                              await Widgets.getPref(
                                                  'promotion'))['promo']
                                          .toString(),
                                    };
                                    var res = await Annonce.create(data);
                                    print(data);
                                    if (res['code'] == 200) {
                                      Widgets.mySnack(context,
                                          res['data']['data'], "success");
                                      Timer(
                                          Duration(seconds: 2),
                                          Widgets.navigateAsolue(
                                              context, LoginMiddle()));
                                    } else {
                                      Widgets.mySnack(context,
                                          res['data']['data'], "error");
                                    }
                                  }
                                },
                                child: Text('Passez le communiqué'))
                          ],
                        ),
                      ),
                    ))),
          ),
        ]));
  }
}
