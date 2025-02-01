import 'package:flutter/material.dart';
import 'package:membresias_admin/services/auth_service.dart'; // Asegúrate de que el servicio esté importado

class HomeScreen extends StatelessWidget {
  // Función para cerrar sesión
  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacementNamed(
        context, '/login'); // Redirige a la pantalla de login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Administración'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () =>
                _logout(context), // Llama a la función de cierre de sesión
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'BIENVENIDO ADMIN',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              '¿Qué deseas hacer hoy?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/generateQr');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0), // Tamaño del botón
                textStyle: const TextStyle(
                  inherit: true, // Asegúrate de que inherit sea true
                ),
              ),
              child: const Text(
                'Generar QR',
                style: TextStyle(
                  fontSize: 20, // Tamaño del texto
                  color: Colors.white, // Color del texto
                  inherit: true, // Asegúrate de que inherit sea true
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addMembership');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0), // Tamaño del botón
                textStyle: const TextStyle(
                  // Tamaño del texto
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
              child: const Text(
                'Agregar Membresía',
                style: TextStyle(
                  // Tamaño del texto
                  fontSize: 20,
                  color: Colors.white, // Color del texto
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/qrScanner');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0), // Tamaño del botón
                textStyle: const TextStyle(
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
              child: const Text(
                'Escanear QR',
                style: TextStyle(
                  fontSize: 20, // Tamaño del texto
                  color: Colors.white, // Color del texto
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageMembers');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0), // Tamaño del botón
                textStyle: const TextStyle(
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
              child: const Text(
                'Gestión de Miembros',
                style: TextStyle(
                  fontSize: 20, // Tamaño del texto
                  color: Colors.white, // Color del texto
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageBusinesses');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 30.0), // Tamaño del botón
                textStyle: const TextStyle(
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
              child: const Text(
                'Gestión de Negocios',
                style: TextStyle(
                  fontSize: 20, // Tamaño del texto
                  color: Colors.white, // Color del texto
                  inherit: false, // Asegúrate de que inherit sea false
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
