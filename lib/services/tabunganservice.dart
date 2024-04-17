import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TabunganController {
  TextEditingController controller = TextEditingController();
  List<int> riwayatPenambahanTabungan = [];
  
  late String userId; // Id pengguna yang digunakan untuk identifikasi di database
  late String id; // Id untuk digunakan dalam URL API
  late String apiUrl; // URL API tabungan

  TabunganController(String userId, String id) {
    this.userId = userId;
    this.id = id;
    this.apiUrl = 'https://papb-wisatapahala-be.vercel.app/savings/users/$id';
  }

  Future<void> saveRiwayatTabungan(List<int> riwayat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('riwayatTabungan', riwayat.map((e) => e.toString()).toList());
  }

  Future<List<int>> loadRiwayatTabungan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? riwayat = prefs.getStringList('riwayatTabungan');
    if (riwayat != null) {
      return riwayat.map((e) => int.parse(e)).toList();
    } else {
      return [];
    }
  }

  Future<void> saveTabunganSaatIni(int tabungan) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('tabungan', tabungan);
  }

  Future<int> loadTabungan() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('tabungan') ?? 0;
  }

  Future<void> tambahkanTabungan(int tabunganSaatIni) async {
    int tambahan = int.tryParse(controller.text) ?? 0;
    if (tambahan > 0) {
      riwayatPenambahanTabungan.add(tambahan);
      tabunganSaatIni += tambahan;
      controller.clear();
      saveTabunganSaatIni(tabunganSaatIni);
      saveRiwayatTabungan(riwayatPenambahanTabungan);
      // Sinkronisasi dengan database
      await updateTabungan(tabunganSaatIni, riwayatPenambahanTabungan);
    }
  }

  Future<void> updateTabungan(int tabungan, List<int> riwayat) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl$id'),
        body: {
          'tabungan': tabungan.toString(),
          'riwayat': json.encode(riwayat), // Menyimpan riwayat sebagai JSON string
        },
      );
      if (response.statusCode == 200) {
        // Berhasil menyimpan data ke database
        print('Data tabungan berhasil disinkronkan dengan database');
      } else {
        // Gagal menyimpan data ke database
        print('Gagal menyinkronkan data tabungan dengan database');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
