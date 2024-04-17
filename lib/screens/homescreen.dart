import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart';
import 'package:wisatapahala/widgets/paketumrohwidget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PaketUmroh>> _futurePaketUmroh;

  @override
  void initState() {
    super.initState();
    _futurePaketUmroh = fetchPaketUmroh();
  }

  Future<List<PaketUmroh>> fetchPaketUmroh() async {
    final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PaketUmroh.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load paket umroh');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
      ),
      body: FutureBuilder<List<PaketUmroh>>(
        future: _futurePaketUmroh,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<PaketUmroh> daftarPaketUmroh = snapshot.data ?? [];
            if (daftarPaketUmroh.isEmpty) {
              // Tampilkan pesan jika daftar kosong
              return Center(child: Text('Paket belum tersedia'));
            } else {
              return ListView.builder(
                itemCount: daftarPaketUmroh.length,
                itemBuilder: (context, index) {
                  final paketUmroh = daftarPaketUmroh[index];
                  return PaketUmrohCard(
                    paketUmroh: paketUmroh,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TabunganUmrohScreen(paketUmroh),
                        ),
                      );
                    },
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
