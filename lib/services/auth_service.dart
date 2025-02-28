import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Cambié la función para buscar por UID en lugar de email
  Future<String?> getUserRole(String uid) async {
    try {
      // Buscar en Firestore por UID del usuario (ya que es único)
      var userDoc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        return userDoc.data()?[
            'role']; // Asegúrate de que 'role' sea el nombre correcto del campo
      }
      return null; // Si no se encuentra el documento
    } catch (e) {
      print('Error al obtener el rol del usuario: $e');
      return null;
    }
  }

  // Esta función obtiene el usuario actual
  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  // Iniciar sesión
  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Error en el login: $e");
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
