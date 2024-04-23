class PaketUmroh {
  String id;
  String nama;
  String jenis;
  DateTime tanggal_kepulangan;
  DateTime tanggal_kepergian;
  int harga;
  String detail;

  // Konstruktor default
  PaketUmroh({
    required this.id,
    required this.nama,
    required this.jenis,
    required this.tanggal_kepulangan,
    required this.tanggal_kepergian,
    required this.harga,
    required this.detail,
  });

  // Konstruktor fromJson
  factory PaketUmroh.fromJson(Map<String, dynamic> json) {
    return PaketUmroh(
      id: json['_id'] ?? '',
      nama: json['nama'] ?? '',
      jenis: json['jenis'] ?? '',
      tanggal_kepulangan: json['tanggal_kepulangan'] != null ? DateTime.parse(json['tanggal_kepulangan']) : DateTime.now(),
      tanggal_kepergian: json['tanggal_kepergian'] != null ? DateTime.parse(json['tanggal_kepergian']) : DateTime.now(),
      harga: json['harga'] ?? 0,
      detail: json['detail'] ?? '',
    );
  }

}
