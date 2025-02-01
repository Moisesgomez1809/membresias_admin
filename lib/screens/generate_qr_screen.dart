import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:ui' as ui;

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({Key? key}) : super(key: key);

  @override
  _GenerateQRScreenState createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  List<Map<String, dynamic>> activeQrs = [];
  List<Map<String, dynamic>> inactiveQrs = [];

  @override
  void initState() {
    super.initState();
    _fetchQrs();
  }

  void _fetchQrs() async {
    final preassignedSnapshot = await databaseRef.child('preassignedQRs').get();
    final membershipsSnapshot = await databaseRef.child('memberships').get();

    if (preassignedSnapshot.exists) {
      final preassignedData =
          preassignedSnapshot.value as Map<dynamic, dynamic>;
      final activeMemberships = membershipsSnapshot.exists
          ? (membershipsSnapshot.value as Map<dynamic, dynamic>).keys.toSet()
          : <dynamic>{};

      final List<Map<String, dynamic>> allQrs =
          preassignedData.entries.map((entry) {
        return {
          'id': entry.key as String,
          'isActive': activeMemberships.contains(entry.key),
        };
      }).toList();

      setState(() {
        activeQrs = allQrs.where((qr) => qr['isActive'] == true).toList();
        inactiveQrs = allQrs.where((qr) => qr['isActive'] == false).toList();
      });
    }
  }

  Future<void> _downloadQr(String qrData) async {
    try {
      // Verificar permisos de almacenamiento
      if (Platform.isAndroid) {
        if (!await Permission.storage.request().isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permiso de almacenamiento denegado')),
          );
          return;
        }
      }

      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: false,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
      );

      // Obtener la ruta del almacenamiento externo general
      final directory = await getExternalStorageDirectory();
      final qrDirectory = Directory('${directory!.path}/Qrs');
      if (!await qrDirectory.exists()) {
        await qrDirectory.create(recursive: true);
      }
      final filePath = '${qrDirectory.path}/$qrData.png';
      final file = File(filePath);

      // Generar la imagen del QR
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);
      final size = const Size(300, 300);
      qrPainter.paint(canvas, size);
      final picture = pictureRecorder.endRecording();
      final img =
          await picture.toImage(size.width.toInt(), size.height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception('Error al convertir la imagen a byte data');
      }
      final buffer = byteData.buffer.asUint8List();

      // Guardar la imagen en el archivo
      await file.writeAsBytes(buffer);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('QR guardado en $filePath')),
      );
    } catch (e) {
      print('Error al guardar el QR: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar el QR: $e')),
      );
    }
  }

  Widget _buildQrList(List<Map<String, dynamic>> qrs, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        qrs.isEmpty
            ? const Text('No hay QRs disponibles.')
            : Wrap(
                spacing: 10,
                runSpacing: 10,
                children: qrs.map((qr) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      QrImageView(
                        data: qr['id'],
                        size: 100.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(qr['id']),
                          IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () => _downloadQr(qr['id']),
                          ),
                        ],
                      ),
                    ],
                  );
                }).toList(),
              ),
        const Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Generar Código QR')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQrList(inactiveQrs, 'QRs No Activos'),
              _buildQrList(activeQrs, 'QRs Activos'),
            ],
          ),
        ),
      ),
    );
  }
}
