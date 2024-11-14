import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/sercices/userServices.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService _userService = UserService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _userService.login(
      _usernameController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['error'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Inicio de sesión exitoso!'),
          duration: Duration(seconds: 3),
        ),
      );

      final name = response['name'];
      final mail = response['mail'];
      final comment = response['comment'];
      
      Provider.of<UserModel>(context, listen: false).setUser(name, mail, comment);
      Get.toNamed('/home');
    } else {
      setState(() {
        _errorMessage = response?['error'] ?? 'Error desconocido';
      });
    }
  }

  Future<void> _registrarseReturn() async {
    Get.toNamed('/register');
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Iniciar Sesión')),
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
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            if (_isLoading)
              CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _login,
                child: Text('Iniciar Sesión'),
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
              onPressed: _registrarseReturn,
              child: Text('Registrarse'),
            ),
          ],
        ),
      ),
    );
  }
}