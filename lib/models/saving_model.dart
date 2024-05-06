import 'package:wisatapahala/models/base_model.dart';

class SavingModel extends BaseModel {
  late DateTime waktu; // Waktu penyimpanan tabungan
  late int nominal; // Jumlah tabungan
  late String idUser; // ID pengguna terkait dengan tabungan

  SavingModel({
    required String id,
    required this.waktu,
    required this.nominal,
    required this.idUser,
  }) : super(id: id);

  SavingModel.fromJson(Map<String, dynamic> json)
      : waktu = DateTime.parse(json['waktu']),
        nominal = json['nominal'] ?? 0, // Cek jika null atau tidak
        idUser = json['id_user'][0], // Ambil nilai pertama dari daftar
        super(id: json['_id'] ?? '');

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'waktu': waktu.toIso8601String(), // Ubah menjadi string ISO 8601
      'nominal': nominal,
      'id_user': idUser,
    });
    return json;
  }
}
