import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/package_model.dart';

class PackageService {
  static const String apiUrl = 'https://papb-wisatapahala-be.vercel.app/users';

  // Mendapatkan daftar paket umroh dari API
  static Future<List<PackageModel>> getPaketUmrohList() async {
    final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PackageModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load paket umroh');
    }
  }

  // Menyimpan ID paket yang dipilih oleh pengguna ke dalam data pengguna di API
  static Future<void> saveSelectedPackageIdToUserApi({required String userId, required String idPackage}) async {
    try {
      final apiUrl = 'https://papb-wisatapahala-be.vercel.app/users/$userId';
      final headers = {'Content-Type': 'application/json'};

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({'id_package': idPackage}),
      );

      if (response.statusCode == 200) {
        print('Selected package ID saved to user API successfully');
      } else if (response.statusCode == 404) {
        print('User not found');
      } else {
        print('Failed to save selected package ID to user API: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to save selected package ID to user API');
    }
  }

  // Menyimpan ID paket yang dipilih oleh pengguna ke dalam penyimpanan lokal
  static Future<PackageModel> saveSelectedPackageId(String idPackage) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('id_package', idPackage);
      
      // Membuat objek PackageModel dengan menggunakan idPackage yang diberikan
      PackageModel packageModel = PackageModel(
        id: idPackage,
        nama: '', // Isi dengan nama paket yang sesuai jika ada
        jenis: '', // Isi dengan jenis paket yang sesuai jika ada
        tanggalKepulangan: DateTime.now(), // Isi dengan tanggal kepulangan yang sesuai jika ada
        tanggalKepergian: DateTime.now(), // Isi dengan tanggal kepergian yang sesuai jika ada
        harga: 0, // Isi dengan harga paket yang sesuai jika ada
        detail: '', // Isi dengan detail paket yang sesuai jika ada
      );
      
      // Mengembalikan objek PackageModel yang telah dibuat
      return packageModel;
    } catch (e) {
      // Jika terjadi kesalahan, lemparkan exception dengan pesan yang sesuai
      throw Exception('Error: Failed to save selected package ID');
    }
  }

  // Mendapatkan ID paket yang dipilih dari penyimpanan lokal
  static Future<String?> getSelectedPackageId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_package');
  }

static Future<String?> getPaketPriceById(String idPackage) async {
    try {
      final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages/$idPackage'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final String price = data['harga'].toString(); // Mengonversi nilai harga menjadi String
        return price;
      } else {
        throw Exception('Failed to load package price');
      }
    } catch (e) {
      print('Error in getPaketPriceById: $e');
      throw Exception('ASUUUU : $e');
    }
  }


}
