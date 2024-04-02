import 'package:flutter/material.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart';
import 'package:wisatapahala/services/paketumrohservice.dart';

class HomeScreen extends StatelessWidget {
  final List<PaketUmroh> daftarPaketUmroh = [
    PaketUmroh(
      id: '1',
      nama: 'Paket Umroh Mekah 10 Hari',
      harga: 15000000,
    ),
    PaketUmroh(
      id: '2',
      nama: 'Paket Umroh Madinah 14 Hari',
      harga: 18000000,
    ),
    // Tambahkan paket umroh lainnya sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket Umroh'),
      ),
      body: ListView.builder(
        itemCount: daftarPaketUmroh.length,
        itemBuilder: (context, index) {
          final paketUmroh = daftarPaketUmroh[index];
          return ListTile(
            title: Text(paketUmroh.nama),
            subtitle: Text('Harga: ${paketUmroh.harga}'),
            onTap: () async {
              // Ambil detail paket umroh berdasarkan ID
              PaketUmroh selectedPaketUmroh = await PaketUmrohController.getPaketUmrohById(paketUmroh.id);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabunganUmrohScreen(selectedPaketUmroh),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
