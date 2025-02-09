import 'package:flutter/material.dart';
import 'package:membresias_admin/services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double _panelPosition = 0.10; // Altura inicial del panel

  // Función para cerrar sesión
  void _logout(BuildContext context) async {
    await AuthService().signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 12, 255, 1),
      appBar: AppBar(
        title: const Text(
          '¡BIENVENIDO!',
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(0, 12, 255, 1),
        elevation: 0,
        actions: [
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.exit_to_app),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Contenedor para Logo y Tarjetas (con animación)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            top: _panelPosition == 0.25
                ? 0
                : -60, // Ajusta la posición del texto
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'lib/assets/images/logoblanco.png',
                  width: _panelPosition == 0.25 ? 300 : 300, // Logo más grande
                ),
                const Text(
                  'Sistema de membresías',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: -1,
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_panelPosition ==
                    0.10) // Solo muestra tarjetas si el panel está abajo
                  Image.asset(
                    'lib/assets/images/tarjetas.png',
                    width: 500,
                  ),
              ],
            ),
          ),

          // Panel Deslizable
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              setState(() {
                _panelPosition = notification.extent;
              });
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.10,
              maxChildSize: 0.65,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Container(
                          width: 40,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          '¿Qué deseas realizar?',
                          style: TextStyle(
                              color: Colors.orange,
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20), // Agrega margen a los lados
                          child: Column(
                            children: [
                              _buildMenuButton(
                                  context,
                                  'Generar QR',
                                  'lib/assets/images/logoblanco.png',
                                  'lib/assets/icons/icon_qr.png',
                                  '/generateQr'),
                              _buildMenuButton(
                                  context,
                                  'Agregar Membresía',
                                  'lib/assets/images/logoblanco.png',
                                  'lib/assets/icons/icon_add.png',
                                  '/addMembership'),
                              _buildMenuButton(
                                  context,
                                  'Escanear QR',
                                  'lib/assets/images/logoblanco.png',
                                  'lib/assets/icons/icon_scan.png',
                                  '/qrScanner'),
                              _buildMenuButton(
                                  context,
                                  'Gestión de Miembros',
                                  'lib/assets/images/logoblanco.png',
                                  'lib/assets/icons/icon_members.png',
                                  '/manageMembers'),
                              _buildMenuButton(
                                  context,
                                  'Gestión de Negocios',
                                  'lib/assets/images/logoblanco.png',
                                  'lib/assets/icons/icon_members.png',
                                  '/manageBusinesses'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Botón reutilizable
  Widget _buildMenuButton(BuildContext context, String title, String logoPath,
      String iconPath, String route) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        onPressed: () => Navigator.pushNamed(context, route),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(0, 12, 255, 1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Distribuye mejor los elementos
          children: [
            Image.asset(logoPath,
                width: 40), // Logo más pequeño para equilibrar diseño
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center, // Centra el texto dentro del botón
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(iconPath, width: 40),
          ],
        ),
      ),
    );
  }
}
