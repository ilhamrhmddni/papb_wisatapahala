import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabunganController {
  TextEditingController controller = TextEditingController();
  List<int> riwayatPenambahanTabungan = [];

  // Method untuk menyimpan riwayat tabungan
  Future<void> saveRiwayatTabungan(List<int> riwayat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('riwayatTabungan', riwayat.map((e) => e.toString()).toList());
  }

  // Method untuk memuat riwayat tabungan
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

  int tambahkanTabungan(int tabunganSaatIni) {
    int tambahan = int.tryParse(controller.text) ?? 0;
    if (tambahan > 0) {
      riwayatPenambahanTabungan.add(tambahan);
      tabunganSaatIni += tambahan;
      controller.clear();
      saveTabunganSaatIni(tabunganSaatIni); // Simpan data tabungan setiap kali ditambahkan
      saveRiwayatTabungan(riwayatPenambahanTabungan); // Simpan riwayat penambahan tabungan
    }
    return tabunganSaatIni;
  }
}
