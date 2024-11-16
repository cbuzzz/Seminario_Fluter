import 'package:get/get.dart';
import 'package:flutter_application_1/services/experience_service.dart';
import 'package:flutter_application_1/models/experience_model.dart';

class ExperienceListController extends GetxController {
  var isLoading = true.obs;
  var experienceList = <ExperienceModel>[].obs;
  final ExperienceService experienceService = Get.find<ExperienceService>();

  @override
  void onInit() {
    super.onInit();
    fetchExperiences();

  }

  Future<void> fetchExperiences() async {
    try {
      isLoading(true);
      var experiences = await experienceService.getExperiences();
      if (experiences != null) {
        experienceList.assignAll(experiences);
      }
    } catch (e) {
      print("Error fetching experiences: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> editExperience(String id, ExperienceModel updatedExperience) async {
    try {
      isLoading(true);  // Establecemos el estado de carga a true
      var statusCode = await experienceService.EditExperience(updatedExperience, id);
      if (statusCode == 201) {
        Get.snackbar('Éxito', 'Experiencia actualizada con éxito');
        fetchExperiences();  // Recargamos la lista de experiencias después de editar
      } else {
        Get.snackbar('Error', 'Error al actualizar la experiencia');
      }
    } catch (e) {
      print("Error editing experience: $e");
    } finally {
      isLoading(false);  // Establecemos el estado de carga a false una vez que termine
    }
  }
}
