import 'package:wisatapahala/models/base_model.dart';

class SavingModel extends BaseModel {
  late String waktu; // Waktu penyimpanan tabungan
  late String nominal; // Jumlah tabungan
  late String idUser; // ID pengguna terkait dengan tabungan

  SavingModel({
    required String id,
    required this.waktu,
    required this.nominal,
    required this.idUser,
  }) : super(id: id);

  SavingModel.fromJson(Map<String, dynamic> json)
      : waktu = json['waktu'] ?? '',
        nominal = json['nominal'] ?? '0',
        idUser = json['id_user'] ?? '',
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
