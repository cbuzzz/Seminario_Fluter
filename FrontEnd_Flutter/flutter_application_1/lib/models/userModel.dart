import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  // variables privades per emmagatzemar les dades de l'usuari
  String _name = 'Usuario desconocido';
  String _mail = 'No especificado';
  String _comment = 'Sin comentarios';

  // getters
  String get name => _name;
  String get mail => _mail;
  String get comment => _comment;

  // mètode per actualitzar les dades de l'usuari
  void setUser(String name, String mail, String comment) {
    _name = name;
    _mail = mail;
    _comment = comment;
    notifyListeners(); // funció que notifica tots els widgets que les dades han canviat
  }
}
