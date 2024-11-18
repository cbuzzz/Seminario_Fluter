import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/experience.dart';
import 'package:flutter_application_1/models/experienceModel.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/controllers/userModelController.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/controllers/experienceListController.dart';
import 'package:flutter_application_1/models/userModel.dart';

class ExperienceController extends GetxController {
  final ExperienceService experienceService = ExperienceService();
  final UserService userService = UserService();
  final ExperienceListController experienceListController = Get.find();

  final TextEditingController descriptionController = TextEditingController();
  var selectedParticipants = <UserModel>[].obs; // Participantes seleccionados
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  void toggleParticipant(UserModel user) {
    if (selectedParticipants.contains(user)) {
      selectedParticipants.remove(user);
    } else {
      selectedParticipants.add(user);
    }
  }

  bool validateInputs() {
    return descriptionController.text.isNotEmpty && selectedParticipants.isNotEmpty;
  }

  void createExperience() async {
    final ownerId = userService.getId();

    if (!validateInputs() || ownerId == null) {
      errorMessage.value = 'Campos vacíos o sin participantes';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;

    try {
      final participantIds = selectedParticipants.map((u) => u.id).where((id) => id!.isNotEmpty).toList();

      ExperienceModel newExperience = ExperienceModel(
        id: '',
        owner: ownerId,
        participants: participantIds,
        description: descriptionController.text,
      );

      final response = await experienceService.createExperience(newExperience);

      if (response == 201) {
        experienceListController.fetchExperiences();
        Get.snackbar('Éxito', 'Experiencia creada exitosamente');
      } else {
        throw Exception('Error al crear experiencia');
      }
    } catch (e) {
      Get.snackbar('Error', 'No se pudo crear la experiencia', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}

