import 'package:flutter/material.dart';
import 'package:wisatapahala/services/user_service.dart';
import 'package:wisatapahala/screens/login_screen.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/saving_screen.dart';
import 'package:wisatapahala/models/package_model.dart';

class SplashScreen extends StatelessWidget {

  late final PackageModel paketUmroh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService.checkLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData && snapshot.data!) {
            // If the user is logged in, get the userId
            final Future<String> userIdFuture = UserService.getUserId();
            return FutureBuilder<String>(
              future: userIdFuture,
              builder: (context, AsyncSnapshot<String> userIdSnapshot) {
                if (userIdSnapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else {
                  final userId = userIdSnapshot.data;
                  if (userId != null) {
                    // If userId is available, get the idPackage based on userId
                    return FutureBuilder<String>(
                      future: UserService.getSavedPackageId(userId),
                      builder: (context, AsyncSnapshot<String> packageSnapshot) {
                        if (packageSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else {
                          final idPackage = packageSnapshot.data;
                          print(idPackage);
                          if (idPackage != null && idPackage.isNotEmpty) {
                            // If there's an id_package, navigate to the corresponding SavingScreen
                            return SavingScreen(packageModel: paketUmroh, idPackage: idPackage);
                          } else {
                            // If there's no id_package, go back to HomeScreen
                            return PackageScreen();
                          }
                        }
                      },
                    );
                  } else {
                    // If userId is null, display an error message or handle it accordingly
                    return Text('Error: User ID not found');
                  }
                }
              },
            );
          } else {
            // If the user is not logged in, navigate to the LoginScreen
            return LoginScreen();
          }
        }
      },
    );
  }
}
