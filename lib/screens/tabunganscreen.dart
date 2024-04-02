import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/paketumrohmodel.dart';
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
  TabunganController tabunganController = TabunganController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
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
  
  // Metode tambahkanTabungan dan _showTargetReachedDialog tetap sama seperti sebelumnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kelola Tabungan'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            SizedBox(height: 20),
            TextField(
              controller: tabunganController.controller,
              decoration: InputDecoration(
                labelText: 'Masukkan Jumlah Tabungan Saat Ini',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  tabunganSaatIni = tabunganController.tambahkanTabungan(tabunganSaatIni);
                });
                await tabunganController.saveTabunganSaatIni(tabunganSaatIni);
                if (tabunganSaatIni >= widget.paketUmroh.harga) {
                  _showTargetReachedDialog(context);
                }
              },
              child: Text('Tambah Tabungan'),
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

  void _showTargetReachedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Target Tabungan Tercapai'),
          content: Text('Anda telah mencapai target tabungan untuk Umrah.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    tabunganController.controller.dispose();
    super.dispose();
  }
}

