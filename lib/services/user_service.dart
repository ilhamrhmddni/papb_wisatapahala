import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/login_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  static const String baseUrl = 'https://papb-wisatapahala-be.vercel.app/authorization';

  static Future<void> loginUser(BuildContext context, String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/login');
    final Map<String, String> body = {'email': email, 'password': password};

    try {
      final response = await http.post(url, body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String? token = responseData['token'];
        String? userId = responseData['id'];

        if (token != null && userId != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('token', token);
          await prefs.setString('id_user', userId);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PackageScreen()));
        } else {
          print('Token atau userId tidak ditemukan dalam respons API');
        }
      } else {
        _showErrorDialog(context, 'Login Gagal', 'Email atau password salah. Silakan coba lagi.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(context, 'Error', 'Terjadi kesalahan saat login. Silakan coba lagi.');
    }
  }

  static Future<void> registerUser(BuildContext context, String username, String email, String password) async {
    final Uri url = Uri.parse('$baseUrl/register');
    final Map<String, String> body = {'username': username, 'email': email, 'password': password};

    try {
      final response = await http.post(url, body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Akun Telah Dibuat'), duration: Duration(seconds: 2)));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
      } else {
        _showErrorDialog(context, 'Registrasi Gagal', 'Gagal melakukan registrasi. Silakan coba lagi.');
      }
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(context, 'Error', 'Terjadi kesalahan saat registrasi. Silakan coba lagi.');
    }
  }

  static Future<void> logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  static Future<bool> checkLoginStatus() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getBool('isLoggedIn') ?? false;
    } catch (e) {
      print('Error in checkLoginStatus: $e');
      return false;
    }
  }

static Future<String?> getSavedPackageId(String userId) async {
  final Uri apiUrl = Uri.parse('https://papb-wisatapahala-be.vercel.app/users/$userId');
  final Map<String, String> headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.get(apiUrl, headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      // Mengambil langsung ID paket tanpa perlu mengecek tipe data atau mengakses indeks
      return responseData['id_package'].toString();
    } else {
      print('Failed to load package id: ${response.statusCode}');
      return null;
    }
  } catch (e) {
    print('Error in getSavedPackageId: $e');
    return null;
  }
}

  static Future<String?> getUserId() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('id_user');
    } catch (e) {
      print('Error in getUserId: $e');
      return null;
    }
  }

  static void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
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
