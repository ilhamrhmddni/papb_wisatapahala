import 'package:wisatapahala/models/base_model.dart';

class UserModel extends BaseModel {
  late String username; // Username pengguna
  late String email; // Email pengguna
  late String password; // Password pengguna
  late bool isAdmin; // Status apakah pengguna adalah admin atau tidak
  late List<String> idPackage; // Daftar ID paket yang terkait dengan pengguna

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
