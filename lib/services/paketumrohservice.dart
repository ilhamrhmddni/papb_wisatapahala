import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';

class PaketUmrohService {
  static const String apiUrl = 'https://papb-wisatapahala-be.vercel.app/users';

  static Future<List<PaketUmroh>> getPaketUmrohList() async {
    final response = await http.get(Uri.parse('https://papb-wisatapahala-be.vercel.app/packages'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => PaketUmroh.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load paket umroh');
    }
  }

  static Future<void> saveSelectedPackageIdToUserApi({required String userId, required String packageId}) async {
    try {
      final apiUrl = 'https://papb-wisatapahala-be.vercel.app/users/$userId';
      final headers = {'Content-Type': 'application/json'};

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode({'id_package': packageId}),
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

  static Future<void> saveSelectedPackageId(String packageId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('id_package', packageId);
  }

  static Future<String?> getSelectedPackageId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id_package');
  }
}