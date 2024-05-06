import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:wisatapahala/models/saving_model.dart';

class SavingService {
  late String userId;
  late String apiUrl;

  // Constructor untuk menginisialisasi SavingService dengan userId
  SavingService(this.userId)
      : apiUrl =
            'https://papb-wisatapahala-be.vercel.app/savings';
  
  // Metode untuk menambahkan tabungan ke dalam riwayat tabungan pengguna
  Future<void> tambahkanTabungan(int nominal, String waktu) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/users/$userId'),
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

Future<List<SavingModel>> getAllTabungan(String userId) async {
  try {
    final response = await http.get(Uri.parse('$apiUrl/users/$userId'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<SavingModel> tabunganList = jsonData.map((data) => SavingModel.fromJson(data)).toList();
      return tabunganList;
    } else {
      throw Exception('Failed to load tabungan data');
    }
  } catch (e) {
    print('Error loading tabungan data: $e');
    throw Exception('Failed to load tabungan data');
  }
}

Future<bool> deleteSaving(String savingId) async {
  try {
    final response = await http.delete(
      Uri.parse('$apiUrl/$savingId'),
      headers: {'Content-Type': 'application/json'},
      
    );
    if (response.statusCode == 200) {
      print('Tabungan berhasil dihapus');
      return true;
    } else {
      print('Gagal menghapus tabungan');
      return false;
    }
  } catch (e) {
    print('Error: $e');
    return false;
  }
}

}
