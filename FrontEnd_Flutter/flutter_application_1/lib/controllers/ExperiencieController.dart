import 'package:get/get.dart';
import 'package:flutter_application_1/models/experienceModel.dart';
import 'package:flutter_application_1/services/experienceService.dart';

class ExperienceController extends GetxController {
  // Listado de experiencias y estado de carga
  RxList<ExperienceModel> experienceList = <ExperienceModel>[].obs;
  RxBool isLoading = false.obs;
  final ExperienceService _experienceService = ExperienceService();

  // Formulario
  Rx<TextEditingController> ownerController = TextEditingController().obs;
  Rx<TextEditingController> participantsController = TextEditingController().obs;
  Rx<TextEditingController> descriptionController = TextEditingController().obs;

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
      print("Error fetching experiences: $e");
    } finally {
      isLoading(false);
    }
  }

  // Crear nueva experiencia
  Future<void> createExperience() async {
    final newExperience = ExperienceModel(
      owner: ownerController.value.text,
      participants: participantsController.value.text,
      description: descriptionController.value.text,
    );

    final response = await _experienceService.createExperience(newExperience);

    if (response == 201) {
      fetchExperiences();  // Actualiza la lista
    }
  }

  // Editar una experiencia
  Future<void> editExperience(String id) async {
    final updatedExperience = ExperienceModel(
      owner: ownerController.value.text,
      participants: participantsController.value.text,
      description: descriptionController.value.text,
    );

    final response = await _experienceService.editExperience(updatedExperience, id);

    if (response == 201) {
      fetchExperiences();  // Actualiza la lista
    }
  }

  // Eliminar una experiencia
  Future<void> deleteExperience(String id) async {
    final response = await _experienceService.deleteExperience(id);

    if (response == 200) {
      fetchExperiences();  // Actualiza la lista
    }
  }
}
