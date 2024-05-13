import 'package:flutter/material.dart';
import 'package:wisatapahala/services/user_service.dart';
import 'package:wisatapahala/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Fungsi untuk melakukan proses login
  void _login(BuildContext context) async {
    String email = emailController.text;
    String password = passwordController.text;

    // Validasi apakah email dan password tidak kosong
    if (email.isNotEmpty && password.isNotEmpty) {
      // Memanggil fungsi loginUser dari UserService
      await UserService.loginUser(context, email, password);
    } else {
      // Tampilkan pesan kesalahan jika email atau password kosong
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Email dan password tidak boleh kosong.'),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF00AD9A),
      ),
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.white,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.35,
                decoration: BoxDecoration(
                  color: Color(0xFF00AD9A),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(screenHeight * 0.06),
                    bottomRight: Radius.circular(screenHeight * 0.06),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00AD9A)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00AD9A)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24), // Jarak ke bawah setelah email
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: screenWidth * 0.035,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Container(
                        width: screenWidth * 0.8,
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00AD9A)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF00AD9A)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24), // Jarak ke bawah setelah password
                    ],
                  ),
                  SizedBox(height: 24), // Jarak ke bawah setelah tombol Login
                  ElevatedButton(
                    onPressed: () => _login(context),
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF00AD9A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16), // Atur padding tombol
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: TextButton(
                onPressed: () {
                  // Navigasi ke layar pendaftaran saat tombol ditekan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: Text('Belum punya akun? Daftar di sini'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
