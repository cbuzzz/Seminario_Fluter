import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/userModel.dart'; // Ajusta la ruta si tu modelo está en otra carpeta
import '../services/user.dart';
import '../controllers/userListController.dart';

class UserCard extends StatelessWidget {
  final UserModel user;

  const UserCard({Key? key, required this.user}) : super(key: key);

  void _deleteUser(BuildContext context, String userId) async {
    final userService = UserService();
    final UserListController userListController = Get.put(UserListController());

    try {
      int statusCode = await userService.deleteUser(userId);
      print('el delete devuelve:$statusCode');

      if (statusCode == 201|| statusCode==200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario eliminado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
         // Actualiza la lista de usuarios
        await userListController.fetchUsers();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al eliminar el usuario.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(user.mail),
            const SizedBox(height: 8),
            Text(user.comment ?? "Sin comentarios"),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _deleteUser(
                    context, user.id!), // Llama al método de eliminación
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text('Borrar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
