import 'package:wisatapahala/models/base_model.dart';

class UserModel extends BaseModel {
  late String username;
  late String email;
  late String password;
  late bool isAdmin;
  late List<String> idPackage;

  UserModel({
    required String id,
    required this.username,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.idPackage,
  }) : super(id: id);

  UserModel.fromJson(Map<String, dynamic> json)
      : username = json['username'] ?? '',
        email = json['email'] ?? '',
        password = json['password'] ?? '',
        isAdmin = json['is_admin'] ?? false,
        idPackage = List<String>.from(json['id_package'] ?? []),
        super(id: json['_id'] ?? '');

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'username': username,
      'email': email,
      'password': password,
      'is_admin': isAdmin,
      'id_package': idPackage,
    });
    return json;
  }
}
