import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/models/userModel.dart';
import 'package:flutter_application_1/pages/experiencies.dart';
import 'package:flutter_application_1/pages/logIn.dart';
import 'package:flutter_application_1/pages/perfil.dart';
import 'package:flutter_application_1/pages/register.dart';
import 'package:flutter_application_1/pages/user.dart';
import 'package:flutter_application_1/pages/home.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( ChangeNotifierProvider(
      create: (_) => UserModel(),
      child: MyApp(),
    ),
  ); //utilitza Provider per gestionar l'estat global de l'usuari
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', //estableix la pàgina inicial de l'app
      getPages: [ //defineic les rutes de l'app, cada una amb una pàgina corresponent
        
        // Ruta de inicio de sesión
        GetPage(
          name: '/login',
          page: () => LogInPage(),
        ),
        
        // Ruta de registro
        GetPage(
          name: '/register',
          page: () => RegisterPage(),
        ),
        
        // Ruta de la pantalla principal con BottomNavScaffold
        GetPage(
          name: '/home',
          page: () => BottomNavScaffold(child: HomePage()),
        ),
        GetPage(
          name: '/usuarios',
          page: () => BottomNavScaffold(child: UserPage()),
        ),
        GetPage(
          name: '/experiencies',
          page: () => BottomNavScaffold(child: ExperienciesPage()),
        ),
        GetPage(
          name: '/perfil',
          page: () => BottomNavScaffold(child: PerfilPage()),
        ),
      ],
    );
  }
}

// widget que conté el cos de l'app amb una barra de navegació inferior
class BottomNavScaffold extends StatefulWidget {
  final Widget child;

  const BottomNavScaffold({required this.child});

  @override
  _BottomNavScaffoldState createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int _selectedIndex = 0;
  
  // gestió de la barra de navegació (canvia l'index que toca)
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Navegación usando Get.toNamed()
    switch (_selectedIndex) {
      case 0:
        Get.toNamed('/home');
        break;
      case 1:
        Get.toNamed('/usuarios');
        break;
      case 2:
        Get.toNamed('/experiencies');
        break;
      case 3:
        Get.toNamed('/perfil');
        break;
    }
  }

  // funció build del widget 
  @override
  Widget build(BuildContext context) {
    //Scaffold és un widget que proporciona una estructura bàsica per a les pantalles de l'app.
    return Scaffold(
      body: widget.child, //el contingut de la pagina (AppBar) s'especifica per un widget fill que es passarà a través del constructor del widget bottomNavScaffold
      bottomNavigationBar: BottomNavigationBar( //defineic la barra de navegació inferior
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, //canvia l'index seleccionat
        selectedItemColor: const Color.fromARGB(255, 92, 14, 105),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Usuarios',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_activity),
            label: 'Experiencias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}