import 'package:flutter_application_1/models/experienceModel.dart';
import 'package:dio/dio.dart';



class ExperienceService {
  final String baseUrl = "http://127.0.0.1:3000"; // URL de tu backend web
  //final String baseUrl = "http://10.0.2.2:3000"; // URL de tu backend Android
  final Dio dio = Dio(); // Usa el prefijo 'Dio' para referenciar la clase Dio
  var statusCode;
  var data;


  //Función createUser
  Future<int> createExperience(ExperienceModel newExperience)async{
    print('createExperience');
    print('try');
    //Aquí llamamos a la función request
    print('request');
    // Utilizar Dio para enviar la solicitud POST a http://127.0.0.1:3000/experiencias
    Response response = await dio.post('$baseUrl/experiencias', data: newExperience.toJson());
    //En response guardamos lo que recibimos como respuesta
    //Printeamos los datos recibidos

    data = response.data.toString();
    print('Data: $data');
    //Printeamos el status code recibido por el backend

    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      // Si el usuario se crea correctamente, retornamos el código 201
      print('201');
      return 201;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');

      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');

      return 500;
    } else {
      // Otro caso no manejado
      print('-1');

      return -1;
    }
  }

  Future<List<ExperienceModel>> getExperiences() async {
    print('getExperiences');
    try {
      var res = await dio.get('$baseUrl/experiencias');
      List<dynamic> responseData = res.data; // Obtener los datos de la respuesta
    
      // Convertir los datos en una lista de objetos Place
      List<ExperienceModel> users = responseData.map((data) => ExperienceModel.fromJson(data)).toList();
    
      return users; // Devolver la lista de lugares
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir durante la solicitud
      print('Error fetching data: $e');
      throw e; // Relanzar el error para que el llamador pueda manejarlo
    }
  }

  Future<int> EditExperience(ExperienceModel newExperience, String id)async{
    print('createExperience');
    print('try');
    //Aquí llamamos a la función request
    print('request');

   

    // Utilizar Dio para enviar la solicitud POST a http://127.0.0.1:3000/experiencias
    Response response = await dio.put('$baseUrl/experiencias/$id', data: newExperience.toJson());
    //En response guardamos lo que recibimos como respuesta
    //Printeamos los datos recibidos

    data = response.data.toString();
    print('Data: $data');
    //Printeamos el status code recibido por el backend

    statusCode = response.statusCode;
    print('Status code: $statusCode');

    if (statusCode == 201) {
      // Si el usuario se crea correctamente, retornamos el código 201
      print('201');
      return 201;
    } else if (statusCode == 400) {
      // Si hay campos faltantes, retornamos el código 400
      print('400');

      return 400;
    } else if (statusCode == 500) {
      // Si hay un error interno del servidor, retornamos el código 500
      print('500');

      return 500;
    } else {
      // Otro caso no manejado
      print('-1');

      return -1;
    }
  }


}