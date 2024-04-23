import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/services/userservice.dart';
import 'package:wisatapahala/screens/loginscreen.dart';
import 'package:wisatapahala/screens/homescreen.dart';
import 'package:wisatapahala/screens/tabunganscreen.dart'; // Import the tabungan umroh screen
import 'package:wisatapahala/models/paketumrohmodel.dart';

class SplashScreen extends StatelessWidget {

  late final PaketUmroh paketUmroh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService.checkLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data!) {
            // If the user is logged in, check if there's an id_package in shared preferences
            return FutureBuilder<String>(
              future: getSavedPackageId(), // Future to get the id_package from shared preferences
              builder: (context, AsyncSnapshot<String> packageSnapshot) {
                if (packageSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final idPackage = packageSnapshot.data;
                  if (idPackage != null && idPackage.isNotEmpty) {
                    // If there's an id_package, directly navigate to the corresponding tabungan umroh screen
                    return TabunganUmrohScreen(paketUmroh: paketUmroh, id_package: idPackage);
                  } else {
                    // If there's no id_package, go back to HomeScreen
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

  Future<String> getSavedPackageId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_package') ?? '';
  }
}
