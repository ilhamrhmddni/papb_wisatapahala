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
        backgroundColor: Color(0xFF00AD9A),
        automaticallyImplyLeading: false, // Menghapus tombol kembali
        title: Text(
          'Tambah Tabungan',
          style: TextStyle(color: Colors.white), // Ubah warna teks menjadi putih
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center seluruh teks
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Masukkan Jumlah Tabungan',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Center teks
              ),
              SizedBox(height: 10),
              TextField(
                controller: _jumlahTabunganController,
                decoration: InputDecoration(
                  labelText: 'Jumlah Tabungan',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF00AD9A)), // Ubah warna border menjadi hijau
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _tambahTabungan(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00AD9A), // Ubah warna tombol menjadi hijau
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15), // Mengatur padding
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(color: Colors.white, fontSize: 16), // Ubah warna teks menjadi putih
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00AD9A), // Ubah warna tombol menjadi merah
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Mengatur padding
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(color: Colors.white, fontSize: 16), // Ubah warna teks menjadi putih
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tambahTabungan(BuildContext context) {
  String jumlahTabungan = _jumlahTabunganController.text.trim();
  if (jumlahTabungan.isNotEmpty) {
    int? tabungan = int.tryParse(jumlahTabungan);
    if (tabungan != null) {
      // Ambil tanggal dan waktu saat ini
      DateTime now = DateTime.now();
      // Format tanggal dan waktu menjadi string
      String waktu = now.toString();
      widget.savingService.tambahkanTabungan(
        tabungan,
        waktu,
      );
      _jumlahTabunganController.clear(); // Kosongkan input setelah berhasil tambahkan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tabungan berhasil ditambahkan'),
          duration: Duration(seconds: 2), // Durasi Snackbar ditampilkan
        ),
      );
      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      _showErrorDialog(
          context, 'Masukkan angka yang valid untuk jumlah tabungan.');
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
