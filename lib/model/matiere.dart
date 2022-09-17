import 'dart:convert';
import 'package:licence_mobile/model/user.dart';
import 'package:licence_mobile/service/api.dart';

class Matiere {
  int id;
  int credit;
  int heure;
  int heureConsommee;
  String libelle;
  // String enseignantId;
  User enseignant;

  Matiere({
    required this.id,
    required this.libelle,
    required this.credit,
    required this.heure,
    required this.heureConsommee,
    required this.enseignant,
  });

  static Matiere fromjson(var json) => Matiere(
        id: json['id'],
        libelle: json['libelle'],
        credit: json['credit'],
        heure: json['heure'],
        heureConsommee: json['heureConsommee'],
        // enseignantId: json['enseignantId'].toString(),
        enseignant: User.fromjson(json['enseignant']),
      );

  static Future<List<Matiere>> all() async {
    var jsonData = await Api.get('matieres/all', promo: true);
    List<Matiere> matieres = [];
    for (var json in jsonData) {
      matieres.add(Matiere.fromjson(json));
    }
    return matieres;
  }

  // static Future<List<Matiere>> categorie(String type) async {
  //   var jsonData = await Api.get('posts/categorie/$type');
  //   List<Matiere> matieres = [];
  //   for (var json in jsonData) {
  //     matieres.add(Matiere.fromjson(json));
  //   }
  //   return matieres;
  // }
}
