import 'package:mongo_dart/mongo_dart.dart';

class User {
  late String id;
  late String username;
  late String email;
  late String password;
  late bool isAdmin;
  late List<ObjectId> idPackage;

  User({
    required this.username,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.idPackage,
  });

  User.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        username = json['username'],
        email = json['email'],
        password = json['password'],
        isAdmin = json['is_admin'],
        idPackage = (json['id_package'] as List)
            .map((id) => ObjectId.parse(id))
            .toList();

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
        'password': password,
        'is_admin': isAdmin,
        'id_package': idPackage.map((id) => id.toHexString()).toList(),
      };
}
