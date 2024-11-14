import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  // URL base del servidor local simulat mitjançant 10.0.2.2 per a l'emulador Android
  final String baseUrl = 'http://10.0.2.2:3000/api/user';

  // Obtenir la llista d'usuaris
  Future getUsers() async {
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error al cargar los datos');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  // Autenticar un usuari enviant username i password
  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/logIn');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': username, 'password': password}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Usuario o contraseña incorrectos'};
      }
    } catch (e) {
      return {'error': 'No se pudo conectar con la API'};
    }
  }

  // Crear un nou usuari
  Future<Map<String, dynamic>?> register(String username, String mail, String password, String comment) async {
    final url = Uri.parse('$baseUrl/newUser');

    try {
      // Realizar solicitud POST con usuario y contraseña
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'mail': mail,
          'password': password,
          'comment': comment,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'Usuario o contraseña incorrectos'};
      }
    } catch (e) {
      return {'error': 'No se pudo conectar con la API'};
    }
  }

  // Modificar un usuari
  Future<Map<String, dynamic>?> updateUser(String id, String username, String mail, String password, String comment) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': username,
          'mail': mail,
          'password': password,
          'comment': comment,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'No se ha podido actualizar al usuario'};
      }
    } catch (e) {
      return {'error': 'No se pudo conectar con la API'};
    }
  }

  // Eliminar usuari mitjançant l'ID
  Future<Map<String, dynamic>?> deleteUser(String id) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {'error': 'No se ha podido actualizar al usuario'};
      }
    } catch (e) {
      return {'error': 'No se pudo conectar con la API'};
    }
  }
}