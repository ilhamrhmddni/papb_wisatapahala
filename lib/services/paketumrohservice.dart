import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';

class PaketUmrohController {
  // Method untuk memilih paket umroh
  static Future<void> selectPaketUmroh(String paketUmrohId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedPaketUmrohId', paketUmrohId);
  }

  // Method untuk mendapatkan paket umroh yang telah dipilih sebelumnya
  static Future<String?> getSelectedPaketUmroh() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedPaketUmrohId');
  }

  // Metode untuk mendapatkan detail paket umroh berdasarkan ID
  static Future<PaketUmroh> getPaketUmrohById(String paketUmrohId) async {
    // Di sini Anda dapat mengganti logika untuk mengambil detail paket umroh dari sumber data yang sesuai, seperti database atau API
    // Misalnya, Anda dapat menggunakan metode dari service atau repository untuk mengambil data paket umroh dari server atau penyimpanan lokal
    // Di bawah ini hanya contoh sederhana

    // Contoh detail paket umroh
    PaketUmroh paketUmroh = PaketUmroh(
      id: paketUmrohId,
      nama: 'Paket Umroh',
      harga: 10000000, // Contoh harga dalam rupiahContoh durasi dalam hari
    );

    // Mengembalikan objek paket umroh
    return paketUmroh;
  }
}
