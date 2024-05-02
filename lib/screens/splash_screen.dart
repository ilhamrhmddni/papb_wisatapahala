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
      // Periksa status login pengguna
      future: UserService.checkLoginStatus(),
      builder: (context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan indikator loading jika masih menunggu
          return Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data!) {
            // Jika pengguna sudah login, dapatkan ID pengguna
            return FutureBuilder<String>(
              future: UserService.getUserId(),
              builder: (context, AsyncSnapshot<String> userIdSnapshot) {
                if (userIdSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  // Tampilkan indikator loading jika masih menunggu
                  return Center(child: CircularProgressIndicator());
                } else {
                  final userId = userIdSnapshot.data;
                  if (userId != null) {
                    // Jika ID pengguna tersedia, ambil ID paket yang tersimpan untuk pengguna tersebut
                    return FutureBuilder<String>(
                      future: UserService.getSavedPackageId(userId),
                      builder: (context,
                          AsyncSnapshot<String> packageSnapshot) {
                        if (packageSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          // Tampilkan indikator loading jika masih menunggu
                          return Center(child: CircularProgressIndicator());
                        } else {
                          final idPackage = packageSnapshot.data;
                          // Periksa apakah ID paket ada
                          if (idPackage != null && idPackage.isNotEmpty) {
                            // Jika ada, buat objek PackageModel dengan ID paket
                            return FutureBuilder<PackageModel>(
                              future: PackageService.saveSelectedPackageId(idPackage),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // Tampilkan indikator loading jika masih menunggu
                                  return Center(
                                      child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  // Tampilkan pesan kesalahan jika terjadi kesalahan
                                  return Text(
                                      'Error: ${snapshot.error.toString()}');
                                } else {
                                  // Jika objek PackageModel diperoleh, navigasikan ke SavingScreen
                                  final packageModel = snapshot.data!;
                                  return SavingScreen(
                                    packageModel: packageModel,
                                    idPackage: idPackage,
                                  );
                                }
                              },
                            );
                          } else {
                            // Jika tidak ada ID paket, kembali ke PackageScreen
                            return PackageScreen();
                          }
                        }
                      },
                    );
                  } else {
                    // Jika ID pengguna tidak ditemukan, tampilkan pesan kesalahan
                    return Text('Error: User ID not found');
                  }
                }
              },
            );
          } else {
            // Jika pengguna belum login, tampilkan layar login
            return LoginScreen();
          }
        }
      },
    );
  }
}
