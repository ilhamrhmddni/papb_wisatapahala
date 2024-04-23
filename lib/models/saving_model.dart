import 'package:wisatapahala/models/base_model.dart';

class SavingModel extends BaseModel {
  late String waktu;
  late String nominal;
  late List<String> idUser;

  SavingModel({
    required String id,
    required this.waktu,
    required this.nominal,
    required this.idUser,
  }) : super(id: id);

  SavingModel.fromJson(Map<String, dynamic> json)
      : waktu = json['waktu'] ?? '',
        nominal = json['nominal'] ?? '',
        idUser = List<String>.from(json['id_user'] ?? []),
        super(id: json['_id'] ?? '');

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'waktu': waktu,
      'nominal': nominal,
      'id_user': idUser,
    });
    return json;
  }
}
