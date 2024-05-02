import 'package:wisatapahala/models/base_model.dart';

class PackageModel extends BaseModel {
  late String nama; // Nama paket
  late String jenis; // Jenis paket
  late DateTime tanggalKepulangan; // Tanggal kepulangan
  late DateTime tanggalKepergian; // Tanggal kepergian
  late int harga; // Harga paket
  late String detail; // Detail atau deskripsi paket

  PackageModel({
    required String id,
    required this.nama,
    required this.jenis,
    required this.tanggalKepulangan,
    required this.tanggalKepergian,
    required this.harga,
    required this.detail,
  }) : super(id: id);

  PackageModel.fromJson(Map<String, dynamic> json)
      : nama = json['nama'] ?? '',
        jenis = json['jenis'] ?? '',
        tanggalKepulangan = json['tanggal_kepulangan'] != null
            ? DateTime.parse(json['tanggal_kepulangan'])
            : DateTime.now(),
        tanggalKepergian = json['tanggal_kepergian'] != null
            ? DateTime.parse(json['tanggal_kepergian'])
            : DateTime.now(),
        harga = json['harga'] ?? 0,
        detail = json['detail'] ?? '',
        super(id: json['_id'] ?? '');

  @override
  Map<String, dynamic> toJson() {
    var json = super.toJson();
    json.addAll({
      'nama': nama,
      'jenis': jenis,
      'tanggal_kepulangan': tanggalKepulangan.toIso8601String(),
      'tanggal_kepergian': tanggalKepergian.toIso8601String(),
      'harga': harga,
      'detail': detail,
    });
    return json;
  }
}
