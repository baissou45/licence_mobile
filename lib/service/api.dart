import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:licence_mobile/widget/widget.dart';

class Api {
  static geturl() {
    // return "http://10.0.2.2:8000/api/";
    // return "http://192.168.100.26:8000/api/";
    return "http://192.168.43.78:8000/api/";
  }

  static externalGeturl() {
    // return "http://10.0.2.2:8000/";
    // return "http://192.168.100.26:8000/";
    return "http://192.168.43.78:8000/";
  }

  static post(Map data, String lien, {bool promo = false}) async {
    var tokken = await Widgets.getPref('token');
    if (promo) {
      var promtion = await Widgets.getPref('promotion');
      promtion = jsonDecode(promtion);
      lien += '/${promtion['promo']}';
    }

    // print(tokken);
    print(Uri.parse(Api.geturl() + lien));
    var response =
        await http.post(Uri.parse(Api.geturl() + lien), body: data, headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokken',
    });

    if (response.statusCode == 200) {
      return {"data": jsonDecode(response.body), 'code': 200};
    } else {
      return {"data": jsonDecode(response.body), 'code': response.statusCode};
    }
  }

  static get(String lien, {bool promo = false}) async {
    var tokken = await Widgets.getPref('token');
    if (promo) {
      var promtion = await Widgets.getPref('promotion');
      promtion = jsonDecode(promtion);
      lien += '/${promtion['promo']}';
    }
    // print(tokken);
    print(Uri.parse(Api.geturl() + lien));
    var response = await http.get(Uri.parse(Api.geturl() + lien), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $tokken',
    });
    if (response.statusCode == 500) {
      throw 'Aucune donnée trouvée';
    }
    return jsonDecode(response.body)['data'];
  }
}
