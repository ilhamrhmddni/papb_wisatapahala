import 'package:flutter/material.dart';
import 'package:wisatapahala/services/user_service.dart';
import 'package:wisatapahala/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  // Controllers untuk mengontrol input username, email, dan password
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back pada app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Judul Register
            Text(
              'Register',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20), // Spasi
            // Input field untuk username
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            // Input field untuk email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            // Input field untuk password
            TextField(
              controller: _passwordController,
              obscureText: true, // Sembunyikan teks
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20), // Spasi
            // Tombol untuk melakukan registrasi
            ElevatedButton(
              onPressed: () {
                // Ambil nilai dari input fields
                String username = _usernameController.text.trim();
                String email = _emailController.text.trim();
                String password = _passwordController.text.trim();
                // Periksa apakah semua input fields tidak kosong
                if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
                  // Panggil fungsi registerUser dari UserService untuk melakukan registrasi
                  UserService.registerUser(context, username, email, password);
                } else {
                  // Tampilkan dialog error jika ada input fields yang kosong
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please fill in all fields.'),
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
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
      // Tombol navigasi untuk masuk ke layar login
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text('Sudah punya akun? Masuk di sini'),
        ),
      ),
    );
  }
}
