import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
import 'package:wisatapahala/screens/addtabunganscreen.dart';
import 'package:wisatapahala/services/tabunganservice.dart';

class TabunganUmrohScreen extends StatefulWidget {
  final PaketUmroh paketUmroh;

  TabunganUmrohScreen(this.paketUmroh);

  @override
  _TabunganUmrohScreenState createState() => _TabunganUmrohScreenState();
}

class _TabunganUmrohScreenState extends State<TabunganUmrohScreen> {
  int tabunganSaatIni = 0;
  List<int> riwayatTabungan = [];
  late TabunganController tabunganController;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    tabunganController = TabunganController(widget.paketUmroh.id);
    _loadTabunganSaatIni();
    _loadRiwayatTabungan();
  }

  Future<void> _loadTabunganSaatIni() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      tabunganSaatIni = prefs.getInt('tabunganSaatIni') ?? 0;
    });
  }

  Future<void> _loadRiwayatTabungan() async {
    riwayatTabungan = await tabunganController.loadRiwayatTabungan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Tabungan'),
        leading: IconButton(
          onPressed: () {
            // Tambahkan logika ketika tombol hamburger menu ditekan di sini
          },
          icon: Icon(Icons.menu),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _onBackPressed,
            icon: Icon(Icons.autorenew),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
            bottom: 16), // Menambahkan padding sebesar 16 pada semua sisi
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTabunganScreen(),
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
                    'Target Tabungan: ${widget.paketUmroh.harga}',
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
                    subtitle: Text('Jumlah: ${riwayatTabungan[index]}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onBackPressed() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Mengganti Tabungan'),
        content:
            Text('Apakah Anda yakin ingin mengganti tabungan pilihan anda?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    tabunganController.controller.dispose();
    super.dispose();
  }
}
