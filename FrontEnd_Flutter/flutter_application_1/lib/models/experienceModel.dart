import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/services/user.dart';

class ExperienceModel with ChangeNotifier {
  final String id;
  final owner;
  final List<String> participants;
  String description;

  UserModel? ownerDetails; // Detalles del propietario
  List<UserModel>? participantsDetails;

  // Constructor
  ExperienceModel({
    required this.id,
    required this.owner,
    required List<String?> participants,
    required this.description,
    this.ownerDetails,
    this.participantsDetails,
  }) : participants = participants.whereType<String>().toList();

  // Método para crear una instancia desde un JSON
  factory ExperienceModel.fromJson(Map<String, dynamic> json) {
    return ExperienceModel(
      id: json['_id']?.toString() ?? '', // Convertir ID a String
      owner:
          json['owner']?['_id']?.toString() ?? '', // Convertir owner a String
      participants: (json['participants'] as List?) // Asegurar lista
              ?.map((p) => p['_id']?.toString()) // Convertir elementos a String
              .toList() ??
          [],
      description: json['description']?.toString() ?? 'Sin descripción',
    );
  }

  // Método para convertir el modelo en JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'owner': owner, // Solo el ID
      'participants': participants, // IDs de los participantes
      'description': description,
    };
  }

  Future<void> loadDetails(List<ExperienceModel> experiences) async {
    final userService = UserService();

    try {
      // Obtener solo los IDs de los usuarios
      final usersId = await userService.getUsersId();

      if (usersId.isEmpty) {
        print("No se encontraron usuarios.");
        return;
      }

      print('GET IDs: $usersId');

      for (var experience in experiences) {
        print('Procesando experiencia ID: ${experience.id}');

        // Validar y cargar el propietario
        if (usersId.contains(experience.owner)) {
          final ownerDetails = await userService.getUser(experience.owner);
          if (ownerDetails != null) {
            experience.ownerDetails = ownerDetails;
            print(
                'Detalles del propietario cargados: ${ownerDetails.name} para experiencia ${experience.id}');
          } else {
            print(
                'Error: No se encontraron detalles para el propietario con ID ${experience.owner}');
          }
        } else {
          print(
              'El propietario con ID ${experience.owner} no está en la lista de usuarios.');
        }

        // Validar y cargar los detalles de los participantes
         experience.participantsDetails = await Future.wait(
        experience.participants.map((participantId) async {
          if (usersId.contains(participantId)) {
            return await userService.getUser(participantId);
          }
          return null; // Ignorar IDs de participantes no válidos
        }),
      ).then((list) => list.whereType<UserModel>().toList());

        print(
            'Detalles de participantes cargados para experiencia ${experience.id}: '
            '${experience.participantsDetails?.map((e) => e.name).toList()}');
      }

      // Notificar cambios
      notifyListeners();
    } catch (e) {
      print("Error al cargar detalles de las experiencias: $e");
    }
  }
}
