import 'package:flutter/material.dart';
import 'package:wisatapahala/services/saving_service.dart';


class SavingAddScreen extends StatelessWidget {
  final TextEditingController _jumlahTabunganController =
      TextEditingController();
  final SavingService savingService;

  SavingAddScreen({required this.savingService});

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
      // Panggil metode tambahkanTabungan dari savingService
      savingService.tambahkanTabungan(
        int.parse(jumlahTabungan),
        DateTime.now().toString(),
      );
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Jumlah tabungan tidak boleh kosong.'),
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
}
