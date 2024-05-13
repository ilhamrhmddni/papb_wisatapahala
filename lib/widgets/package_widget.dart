import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import untuk memformat tanggal
import 'package:wisatapahala/models/package_model.dart';

class PackageWidget extends StatelessWidget {
  final PackageModel paketUmroh;
  final VoidCallback onTap;

  PackageWidget({required this.paketUmroh, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(0), // Padding di sekitar setiap card
        child: Card(
          color: Color(0xFF00AD9A),
          margin: EdgeInsets.zero, // Menghapus margin card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12), // Padding di dalam card
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 12.0), // Tambahkan margin di sebelah kanan gambar
                  width: 125, // Lebar gambar
                  height: 125, // Tinggi gambar
                  decoration: BoxDecoration(
                    color: Colors.white, // Warna latar belakang untuk gambar
                    borderRadius: BorderRadius.circular(8), // Bentuk border gambar
                  ),
                  // Tambahkan gambar di sini, misalnya:
                  // child: Image.asset('assets/images/paket_umroh.jpg', fit: BoxFit.cover),
                ),
                SizedBox(width: 12), // Tambahkan jarak antara gambar dan teks
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8), // Tambahkan jarak di atas teks pertama
                      Text(
                        paketUmroh.nama,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.4, // 28 * 0.55
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 8), // Tambahkan jarak antara nama dan tanggal
                      Text(
                        '${DateFormat('dd MMMM yyyy').format(paketUmroh.tanggalKepergian)} - ${DateFormat('dd MMMM yyyy').format(paketUmroh.tanggalKepulangan)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13, // 25.2 * 0.55
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 8), // Tambahkan jarak antara tanggal dan jenis
                      Container(
                        padding: EdgeInsets.all(4), // Padding di sekitar teks jenis
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white), // Tambahkan border
                          borderRadius: BorderRadius.circular(4), // Bentuk border
                        ),
                        child: Text(
                          paketUmroh.jenis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.814, // 21.48 * 0.55
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      SizedBox(height: 8), // Tambahkan jarak antara jenis dan harga
                      Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(paketUmroh.harga),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.56, // 39.2 * 0.55
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                          height: 0,
                        ),
                      ),
                      SizedBox(height: 8), // Tambahkan jarak di bawah harga
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
