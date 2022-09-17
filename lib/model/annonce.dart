import 'dart:convert';

import 'package:licence_mobile/service/api.dart';

class Annonce {
  int id;
  String titre;
  String description;
  String datePublication;
  String type;
  String fichier;
  String auteur;
  String img;

  Annonce({
    required this.id,
    required this.titre,
    required this.description,
    required this.datePublication,
    required this.type,
    this.img = "",
    this.fichier = "",
    this.auteur = "",
  });

  static Annonce fromjson(var json) {
    DateTime _date = DateTime.parse(json['datePublication']);
    String date =
        "${_date.day}/${_date.month}/${_date.year} à ${_date.hour}h : ${_date.minute}m";

    return Annonce(
      id: json['id'],
      titre: json['titre'],
      description: json['description'].toString(),
      datePublication: date,
      type: json['type'],
      fichier: json['fichier'].toString(),
      auteur: json['auteur'],
      // img: json['img'].toString(),
      img: json['fichier'].toString(),
    );
  }

  // Annonce fromjson(var json) => Annonce(nom: json['nom'], prenom: json['prenom']);
  Map<String, dynamic> tojson() => {
        'id': id,
        'titre': titre,
        'description': description,
        'datePublication': datePublication,
        'type': type,
        'fichier': fichier,
        'auteur': auteur,
        'img': img,
      };

  static Future<List<Annonce>> all() async {
    var jsonData = await Api.get('annonces/all', promo: true);
    List<Annonce> annonces = [];
    for (var json in jsonData) {
      // for (var json in jsonData) {
      annonces.add(Annonce.fromjson(json));
    }
    return annonces;
  }

  static Future<List<Annonce>> categorie(String type) async {
    var jsonData = await Api.get('annonces/categorie/$type', promo: true);
    List<Annonce> annonces = [];
    for (var json in jsonData) {
      annonces.add(Annonce.fromjson(json));
    }
    return annonces;
  }

  static create(Map data) async {
    var jsonData = await Api.post(data, 'annonces/create');
    return jsonData;
  }
}
