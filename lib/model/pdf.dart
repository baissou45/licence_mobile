import 'dart:convert';
import 'package:licence_mobile/service/api.dart';
import 'package:http/http.dart' as http;

class Fichier {
  int id;
  String titre;
  String fichier;
  String sujet;

  Fichier({
    this.id = 0,
    this.titre = "",
    this.fichier = "",
    this.sujet = '',
  });

  static Fichier fromjson(var json) => Fichier(
        id: json['id'],
        titre: json['titre'],
        fichier: json['fichier'],
        sujet: json['sujet'],
      );
  Map<String, dynamic> tojson() => {
        'id': id,
        'titre': titre,
        'fichier': fichier,
        'sujet': sujet,
      };

  static Future<List<Fichier>> all() async {
    var jsonData = await Api.get('epreuves');
    List<Fichier> pdfs = [];
    for (var json in jsonData) {
      pdfs.add(Fichier.fromjson(json));
    }
    return pdfs;
  }

  static Future<List<Fichier>> categorie(String type) async {
    var jsonData = await Api.get('posts/categorie/$type');
    List<Fichier> pdfs = [];
    for (var json in jsonData) {
      pdfs.add(Fichier.fromjson(json));
    }
    return pdfs;
  }

  static Future<List<Fichier>> texts() async {
    var response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    var jsonData = jsonDecode(response.body);
    List<Fichier> pdfs = [];
    for (var json in jsonData) {
      pdfs.add(Fichier(
        id: json['id'],
        titre: json['title'],
        fichier: json['url'],
        // sujet: json['sujet'],
      ));
    }
    return pdfs;
  }
}
