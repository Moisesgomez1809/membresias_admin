import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:membresias_admin/screens/home_screen.dart';
import 'package:membresias_admin/screens/manage_business_screen.dart';
import 'package:membresias_admin/screens/login_screen.dart';
import 'package:membresias_admin/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Entrando en AuthWrapper");

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Esperando el estado de autenticación...");
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          final userEmail = snapshot.data?.email;
          print(
              "Usuario logueado: $userEmail"); // Verifica si el correo se obtiene correctamente

          if (userEmail != null) {
            return FutureBuilder<String?>(
              future: AuthService().getUserRole(userEmail),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  print("Esperando el rol...");
                  return Center(child: CircularProgressIndicator());
                } else if (roleSnapshot.hasData) {
                  final role = roleSnapshot.data;
                  print(
                      "Rol del usuario: $role"); // Verifica el rol que obtienes de Firestore

                  if (role == 'admin') {
                    print("Redirigiendo a HomeScreen...");
                    return HomeScreen();
                  } else if (role == 'business_user') {
                    print("Redirigiendo a ManageBusinessesScreen...");
                    return ManageBusinessScreen();
                  } else {
                    print("Redirigiendo a LoginScreen...");
                    return LoginScreen();
                  }
                } else {
                  print("Error al obtener el rol o no existe");
                  return LoginScreen();
                }
              },
            );
          } else {
            print("No hay usuario logueado");
            return LoginScreen(); // Si no hay usuario, redirigir a Login
          }
        } else {
          print("No hay datos de usuario");
          return LoginScreen(); // Si no hay datos, redirigir a Login
        }
      },
    );
  }
}
