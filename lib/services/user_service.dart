import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String baseUrl = 'https://papb-wisatapahala-be.vercel.app/authorization';

  static Future<void> loginUser(BuildContext context, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Login berhasil
        Map<String, dynamic> responseData = json.decode(response.body);
        String? token = responseData['token']; // Ambil token dari respons API
        print(token);
        if (token != null) {
          // Simpan token ke SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('token', token);

          // Navigasi ke halaman beranda
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PackageScreen()),
          );
        } else {
          // Token tidak ditemukan dalam respons API
          print('Token tidak ditemukan dalam respons API');
        }
      } else {
        // Login gagal
        // Tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Login Gagal'),
            content: Text('Email atau password salah. Silakan coba lagi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Terjadi kesalahan saat login. Silakan coba lagi.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> registerUser(BuildContext context, String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        body: json.encode({'username': username, 'email': email, 'password': password}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun Telah Dibuat'),
          duration: Duration(seconds: 2),
        ),
      );
      // Tunggu 2 detik sebelum kembali ke halaman login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      } else {
        // Registrasi gagal
        // Tampilkan pesan kesalahan
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Registrasi Gagal'),
            content: Text('Gagal melakukan registrasi. Silakan coba lagi.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Terjadi kesalahan saat registrasi. Silakan coba lagi.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    // Anda juga dapat menghapus token JWT dari SharedPreferences di sini
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

    static Future<bool> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    return isLoggedIn;
  }    

static Future<String> getSavedPackageId(String userId) async {
  final apiUrl = 'https://papb-wisatapahala-be.vercel.app/users/$userId'; // Endpoint API yang menerima id_user sebagai parameter
  final headers = {'Content-Type': 'application/json'}; 

  try {
    // Melakukan request ke API dengan menggunakan token sebagai otorisasi
    final response = await http.get(
      Uri.parse(apiUrl), 
      headers: headers,
    );
    
    // Mengecek apakah respons berhasil (status code 200)
    if (response.statusCode == 200) {
      // Mengekstrak data dari respons JSON
      final responseData = json.decode(response.body);
      final idPackage = responseData['id_package'];
      
      // Mengembalikan id_package
      return idPackage;
    } else {
      // Jika respons tidak berhasil, lemparkan exception
      throw Exception('Failed to load package id');
    }
  } catch (e) {
    // Tangani error jika ada kesalahan dalam melakukan request
    print('Error: $e');
    throw Exception('Failed to load package id');
  }
}
static Future<String> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') ?? '';
  }
}
