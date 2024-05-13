import 'package:flutter/material.dart';
import 'package:wisatapahala/services/user_service.dart';
import 'package:wisatapahala/screens/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _register(BuildContext context) {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    
    if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      UserService.registerUser(context, username, email, password);
    } else {
      _showErrorDialog(
        context,
        'Error',
        'Please fill in all fields.',
      );
    }
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Register',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      screenWidth,
                      'Username',
                      _usernameController,
                    ),
                    _buildTextField(
                      screenWidth,
                      'Email',
                      _emailController,
                    ),
                    _buildTextField(
                      screenWidth,
                      'Password',
                      _passwordController,
                      isPassword: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _register(context),
                      child: Text('Register'),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
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
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(double screenWidth, String label, TextEditingController controller, {bool isPassword = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
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
            controller: controller,
            obscureText: isPassword,
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
      ],
    );
  }
}
