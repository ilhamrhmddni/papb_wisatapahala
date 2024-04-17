import 'package:flutter/material.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/homescreen.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart';
import 'package:wisatapahala/services/paketumrohservice.dart';
import 'package:wisatapahala/services/userservice.dart';
import 'package:wisatapahala/screens/loginscreen.dart';

// Anda perlu mendapatkan userId dari mana pun Anda menyimpannya, misalnya dari Shared Preferences
String userId = 'user_id'; // Gantilah 'user_id' dengan cara Anda mendapatkan userId

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserController.isLoggedIn(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data == true) {
            // Buat instance dari PaketUmrohController dengan memberikan userId
            PaketUmrohController paketUmrohController = PaketUmrohController(userId);

            return FutureBuilder(
              future: paketUmrohController.getPaketUmrohById('default_id'), // Gunakan ID default atau sesuaikan dengan logika aplikasi Anda
              builder: (context, AsyncSnapshot<PaketUmroh?> snapshotPaket) {
                if (snapshotPaket.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (snapshotPaket.hasData && snapshotPaket.data != null) {
                    // Jika data tersedia, navigasi ke TabunganUmrohScreen
                    return TabunganUmrohScreen(snapshotPaket.data!);
                  } else {
                    // Jika data tidak tersedia atau terjadi kesalahan, navigasi ke HomeScreen
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
