import 'package:flutter/material.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/homescreen.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart';
import 'package:wisatapahala/services/paketumrohservice.dart';
import 'package:wisatapahala/services/userservice.dart';
import 'package:wisatapahala/screens/loginscreen.dart';

class SplashScreen extends StatelessWidget {
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
    return FutureBuilder(
      future: UserController.isLoggedIn(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            return FutureBuilder(
              future: PaketUmrohController.getSelectedPaketUmroh(),
              builder: (context, AsyncSnapshot<String?> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshot.data != null) {
                    return FutureBuilder(
                      future: PaketUmrohController.getPaketUmrohById(snapshot.data!),
                      builder: (context, AsyncSnapshot<PaketUmroh> snapshotPaket) {
                        if (snapshotPaket.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          return TabunganUmrohScreen(daftarPaketUmroh as PaketUmroh); // Anda mungkin ingin menambahkan argumen di sini jika diperlukan
                        }
                      },
                    );
                  } else {
                    return HomeScreen();
                  }
                }
              },
            );
          } else {
            return LoginScreen();
          }
        }
      },
    );
  }
}
