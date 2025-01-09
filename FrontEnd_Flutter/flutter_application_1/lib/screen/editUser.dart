import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/userModel.dart';
import '../controllers/userListController.dart';
import '../services/user.dart';

class EditUserPage extends StatefulWidget {
  final UserModel user;

  EditUserPage({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final UserService userService = Get.put(UserService());
  final UserListController userListController = Get.put(UserListController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.name ?? '';
    mailController.text = widget.user.mail ?? '';
    passwordController.text =
        ''; // Deja el campo de contraseña vacío inicialmente
    commentController.text = widget.user.comment ?? '';
  }

  void _updateUser(BuildContext context) async {
    final updatedUser = UserModel(
      id: widget.user.id,
      name: nameController.text,
      mail: mailController.text,
      password: passwordController.text.isNotEmpty
          ? passwordController.text
          : widget.user.password,
      comment: commentController.text,
    );

    try {
      int statusCode = await userService.updateUser(updatedUser);
      if (statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Usuario actualizado con éxito.'),
            backgroundColor: Colors.green,
          ),
        );
        await userListController.fetchUsers();
        Get.back();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error al actualizar el usuario.'),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: mailController,
              decoration: InputDecoration(labelText: 'Correo Electrónico'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Comentario'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _updateUser(context),
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
