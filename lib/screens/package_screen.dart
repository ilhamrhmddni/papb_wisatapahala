import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/services/package_service.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/screens/saving_screen.dart';
import 'package:wisatapahala/widgets/package_widget.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class PackageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
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
        title: Text('Pilih Paket', style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00AD9A),
      ),
      body: FutureBuilder<List<PackageModel>>(
        future: PackageService.getPaketUmrohList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<PackageModel> daftarPaketUmroh = snapshot.data ?? [];
            if (daftarPaketUmroh.isEmpty) {
              return Center(child: Text('Paket belum tersedia'));
            } else {
              return ListView.builder(
                padding: EdgeInsets.all(8.0),
                itemCount: daftarPaketUmroh.length,
                itemBuilder: (context, index) {
                  final paketUmroh = daftarPaketUmroh[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: PackageWidget(
                      paketUmroh: paketUmroh,
                      onTap: () async {
                        bool? confirmed = await _showConfirmationDialog(context, paketUmroh);
                        if (confirmed != null && confirmed) {
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
                    ),
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    return decodedToken['user']['id'];
  }

  Future<bool?> _showConfirmationDialog(BuildContext context, PackageModel packageModel) async {
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
