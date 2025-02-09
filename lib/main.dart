import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:membresias_admin/SplashScreen.dart';
import 'package:membresias_admin/screens/add_membership_screen.dart';
import 'package:membresias_admin/screens/generate_qr_screen.dart';
import 'package:membresias_admin/screens/home_screen.dart';
import 'package:membresias_admin/screens/login_screen.dart';
import 'package:membresias_admin/screens/manage_business_screen.dart';
import 'package:membresias_admin/screens/manage_members_screen.dart';
import 'package:membresias_admin/screens/qr_scanner_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Inicializa Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Membresías',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Pantalla inicial
      routes: {
        '/': (context) => SplashScreen(), // Pantalla de inicio (LoginScreen)
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/manageBusinesses': (context) => ManageBusinessScreen(),
        '/manageMembers': (context) => ManageMembersScreen(),
        '/qrScanner': (context) => QRScannerScreen(),
        '/generateQr': (context) => GenerateQRScreen(),
        '/addMembership': (context) => AddMembershipScreen(),
// Nueva pantalla para Admin (generación de QR)
      },
    );
  }
}
