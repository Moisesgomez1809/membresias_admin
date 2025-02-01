import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:membresias_admin/screens/login_screen.dart';
import 'package:membresias_admin/services/auth_service.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScannerScreen extends StatefulWidget {
  @override
  _QRScannerScreenState createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  String membershipStatus = ''; // Estado de la membresía
  String clientName = ''; // Nombre del cliente
  bool? isActiveMembership; // Estado activo/inactivo

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _logout(BuildContext context) async {
    try {
      await AuthService()
          .signOut(); // Llamamos al método de signOut del servicio de autenticación
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (Route<dynamic> route) => false, // Elimina todas las pantallas previas
      );
    } catch (e) {
      print("Error al cerrar sesión: $e");
    }
  }

  void _onQRScanned(String qrCode) async {
    print('Código QR escaneado: $qrCode');

    // Accede al nodo de membresías en Firebase
    DatabaseReference membershipRef =
        FirebaseDatabase.instance.ref('memberships/$qrCode');
    DataSnapshot snapshot = await membershipRef.get();

    if (snapshot.exists) {
      var membershipData = snapshot.value as Map<dynamic, dynamic>;
      bool isActive = membershipData['isActive'];
      String name = membershipData['name'] ?? 'Nombre no disponible';

      setState(() {
        membershipStatus = isActive ? 'Membresía activa' : 'Membresía inactiva';
        clientName = name;
        isActiveMembership = isActive; // Guarda el estado de la membresía
      });
    } else {
      setState(() {
        membershipStatus = 'Membresía no encontrada';
        clientName = '';
        isActiveMembership = null; // No hay información
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (QRViewController controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                  if (scanData.code != null) {
                    _onQRScanned(scanData.code!);
                  }
                });
              },
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 300,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _getMembershipColor(), // Color dinámico
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      membershipStatus.isNotEmpty
                          ? membershipStatus
                          : 'Escanea un QR para verificar la membresía',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    if (clientName
                        .isNotEmpty) // Mostrar el nombre solo si está disponible
                      Text(
                        'Nombre: $clientName',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Función para determinar el color dinámico
  Color _getMembershipColor() {
    if (isActiveMembership == null) {
      return Colors.grey; // Por defecto, gris si no hay datos
    } else if (isActiveMembership == true) {
      return Colors.orange; // Naranja si está activa
    } else {
      return Colors.grey; // Gris si está inactiva
    }
  }
}
