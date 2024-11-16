import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/controllers/experience_list_controller.dart';

class ExperiencePage extends StatefulWidget {
  @override
  _ExperiencePageState createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  final ExperienceListController experienceController = Get.put(ExperienceListController());

  Future<void> _confirmDeleteExperience(String experienceId) async {
    bool confirm = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¿Estás seguro?'),
              content: Text('¿Quieres eliminar esta experiencia? Esta acción no se puede deshacer.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      final success = await experienceController.deleteExperience(experienceId);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Experiencia eliminada con éxito!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error desconocido al eliminar')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Experience Management')),
      body: Obx(() {
        if (experienceController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (experienceController.experienceList.isEmpty) {
          return Center(child: Text("No hay experiencias disponibles"));
        } else {
          return ListView.builder(
            itemCount: experienceController.experienceList.length,
            itemBuilder: (context, index) {
              final experience = experienceController.experienceList[index];
              return ListTile(
                title: Text(experience.owner),
                subtitle: Text(experience.description),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _confirmDeleteExperience(experience.id),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
