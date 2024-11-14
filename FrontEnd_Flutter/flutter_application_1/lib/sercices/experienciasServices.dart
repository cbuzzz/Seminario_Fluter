import 'dart:convert';
import 'package:http/http.dart' as http;

class ExperienciaService {
  final String baseUrl = 'http://10.0.2.2:3000/api/experiencias';

  Future getExperiencias() async {
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

  Future<Map<String, dynamic>?> addExperiencia(String owner, List<String> participant, String description) async {
  final url = Uri.parse('$baseUrl/newUser');
  try {
    // Realizar solicitud POST con usuario y contraseña
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'owner': owner,
        'participants': participant,  
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);  // Decodifica y retorna la respuesta
    } else {
      return {'error': 'Error: No se pudo añadir la experiencia'};
    }
  } catch (e) {
    print('Error: $e');
    return {'error': 'Error: No se pudo conectar con la API'};
  }
  }

  Future<Map<String, dynamic>?> updateExperiencia(String id, String owner, List<String> participant, String description) async {
    final url = Uri.parse('$baseUrl/$id');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'owner': owner,
          'participants': participant,  
          'description': description,
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

  Future<Map<String, dynamic>?> deleteExperiencia(String id) async {
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