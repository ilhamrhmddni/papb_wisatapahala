import 'package:flutter/material.dart';
import 'package:wisatapahala/services/saving_service.dart';

class SavingAddScreen extends StatefulWidget {
  final SavingService savingService;

  SavingAddScreen({required this.savingService});

  @override
  _SavingAddScreenState createState() => _SavingAddScreenState();
}

class _SavingAddScreenState extends State<SavingAddScreen> {
  final TextEditingController _jumlahTabunganController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Tabungan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Masukkan Jumlah Tabungan',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _jumlahTabunganController,
              decoration: InputDecoration(
                labelText: 'Jumlah Tabungan',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _tambahTabungan(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _tambahTabungan(BuildContext context) {
    String jumlahTabungan = _jumlahTabunganController.text.trim();
    if (jumlahTabungan.isNotEmpty) {
      int? tabungan = int.tryParse(jumlahTabungan);
      if (tabungan != null) {
        widget.savingService.tambahkanTabungan(
          tabungan,
          DateTime.now().toString(),
        );
        Navigator.pop(context);
      } else {
        _showErrorDialog(context, 'Masukkan angka yang valid untuk jumlah tabungan.');
      }
    } else {
      _showErrorDialog(context, 'Jumlah tabungan tidak boleh kosong.');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
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

  @override
  void dispose() {
    _jumlahTabunganController.dispose();
    super.dispose();
  }
}
