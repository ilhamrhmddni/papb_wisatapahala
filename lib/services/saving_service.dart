import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wisatapahala/models/saving_model.dart';

class SavingService {
  late String userId;
  late String apiUrl;

  // Constructor untuk menginisialisasi SavingService dengan userId
  SavingService(this.userId)
      : apiUrl =
            'https://papb-wisatapahala-be.vercel.app/savings/users';
  
  // Metode untuk menambahkan tabungan ke dalam riwayat tabungan pengguna
  Future<void> tambahkanTabungan(int nominal, String waktu) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nominal': nominal,
          'waktu': waktu
        }),
      );
      if (response.statusCode == 200) {
        print('Tabungan berhasil ditambahkan');
      } else {
        print('Gagal menambahkan tabungan');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Metode untuk mendapatkan semua tabungan dari API
  Future<List> getAllTabungan() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final tabunganList = jsonData != null
            ? List<SavingModel>.from(
                jsonData.map((x) => SavingModel.fromJson(x)))
            : [];
        return tabunganList;
      } else {
        throw Exception('Gagal memuat data tabungan');
      }
    } catch (e) {
      print('Error saat memuat data tabungan: $e');
      throw Exception('Gagal memuat data tabungan');
    }
  }
}
