import 'package:flutter/material.dart';
import 'package:flutter_application_1/sercices/userServices.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  final UserService _userService = UserService();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _registrarse() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _userService.register(
      _usernameController.text,
      _mailController.text,
      _passwordController.text,
      _commentController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registrado con éxito!'),
          duration: Duration(seconds: 3),
        ),
      );
      Get.toNamed('/home');
    } else {
      setState(() {
        _errorMessage = response?['error'] ?? 'Error desconocido';
      });
    }
  }

  Future<void> _logInreturn() async {
    Get.toNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registrarse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _mailController,
              decoration: InputDecoration(labelText: 'Mail'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: _commentController,
              decoration: InputDecoration(labelText: 'Comentario'),
            ),
            SizedBox(height: 16),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _registrarse,
                child: Text('Registrarse'),
              ),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ElevatedButton(
              onPressed: _logInreturn,
              child: Text('Volver'),
            ),
          ],
        ),
      ),
    );
  }
}