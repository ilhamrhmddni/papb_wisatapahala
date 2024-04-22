import 'package:flutter/material.dart';
import 'package:wisatapahala/services/userservice.dart';
import 'package:wisatapahala/screens/loginscreen.dart';
import 'package:wisatapahala/screens/homescreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService.checkLoginStatus(), // Menggunakan Future<bool>
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data!) {
            return HomeScreen(); // Navigasi ke HomeScreen jika pengguna sudah masuk
          } else {
            return LoginScreen(); // Navigasi ke LoginScreen jika pengguna belum masuk
          }
        }
      },
    );
  }
}
