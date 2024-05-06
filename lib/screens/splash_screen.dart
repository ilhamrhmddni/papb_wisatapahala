import 'package:flutter/material.dart';
import 'package:wisatapahala/services/package_service.dart';
import 'package:wisatapahala/services/user_service.dart';
import 'package:wisatapahala/screens/login_screen.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/saving_screen.dart';
import 'package:wisatapahala/models/package_model.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: UserService.checkLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data!) {
            return FutureBuilder<String?>(
              future: UserService.getUserId(),
              builder: (context, AsyncSnapshot<String?> userIdSnapshot) {
                if (userIdSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userId = userIdSnapshot.data;
                  if (userId != null) {
                    return FutureBuilder<String?>(
                      future: UserService.getSavedPackageId(userId),
                      builder: (context, AsyncSnapshot<String?> packageSnapshot) {
                        if (packageSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          final idPackage = packageSnapshot.data;
                          if (idPackage != null && idPackage.isNotEmpty) {
                            return FutureBuilder<PackageModel>(
                              future: PackageService.saveSelectedPackageId(idPackage),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error.toString()}');
                                } else {
                                  final packageModel = snapshot.data!;
                                  return SavingScreen(
                                    packageModel: packageModel,
                                    idPackage: idPackage,
                                  );
                                }
                              },
                            );
                          } else {
                            return PackageScreen();
                          }
                        }
                      },
                    );
                  } else {
                    return Text('Error: User ID not found');
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
