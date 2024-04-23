  import 'package:flutter/material.dart';
  import 'package:wisatapahala/screens/splash_screen.dart';

  void main() {
    runApp(MyApp());
  }

  class MyApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        home: SplashScreen(), // Mengirimkan data paketUmroh ke SplashScreen
      );
    }
  }
