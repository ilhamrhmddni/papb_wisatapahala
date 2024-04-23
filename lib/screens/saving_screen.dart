import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/models/saving_model.dart';
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
  int tabunganSaatIni = 0; // Current tabungan
  List<SavingModel> riwayatTabungan = []; // History of tabungan entries

  @override
  void initState() {
    super.initState();
    _initializeService();
    _loadData();
  }

  void _initializeService() async {
    final prefs = await SharedPreferences.getInstance();
    savingService = SavingService(prefs.getString('userId') ?? '', widget.packageModel.id);
  }

  Future<void> _loadData() async {
    try {
      // Memuat riwayat tabungan dari API menggunakan SavingService
      final riwayat = await savingService.loadRiwayatTabungan();

      // Menghitung tabungan saat ini dengan menjumlahkan semua nilai nominal dalam riwayat
      final int currentTabungan = riwayat.isNotEmpty ? riwayat.map((entry) => entry.nominal).reduce((value, element) => value + element)! : 0;

      setState(() {
        tabunganSaatIni = currentTabungan;
        riwayatTabungan = riwayat;
      });
    } catch (e) {
      // Tangani kesalahan jika gagal memuat data
      print('Error: $e');
      // Menampilkan pesan kesalahan atau melakukan tindakan lain sesuai kebutuhan
    }
  }

  Future<void> _tambahTabungan(int jumlah) async {
    await savingService.tambahkanTabungan(jumlah);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Tabungan'),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _refreshData,
            icon: Icon(Icons.autorenew),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavingAddScreen(
                  onTambahTabungan: _tambahTabungan,
                ),
              ),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
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
                    subtitle: Text('Jumlah: ${riwayatTabungan[index].nominal}'), // Display the nominal value
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _refreshData() {
    _loadData();
  }
}
