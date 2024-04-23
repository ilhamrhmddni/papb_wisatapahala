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
      child: Card(
        shape: RoundedRectangleBorder( // Membuat kotak yang dibulatkan (rounded)
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12), // Padding di dalam kotak Card
          title: Row( // Widget Row untuk menampilkan teks "nama" dan "jenis" secara horizontal
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Menempatkan teks "nama" di kiri dan "jenis" di kanan
            children: [
              Text(
                paketUmroh.nama,
                style: TextStyle(fontSize: 16), // Mengatur ukuran font
              ), // Teks "nama"
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), // Padding pada border jenis
                decoration: BoxDecoration( // Menambahkan border jenis
                  border: Border.all(color: Colors.grey), // Warna border
                  borderRadius: BorderRadius.circular(10), // Membuat border yang dibulatkan (rounded)
                ),
                child: Text(
                  paketUmroh.jenis,
                  style: TextStyle(fontSize: 12), // Mengatur ukuran font
                ), // Teks "jenis"
              ),
            ],
          ),
          subtitle: Column( // Widget Column untuk menampilkan teks lainnya secara vertikal
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4), // Spasi antara teks
              Row( // Menampilkan tanggal keberangkatan dan tanggal kepulangan secara sejajar
                children: [
                  Text(
                    'Tanggal Keberangkatan: ${DateFormat('dd MMMM yyyy').format(paketUmroh.tanggalKepergian)}',
                    style: TextStyle(fontSize: 14), // Mengatur ukuran font
                  ),
                ],
              ),
              SizedBox(height: 4), // Spasi antara teks
              Row( // Menampilkan tanggal keberangkatan dan tanggal kepulangan secara sejajar
                children: [
                  Text(
                    'Tanggal Kepulangan: ${DateFormat('dd MMMM yyyy').format(paketUmroh.tanggalKepulangan)}',
                    style: TextStyle(fontSize: 14), // Mengatur ukuran font
                  ),
                ],
              ),
              SizedBox(height: 4), // Spasi antara teks
              Row( // Menampilkan harga
                children: [
                  Text(
                    'Harga: ',
                    style: TextStyle(fontSize: 14), // Mengatur ukuran font
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2), // Padding pada border harga
                    decoration: BoxDecoration( // Menambahkan border harga
                      border: Border.all(color: Colors.grey), // Warna border
                      borderRadius: BorderRadius.circular(10), // Membuat border yang dibulatkan (rounded)
                    ),
                    child: Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(paketUmroh.harga),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold), // Mengatur ukuran font dan membuat teks tebal (bold)
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
