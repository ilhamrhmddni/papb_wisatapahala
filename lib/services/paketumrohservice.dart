import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:wisatapahala/models/paketumrohmodel.dart';

class PaketUmrohController {
  static final String apiUrl = 'https://papb-wisatapahala-be.vercel.app/packages';

  // Constructor untuk menetapkan userId
  final String userId;
  PaketUmrohController(this.userId);

  // Method untuk mendapatkan paket umroh berdasarkan ID
  Future<PaketUmroh?> getPaketUmrohById(String paketUmrohId) async {
    try {
      final response = await http.get(Uri.parse('$apiUrl/$paketUmrohId/$userId'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PaketUmroh.fromJson(jsonData);
      } else {
        return null;
      }
    } catch (e) {
      print('Error: $e');
      return null;
    }
  }
}
