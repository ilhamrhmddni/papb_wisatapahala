import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavingService {
  TextEditingController controller = TextEditingController();
  late List<int> riwayatPenambahanTabungan;

  late String userId;
  late String id;
  late String apiUrl;

  SavingService(String userId, String id)
      : userId = userId,
        id = id,
        apiUrl = 'https://papb-wisatapahala-be.vercel.app/savings/users/$id',
        riwayatPenambahanTabungan = []; // Initialize the list here

  Future<void> tambahkanTabungan(int tabunganSaatIni) async {
    int tambahan = int.tryParse(controller.text) ?? 0;
    if (tambahan > 0) {
      riwayatPenambahanTabungan.add(tambahan);
      tabunganSaatIni += tambahan;
      controller.clear();
      await updateTabungan(tabunganSaatIni, riwayatPenambahanTabungan);
    }
  }

  Future<void> updateTabungan(int tabungan, List<int> riwayat) async {
    try {
      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'userId': userId, 'id': id, 'riwayat': riwayat}),
      );
      if (response.statusCode == 200) {
        print('Data tabungan berhasil disinkronkan dengan database');
      } else {
        print('Gagal menyinkronkan data tabungan dengan database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<int> loadTotalTabungan() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['nominal'] ?? 0; // Make sure to handle null case
      } else {
        throw Exception('Failed to load total tabungan');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load total tabungan');
    }
  }

  Future<List<int>> loadRiwayatTabungan() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final riwayat = jsonData['nominal'] ?? [];
        return riwayat.cast<int>(); // Convert dynamic to List<int>
      } else {
        throw Exception('Failed to load riwayat tabungan');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load riwayat tabungan');
    }
  }
}
