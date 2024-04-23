import 'package:flutter/material.dart';

class AddTabunganScreen extends StatelessWidget {
  final TextEditingController _jumlahTabunganController = TextEditingController(); // Tambahkan controller untuk TextField

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
              controller: _jumlahTabunganController, // Tambahkan controller
              decoration: InputDecoration(
                labelText: 'Jumlah Tabungan',
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _tambahTabungan(context); // Panggil fungsi _tambahTabungan
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  void _tambahTabungan(BuildContext context) {
    String jumlahTabungan = _jumlahTabunganController.text.trim(); // Ambil nilai dari TextField
    // Validasi jika jumlah tabungan tidak kosong
    if (jumlahTabungan.isNotEmpty) {
      // Lakukan logika untuk menyimpan tabungan ke basis data atau tempat penyimpanan yang sesuai
      // Misalnya, Anda dapat menggunakan UserService untuk menyimpan data tabungan ke pengguna yang saat ini masuk
      // UserService.tambahTabungan(jumlahTabungan);
      // Setelah tabungan ditambahkan, Anda dapat menavigasi ke layar lain atau melakukan tindakan lain sesuai kebutuhan aplikasi Anda
    } else {
      // Tampilkan pesan kesalahan jika jumlah tabungan kosong
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
