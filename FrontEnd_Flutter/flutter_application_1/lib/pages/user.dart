import 'package:flutter/material.dart';
import 'package:flutter_application_1/sercices/userServices.dart';

class UserPage extends StatefulWidget{
  @override
  _UserPageState createState() => _UserPageState();
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('User'),
      ),
    );
  }
}

class _UserPageState extends State<UserPage> {
  List<dynamic> _data = [];
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    getUsers(); // Llamamos a la función para obtener datos cuando la página se carga
  }

  Future<void> getUsers() async {
    final data = await _userService.getUsers();
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Datos de la API Local')),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                    title: Text(_data[index]['name']), 
                    subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_data[index]['mail']),     // Primer subtítulo (correo)
                      Text(_data[index]['comment']),  // Segundo subtítulo (comentario)
                    ],
                  ),
                );
              },
            ),
    );
  }
}