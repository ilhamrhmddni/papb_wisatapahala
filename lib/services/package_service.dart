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

    final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages/$idPackage'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      PackageModel packageModel = PackageModel(
        id: responseData['id'] ?? '', // Handle nilai null dengan memberikan nilai default
        nama: responseData['nama'] ?? '', // Handle nilai null dengan memberikan nilai default
        jenis: responseData['jenis'] ?? '', // Handle nilai null dengan memberikan nilai default
        tanggalKepulangan: responseData['tanggalKepulangan'] != null ? DateTime.parse(responseData['tanggalKepulangan']) : DateTime.now(), // Handle nilai null dengan memberikan nilai default atau tanggal saat ini
        tanggalKepergian: responseData['tanggalKepergian'] != null ? DateTime.parse(responseData['tanggalKepergian']) : DateTime.now(), // Handle nilai null dengan memberikan nilai default atau tanggal saat ini
        harga: responseData['harga'] ?? 0, // Handle nilai null dengan memberikan nilai default
        detail: responseData['detail'] ?? '', // Handle nilai null dengan memberikan nilai default
      );

      return packageModel;
    } else {
      throw Exception('Failed to load package details: ${response.reasonPhrase}');
    }
  } catch (e) {
    throw Exception('Error: Failed to save and fetch selected package ID: $e');
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
      throw Exception('Failed to load package price: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getPaketPriceById: $e');
    throw Exception('Failed to load package price: $e');
  }
}

static Future<PackageModel> getPackageById(String idPackage) async {
  try {
    final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages/$idPackage'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final PackageModel package = PackageModel.fromJson(data); // Mengonversi data JSON menjadi objek PackageModel
      return package;
    } else {
      throw Exception('Failed to load package: ${response.statusCode}');
    }
  } catch (e) {
    print('Error in getPaketById: $e');
    throw Exception('Failed to load package: $e');
  }
}


}
