import 'package:flutter/material.dart';
import 'package:wisatapahala/services/userservice.dart';
import 'package:wisatapahala/screens/loginscreen.dart';
import 'package:wisatapahala/screens/homescreen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: UserService.isLoggedIn(), // Menggunakan Future<String?>
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.data != null) {
            return FutureBuilder<bool>(
              future: UserService.checkLoginStatus(), // Menggunakan Future<bool>
              builder: (context, AsyncSnapshot<bool> userIdSnapshot) {
                if (userIdSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  if (userIdSnapshot.hasData && userIdSnapshot.data!) {
                    return HomeScreen(); // Navigasi ke HomeScreen jika pengguna sudah masuk
                  } else {
                    return LoginScreen(); // Navigasi ke LoginScreen jika pengguna belum masuk
                  }
                }
              },
            );
          } else {
            return LoginScreen(); // Navigasi ke LoginScreen jika pengguna belum masuk
          }
        }
      },
    );
  }
}
