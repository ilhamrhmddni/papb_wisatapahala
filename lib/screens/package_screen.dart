import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/services/package_service.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/screens/saving_screen.dart'; // Import the tabungan umroh screen
import 'package:wisatapahala/widgets/package_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PackageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // Mendapatkan ID pengguna (userId) menggunakan FutureBuilder
      future: _getUserId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Jika masih dalam proses loading, tampilkan loading screen
          return _buildLoadingScreen();
        } else if (snapshot.hasError) {
          // Jika terjadi error, tampilkan pesan error
          return _buildErrorScreen(snapshot.error.toString());
        } else {
          // Jika data berhasil didapatkan, tampilkan home screen dengan userId yang didapat
          return _buildHomeScreen(context, snapshot.data ?? '');
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    // Widget untuk menampilkan loading screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorScreen(String error) {
    // Widget untuk menampilkan error screen
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text('Error: $error')),
    );
  }

  Widget _buildHomeScreen(BuildContext context, String userId) {
    // Widget untuk menampilkan home screen dengan daftar paket umroh
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Paket'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<PackageModel>>(
        // Mengambil daftar paket umroh menggunakan FutureBuilder
        future: PackageService.getPaketUmrohList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Jika masih dalam proses loading, tampilkan loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Jika terjadi error, tampilkan pesan error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Jika data berhasil didapatkan, tampilkan daftar paket umroh
            List<PackageModel> daftarPaketUmroh = snapshot.data ?? [];
            if (daftarPaketUmroh.isEmpty) {
              // Jika tidak ada paket umroh tersedia, tampilkan pesan
              return Center(child: Text('Paket belum tersedia'));
            } else {
              // Jika ada paket umroh tersedia, tampilkan ListView dari package_widget
              return ListView.builder(
                itemCount: daftarPaketUmroh.length,
                itemBuilder: (context, index) {
                  final paketUmroh = daftarPaketUmroh[index];
                  return PackageWidget(
                    paketUmroh: paketUmroh,
                    onTap: () async { 
                      // Menampilkan dialog konfirmasi ketika paket dipilih
                      bool? confirmed = await _showConfirmationDialog(context, paketUmroh);
                      if (confirmed != null && confirmed) {
                        // Jika konfirmasi diterima, simpan ID paket dan navigasikan ke SavingScreen
                        await PackageService.saveSelectedPackageIdToUserApi(
                          userId: userId,
                          idPackage: paketUmroh.id,
                        );
                        await PackageService.saveSelectedPackageId(paketUmroh.id);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavingScreen(packageModel: paketUmroh, idPackage: paketUmroh.id,),
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

  Future<String?> _getUserId() async {
    // Mendapatkan userId dari SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['user']['id'];
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, PackageModel packageModel) async {
    // Menampilkan dialog konfirmasi pemilihan paket
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: Text('Anda yakin ingin memilih paket ${packageModel.nama}?'),
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
