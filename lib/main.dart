import 'package:flutter/material.dart';
import 'package:wisatapahala/screens/splashscreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Tabungan Umroh',
      theme: ThemeData(
        primarySwatch: Colors.blue, 
      ),
      home: SplashScreen(),
    );
  }
}
