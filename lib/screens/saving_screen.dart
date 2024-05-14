import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wisatapahala/models/package_model.dart';
import 'package:wisatapahala/models/saving_model.dart';
import 'package:wisatapahala/screens/package_screen.dart';
import 'package:wisatapahala/screens/saving_add_screen.dart';
import 'package:wisatapahala/services/package_service.dart';
import 'package:wisatapahala/services/saving_service.dart';
import 'package:wisatapahala/services/user_service.dart';

class SavingScreen extends StatefulWidget {
  final PackageModel packageModel;
  final String idPackage;

  SavingScreen({required this.packageModel, required this.idPackage});

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
    print("Initializing and loading data...");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('id_user');
      String? idPackage = prefs.getString('id_package');
      if (userId != null && idPackage != null) {
        setState(() {
          savingService = SavingService(userId);
        });
        print("Selected user ID: $userId");
        print("Selected package ID: $idPackage");

        String? price = await PackageService.getPaketPriceById(idPackage);
        if (price != null) {
          setState(() {
            targetTabungan = int.parse(price);
          });
          print("Package price: $price");
        } else {
          print('Error: price is null');
          return;
        }

        if (savingService != null) {
          List<SavingModel> rawData =
              await savingService!.getAllTabungan(userId);
          setState(() {
            riwayatTabungan = rawData;
            tabunganSaatIni = _calculateTotalSaving();
            _dataLoaded = true;
          });
          print("Total savings: $tabunganSaatIni");
          _checkIsBalance();
        } else {
          print('Error: userId is null');
        }
      } else {
        print('Error: userId or idPackage is null');
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

  Future<void> refreshData() async {
    print("Refreshing data...");
    _initializeAndLoadData();
  }

  void _checkIsBalance() {
    bool isBalance = tabunganSaatIni >= targetTabungan;

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
    double percentage = (tabunganSaatIni / targetTabungan) * 100;
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.all(8),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  Color(0xFF00AD9A), // Pindahkan warna ke dalam BoxDecoration
              borderRadius:
                  BorderRadius.circular(10), // Tambahkan border radius di sini
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 12.0),
                        width: 125,
                        height: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.packageModel.nama,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.4,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${DateFormat('dd MMMM yyyy').format(widget.packageModel.tanggalKepergian)} - ${DateFormat('dd MMMM yyyy').format(widget.packageModel.tanggalKepulangan)}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 8),
                            Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                widget.packageModel.jenis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.814,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w500,
                                  height: 0,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(widget.packageModel.harga),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21.56,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0,
                              ),
                            ),
                            SizedBox(height: 8),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          top: 185, // Atur nilai ini sesuai dengan preferensi tata letak Anda
          child: Container(
            padding: EdgeInsets.all(16.0),
            margin:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 72.0),
            decoration: BoxDecoration(
              color: Color(0xFF00AD9A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(tabunganSaatIni)}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00AD9A)),
                          ),
                          Text(
                            '/  ${NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(targetTabungan)}',
                            style: TextStyle(
                                fontSize: 15, color: Color(0xFF00AD9A)),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF00AD9A),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text(
                          '${percentage.toStringAsFixed(0)}%',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Catatan Tabungan :',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 12),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(2.0),
                    itemCount: riwayatTabungan.length,
                    itemBuilder: (context, index) {
                      final savingModel = riwayatTabungan[index];
                      final formattedDateTime = DateFormat('dd-MM-yy HH:mm')
                          .format(savingModel.waktu);
                      return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp',
                                decimalDigits: 0,
                              ).format(riwayatTabungan[index].nominal),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${formattedDateTime}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  GestureDetector(
                                    onDoubleTap: () {
                                      _deleteSaving(savingModel);
                                    },
                                    onTap: () {
                                      _showSnackBar(context);
                                    },
                                    child:
                                        Icon(Icons.delete, color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tap dua kali untuk menghapus'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteSaving(SavingModel savingModel) async {
    try {
      bool success = await savingService!.deleteSaving(savingModel.id);
      if (success) {
        setState(() {
          riwayatTabungan.removeWhere((item) => item.id == savingModel.id);
          tabunganSaatIni = _calculateTotalSaving();
        });
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
        backgroundColor: const Color(0xFF00AD9A),
        title: Text(
          'Tabungan Anda',
          style: TextStyle(color: Colors.white),
        ),
        leading: Builder(
          // Gunakan Builder di sini
          builder: (context) => IconButton(
            icon: Icon(Icons.menu), color: Colors.white, // Icon hamburger
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Tampilkan drawer saat ditekan
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                widget.packageModel.nama,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              accountEmail: Text(
                widget.packageModel.jenis,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              currentAccountPicture: CircleAvatar(
                // Di sini Anda dapat menambahkan gambar profil pengguna
                backgroundColor: Colors.white,
                child: Text(
                  'A', // Inisial nama pengguna
                  style: TextStyle(
                    fontSize: 40,
                    color: const Color(0xFF00AD9A),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF00AD9A),
              ),
            ),
            ListTile(
              title: Text('Ganti Package'),
              onTap: () {
                _showConfirmationDialog(context, 'Ganti Package',
                    'Apakah Anda yakin ingin beralih Paket?', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PackageScreen()),
                  );
                });
              },
            ),
            Expanded(
              child: SizedBox(),
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                _showConfirmationDialog(
                    context, 'Logout', 'Apakah Anda yakin ingin logout?', () {
                  UserService.logoutUser(context);
                });
              },
            ),
          ],
        ),
      ),
      body: savingService != null
          ? Stack(
              children: [
                _buildMainContent(),
                Positioned(
                  right: 12.0,
                  bottom: 10.0,
                  child: FloatingActionButton(
                    onPressed: () {
                      if (savingService != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SavingAddScreen(savingService: savingService!),
                          ),
                        ).then((_) {
                          refreshData();
                        });
                      }
                    },
                    backgroundColor: Color(0xFF00AD9A),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          : _buildLoadingIndicator(),
    );
  }

  void _showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    Function() onConfirm,
    {bool isLogout = false}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Batal", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              onConfirm();
              if (isLogout) {
                UserService.logoutUser(context); // Logout and navigate to LoginScreen
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => PackageScreen()),
                );
              }
            },
            child: Text(
              "Ya",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      );
    },
  );
}
}
