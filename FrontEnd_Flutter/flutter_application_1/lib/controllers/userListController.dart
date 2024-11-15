import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/services/user.dart';
import 'package:flutter_application_1/models/userModel.dart';

class UserListController extends GetxController {
  var isLoading = true.obs;
  var userList = <UserModel>[].obs;
  final UserService userService = UserService();

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading(true);
      var users = await userService.getUsers();
      if (users != null) {
        userList.assignAll(users);
      }
    } catch (e) {
      print("Error fetching users: $e");
    } finally {
      isLoading(false);
    }
  }


/*  // Método para eliminar un usuario
  Future<void> deleteUser(String userId) async {
    try {
      isLoading(true); // Activar indicador de carga durante la eliminación
      var response = await userService.deleteUser(userId);
      if (response == 201) {
        userList.removeWhere((user) => user.id == userId); // Actualizar lista
        Get.snackbar(
          "Éxito",
          "Usuario eliminado correctamente",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          "Error",
          "No se pudo eliminar el usuario",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Ocurrió un error al eliminar el usuario",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false); // Desactivar indicador de carga
    }
  } */
}

