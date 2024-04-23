import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/services/paketumrohservice.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart'; // Import the tabungan umroh screen
import 'package:wisatapahala/widgets/paketumrohwidget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          return _buildErrorScreen(snapshot.error.toString());
        } else {
          return _buildHomeScreen(context, snapshot.data ?? '');
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(String error) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHomeScreen(BuildContext context, String userId) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PaketUmroh>>(
        future: PaketUmrohService.getPaketUmrohList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<PaketUmroh> daftarPaketUmroh = snapshot.data ?? [];
            if (daftarPaketUmroh.isEmpty) {
              return Center(child: Text('Paket belum tersedia'));
            } else {
              return ListView.builder(
                itemCount: daftarPaketUmroh.length,
                itemBuilder: (context, index) {
                  final paketUmroh = daftarPaketUmroh[index];
                  return PaketUmrohCard(
                    paketUmroh: paketUmroh,
                    onTap: () async {
                      // _getUserId;
                      bool? confirmed = await _showConfirmationDialog(context, paketUmroh);
                      if (confirmed != null && confirmed) {
                        await PaketUmrohService.saveSelectedPackageIdToUserApi(
                          userId: userId,
                          id_package: paketUmroh.id,
                        );
                        await PaketUmrohService.saveSelectedPackageId(paketUmroh.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TabunganUmrohScreen(paketUmroh: paketUmroh, id_package: paketUmroh.id), // Tambahkan id_package
                          ),
                        );
                      }
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

  Future<String> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    // print("decodedToken");
    // print(decodedToken['user']['id']);
    // return prefs.getString('userId') ?? '';
    return decodedToken['user']['id'];
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, PaketUmroh paketUmroh) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin memilih paket ${paketUmroh.nama}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }
}
