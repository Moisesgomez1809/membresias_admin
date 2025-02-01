import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class AddMembershipScreen extends StatefulWidget {
  @override
  _AddMembershipScreenState createState() => _AddMembershipScreenState();
}

class _AddMembershipScreenState extends State<AddMembershipScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final _formKey = GlobalKey<FormState>();
  String? scannedQrCode;
  String? name;
  String? address;
  String? membershipType;
  String? expirationDate;
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  ScaffoldMessengerState? scaffoldMessenger;

  bool isFormVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    scaffoldMessenger = ScaffoldMessenger.of(context);
  }

  @override
  void dispose() {
    scaffoldMessenger = null;
    super.dispose();
  }

  void _scanQrCode() async {
    // Mostrar un diálogo con el escáner QR
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                controller.scannedDataStream.listen((scanData) async {
                  if (scanData.code != null) {
                    controller.dispose();
                    Navigator.pop(context); // Cerrar el escáner

                    // Verificar si el QR ya está activo
                    final preassignedSnapshot = await databaseRef
                        .child('preassignedQRs/${scanData.code}')
                        .get();
                    final membershipsSnapshot = await databaseRef
                        .child('memberships/${scanData.code}')
                        .get();

                    if (membershipsSnapshot.exists) {
                      scaffoldMessenger?.showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Este QR ya está asociado a una membresía activa')),
                      );
                    } else if (preassignedSnapshot.exists) {
                      setState(() {
                        scannedQrCode = scanData.code;
                        isFormVisible = true; // Habilitar el formulario
                      });
                    } else {
                      scaffoldMessenger?.showSnackBar(
                        const SnackBar(
                            content: Text('Este QR no está preasignado')),
                      );
                    }
                  }
                });
              },
            ),
          ),
        );
      },
    );
  }

  void _saveMembership() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Verificar si el QR ya está en uso
      final DatabaseReference ref =
          FirebaseDatabase.instance.ref('preassignedQRs/$scannedQrCode');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        // Agregar datos del cliente a la base de datos
        final DatabaseReference membersRef =
            FirebaseDatabase.instance.ref('memberships/$scannedQrCode');
        await membersRef.set({
          'name': name,
          'address': address,
          'membershipType': membershipType,
          'expirationDate': expirationDate,
          'isActive': true,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Membresía registrada exitosamente')),
        );

        // Reiniciar formulario y estado
        setState(() {
          scannedQrCode = null;
          isFormVisible = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El QR escaneado no es válido')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Membresía')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _scanQrCode,
              child: const Text('Escanear QR'),
            ),
            if (scannedQrCode != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text('QR escaneado: $scannedQrCode'),
              ),
            if (isFormVisible)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nombre'),
                      validator: (value) =>
                          value!.isEmpty ? 'Por favor ingresa un nombre' : null,
                      onSaved: (value) => name = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Domicilio'),
                      validator: (value) => value!.isEmpty
                          ? 'Por favor ingresa un domicilio'
                          : null,
                      onSaved: (value) => address = value,
                    ),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Tipo de Membresía'),
                      validator: (value) => value!.isEmpty
                          ? 'Por favor ingresa un tipo de membresía'
                          : null,
                      onSaved: (value) => membershipType = value,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          labelText: 'Fecha de Vencimiento'),
                      validator: (value) => value!.isEmpty
                          ? 'Por favor ingresa una fecha de vencimiento'
                          : null,
                      onSaved: (value) => expirationDate = value,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveMembership,
                      child: const Text('Registrar Membresía'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
