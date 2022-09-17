import 'package:licence_mobile/service/api.dart';

class User {
  late int id;
  late String nom;
  late String prenom;
  late String role;
  late String tel;
  late String mail;
  late String img;
  // late String sexe;

  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.role,
    required this.tel,
    required this.mail,
    required this.img,
    // required this.sexe,
  });

  static User fromjson(var json) => User(
        id: json['id'],
        nom: json['nom'],
        prenom: json['prenom'],
        role: json['role'],
        tel: json['telephone'],
        mail: json['email'],
        img: json['profile_photo_url'],
        // // sexe: json['sexe'],
      );

  Map<String, dynamic> tojson() => {
        'nom': nom,
        'prenom': prenom,
        'role': role,
        'tel': tel,
        'img': img,
        // // 'sexe': sexe,
      };

  static Future<List<User>> all() async {
    var jsonData = await Api.get('users');
    List<User> users = [];
    for (var json in jsonData) {
      users.add(User.fromjson(json));
    }
    return users;
  }

  // static Future<User> find(int id) async {
  static find(int id) async {
    var json = await Api.get('users/find/$id');
    return User.fromjson(json);
  }

  static authUser() async {
    var result = await Api.get("users/user");
    User user = User.fromjson(result);
    return user;
  }
}
