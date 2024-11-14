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

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;
  String? _passwordErrorMessage;

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

  // funció per crear un nou usuari
  Future<void> _registerUser() async {
    
    // Comprova que les contrasenyes coincideixen
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _passwordErrorMessage = 'Les contrasenyes no coincideixen!';
      });
      return; // Si no coincideixen, no continuem amb la creació de l'usuari
    } else {
      setState(() {
        _passwordErrorMessage = null; // Esborrem el missatge d'error si les contrasenyes són correctes
      });
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await _userService.register(
      _usernameController.text,
      _mailController.text, 
      _passwordController.text,
      _commentController.text
    );

    setState(() {
      _isLoading = false;
    });

    if (response != null && response['error'] == null) {
      // si la creació de l'usuari és correcta, netegem els camps
       _usernameController.clear();
      _mailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      _commentController.clear();


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Registrado con éxito!'),
          duration: Duration(seconds: 3),
        ),
      );
      getUsers(); // actualitzar la llista després del nou usuari
    } else {
      setState(() {
        _errorMessage = response?['error'] ?? 'Error desconocido';
      });
    }
  }

  // funció per eliminar un usuari
  Future<void> deleteUser(String userId) async {
    final response = await _userService.deleteUser(userId);

    if (response != null && response['error'] == null) {
      // Si l'usuari s'elimina correctament, actualitzem la llista d'usuaris
      setState(() {
        _data.removeWhere((user) => user['_id'] == userId); // Eliminar de la llista local
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuari eliminat amb èxit!'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      // En cas d'error, mostrar un missatge d'error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response?['error'] ?? 'Error desconegut al eliminar'),
        ),
      );
    }
  }

  // Funció per eliminar un usuari amb confirmació
  Future<void> _confirmDeleteUser(String userId) async {
    bool confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Estàs segur?'),
          content: Text('Vols eliminar aquest usuari? Aquesta acció no es pot desfer.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);  // Cancela l'eliminació
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // Confirma l'eliminació
              },
              child: Text('Sí'),
            ),
          ],
        );
      },
    ) ?? false; // Si el diàleg es tanca sense selecció, retornem false

    // Si l'usuari confirma, eliminem l'usuari
    if (confirm) {
      await deleteUser(userId);
    }
  }


 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Part esquerra: Llista d'usuaris
            Expanded(
              flex: 3,
              child: _data.isEmpty
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_data[index]['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_data[index]['mail']),
                              Text(_data[index]['comment']),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _confirmDeleteUser(_data[index]['_id']); // crida la funció per eliminar l'usuari amb confirmació
                            }, 
                            icon: Icon(Icons.delete, color: Colors.red)),
                        );
                      },
                    ),
            ),
            SizedBox(width: 20), // Espai entre la llista i el formulari
            // Part dreta: Formulari de registre
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Crear Nou Usuari',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
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
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(labelText: 'Confirmar Contraseña'),
                    obscureText: true,
                  ),
                  
                  if (_passwordErrorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _passwordErrorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
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
                      onPressed: _registerUser,
                      child: Text('Registrar'),
                    ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  
}




/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
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
  }*/


}