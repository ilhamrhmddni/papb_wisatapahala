import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/models/saving_model.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/saving_add_screen.dart';
import 'package:wisatapahala/services/package_service.dart';
import 'package:wisatapahala/services/saving_service.dart';

class SavingScreen extends StatefulWidget {
  final PackageModel packageModel;

  SavingScreen({required this.packageModel, String? idPackage});

  @override
  _SavingScreenState createState() => _SavingScreenState();
}

class _SavingScreenState extends State<SavingScreen> {
  SavingService? savingService;
  int tabunganSaatIni = 0;
  int targetTabungan = 0;
  List<SavingModel> riwayatTabungan = [];
  // ignore: unused_field
  bool _dataLoaded = false;


  @override
  void initState() {
    super.initState();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    print("Initializing and loading data..."); // Tambahkan print statement
    try {
      // Mendapatkan id paket yang dipilih
      String? idPackage = await PackageService.getSelectedPackageId();
      if (idPackage != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? userId = prefs.getString('id_user');
        if (userId != null) {
          setState(() {
            savingService = SavingService(userId);
          });
          print("Selected user ID: $userId"); // Tambahkan print statement
          print("Selected package ID: $idPackage"); // Tambahkan print statement

          // Mengambil harga paket berdasarkan id
          String? price = await PackageService.getPaketPriceById(idPackage);
          if (price != null) {
            setState(() {
              targetTabungan = int.parse(price);
            });
            print("Package price: $price"); // Tambahkan print statement
          } else {
            print('Error: price is null');
            return;
          }

          if (savingService != null) {
            List<SavingModel> rawData = await savingService!.getAllTabungan(userId);
            setState(() {
              riwayatTabungan = rawData;
              tabunganSaatIni = _calculateTotalSaving();
              _dataLoaded = true; // Tandai bahwa data sudah dimuat
            });
            print("Total savings: $tabunganSaatIni"); // Tambahkan print statement
            _checkIsBalance(); // Tambahkan pengecekan isBalance
          } else {
            print('Error: userId is null');
          }
        } else {
          print('Error: idPackage is null');
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int _calculateTotalSaving() {
    int total = 0;
    for (var saving in riwayatTabungan) {
      total += saving.nominal;
    }
    return total;
  }

  // Fungsi untuk memperbarui data pada layar SavingScreen
  Future<void> refreshData() async {
    print("Refreshing data..."); // Tambahkan print statement
    _initializeAndLoadData(); // Memuat ulang data pada layar SavingScreen
  }

  void _checkIsBalance() {
    // Cek apakah tabungan saat ini seimbang dengan target tabungan
    bool isBalance = tabunganSaatIni >= targetTabungan;

    // Jika tabungan saat ini seimbang dengan target tabungan, tampilkan popup
    if (isBalance) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Tabungan Saat Ini Seimbang"),
            content: Text("Anda telah mencapai target tabungan."),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  Widget _buildMainContent() {
    // Selanjutnya, Anda dapat melanjutkan dengan membangun UI seperti biasa
    return Padding(
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
                  'Target Tabungan: $targetTabungan',
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
                final savingModel = riwayatTabungan[index];
                return ListTile(
                  title: Text('Tabungan ke-${index + 1}'),
                  subtitle: Text(
                    'Jumlah: ${riwayatTabungan[index].nominal}',
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteSaving(savingModel);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _deleteSaving(SavingModel savingModel) async {
    try {
      bool success = await savingService!.deleteSaving(savingModel.id);
      if (success) {
        // Hapus tabungan dari daftar riwayat
        setState(() {
          riwayatTabungan.removeWhere((item) => item.id == savingModel.id);
          tabunganSaatIni = _calculateTotalSaving(); // Perbarui total tabungan saat ini
        });
        // Cek apakah tabungan saat ini seimbang dengan target tabungan
        bool isBalance = tabunganSaatIni >= targetTabungan;
        if (isBalance) {
          _checkIsBalance();
        }
      } else {
        // Handle error
      }
    } catch (error) {
      // Handle error
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menonaktifkan tombol kembali di kiri atas
        title: Text('Kelola Tabungan'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              _showConfirmationDialog(context);
            },
          ),
        ],
      ),
      body: savingService != null ? _buildMainContent() : _buildLoadingIndicator(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (savingService != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SavingAddScreen(savingService: savingService!),
              ),
            ).then((_) {
              // Setelah kembali dari SavingAddScreen, panggil refreshData() untuk memperbarui data
              refreshData();
            });
          }
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi"),
          content: Text("Apakah Anda yakin ingin beralih ke layar paket?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PackageScreen(), // Mengganti dengan PackageScreen
                  ),
                );
              },
              child: Text("Ya"),
            ),
          ],
        );
      },
    );
  }
}