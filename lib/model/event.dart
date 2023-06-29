import 'dart:convert';

import 'package:flutter_neat_and_clean_calendar/neat_and_clean_calendar_event.dart';
import 'package:licence_mobile/service/api.dart';
import 'package:licence_mobile/widget/widget.dart';

class Event {
  late int id;
  late String matiere;
  late String description;
  late String type;
  late DateTime dateDebut;
  late DateTime dateFin;

  Event({
    required this.id,
    required this.matiere,
    required this.description,
    required this.type,
    required this.dateDebut,
    required this.dateFin,
  });

  static Event fromjson(var json) => Event(
        id: json['id'],
        matiere: json['title'],
        description: json['title'],
        type: json['type'],
        dateDebut: DateTime.parse(json['start']),
        dateFin: DateTime.parse(json['end']),
      );

  Map<String, dynamic> tojson() => {
        'id': id,
        'matiere': matiere,
        'description': description,
        'type': type,
        'dateDebut': dateDebut,
        'dateFin': dateFin,
      };

  static Future<Event> find(int id) async {
    var json = await Api.get('events/$id');
    return Event.fromjson(json);
  }

  static Future<List<Event>> all() async {
    var jsonData = await Api.get('programmes/all', promo: true);
    // DateTime datey = DateTime.now();
    List<Event> events = [];
    for (var json in jsonData) {
      events.add(Event.fromjson(json[0]));
    }
    // var day = events[0].dateDebut.day;
    return events;
  }

  static editEvent(Map data) async {
    var result = await Api.post(data, "programmes/update");
    return result;
  }

  static addEvent(Map data) async {
    data['promo'] =
        jsonDecode(await Widgets.getPref('promotion'))['promo'].toString();
    var result = await Api.post(data, "programmes/create");
    return result;
  }

  static del(String id) async {
    Map data = {'id': id};
    var result = await Api.post(data, "programmes/del");
    return result;
  }
}
