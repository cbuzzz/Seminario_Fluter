import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/services/user.dart';


class ExperienceModel with ChangeNotifier {
  final String id;
  final String owner;
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
    owner: json['owner']?.toString() ?? 'Sin propietario', // Convertir owner a String
    participants: (json['participants'] as List?) // Asegurar lista
            ?.map((p) => p?.toString()) // Convertir elementos a String
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

 Future<void> loadDetails() async {
    final userService = UserService();

    try {
      // Obtener detalles del propietario
      ownerDetails = await userService.getUser(owner);

      // Obtener detalles de los participantes
      participantsDetails = await Future.wait(
        participants.map((id) => userService.getUser(id)),
      ).then((list) => list.whereType<UserModel>().toList());
    } catch (e) {
      print("Error al cargar detalles: $e");
    }
  }

}
