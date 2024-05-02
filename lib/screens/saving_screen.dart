import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/screens/saving_add_screen.dart';
import 'package:wisatapahala/services/saving_service.dart';

class SavingScreen extends StatefulWidget {
  final PackageModel packageModel;

  SavingScreen({required this.packageModel, required String idPackage});

  @override
  _SavingScreenState createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  late SavingService savingService;
  int tabunganSaatIni = 0;
  List<dynamic> riwayatTabungan = [];

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  void _initializeService() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId'); // Ambil userId dari SharedPreferences
  setState(() {
    savingService = SavingService(userId!);
  });
  _loadData();
}


  Future<void> _loadData() async {
    try {
      List<dynamic> rawData = await savingService.getAllTabungan();
      setState(() {
        riwayatTabungan = rawData;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Tabungan'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SavingAddScreen(savingService: savingService),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tabungan Saat Ini: $tabunganSaatIni',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Target Tabungan: ${widget.packageModel.harga}',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Riwayat Penambahan Tabungan:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: riwayatTabungan.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Tabungan ke-${index + 1}'),
                    subtitle: Text(
                        'Jumlah: ${riwayatTabungan[index]['nominal']}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
