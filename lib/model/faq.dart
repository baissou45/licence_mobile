import 'package:licence_mobile/service/api.dart';

class Question {
  late String titre;
  late String description;
  // late List etapes;
  late String etapes;

  Question(
      {required this.titre, required this.description, required this.etapes});

  static Question fromjson(var json) => Question(
        titre: json['titre'],
        // description: json['description'],
        description: json['etapes'],
        etapes: json['etapes'],
      );

  static Future<List<Question>> all() async {
    var jsonData = await Api.get('faqs/all');
    List<Question> Questions = [];
    for (var json in jsonData) {
      Questions.add(Question.fromjson(json));
    }
    return Questions;
  }
}
