import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/experienceModel.dart';
import 'package:flutter_application_1/services/experience.dart';

class ExperienceController extends GetxController {
  // Listado de experiencias y estado de carga
  RxList<ExperienceModel> experienceList = <ExperienceModel>[].obs;
  RxBool isLoading = false.obs;
  final ExperienceService _experienceService = ExperienceService();

  // Controladores de texto para el formulario
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController participantsController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExperiences();
  }

  // Obtener todas las experiencias
  Future<void> fetchExperiences() async {
    isLoading(true);
    try {
      var data = await _experienceService.getExperiences();
      experienceList.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "No se pudieron obtener las experiencias.",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  // Crear nueva experiencia
  Future<void> createExperience() async {
    final newExperience = ExperienceModel(
      owner: ownerController.text,
      participants: participantsController.text,
      description: descriptionController.text,
    );

    try {
      final response = await _experienceService.createExperience(newExperience);

      if (response == 201) {
        fetchExperiences(); // Actualiza la lista
        Get.snackbar("Éxito", "Experiencia creada correctamente.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo crear la experiencia.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Editar una experiencia
  Future<void> editExperience(String id) async {
    final updatedExperience = ExperienceModel(
      id:id,
      owner: ownerController.text,
      participants: participantsController.text,
      description: descriptionController.text,
    );

    try {
      final response = await _experienceService.editExperience(updatedExperience, id);

      if (response == 201) {
        fetchExperiences(); // Actualiza la lista
        Get.snackbar("Éxito", "Experiencia actualizada correctamente.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar la experiencia.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Eliminar una experiencia
  Future<void> deleteExperience(String id) async {
    try {
      final response = await _experienceService.deleteExperience(id);

      if (response == 200 || response == 204) {
        fetchExperiences(); // Actualiza la lista
        Get.snackbar("Éxito", "Experiencia eliminada correctamente.",
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar("Error", "No se pudo eliminar la experiencia.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Ocurrió un error al eliminar la experiencia.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
