import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/business.dart'; // Modelo de negocio
import '../models/member.dart'; // Modelo de negocio

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Agregar un nuevo negocio a Firestore
  Future<void> addBusiness(Business business) async {
    try {
      await _db.collection('businesses').doc(business.id).set(business.toMap());
      print('Negocio agregado correctamente');
    } catch (e) {
      print('Error al agregar negocio: $e');
    }
  }

  // Obtener todos los negocios desde Firestore
  Future<List<Business>> getBusinesses() async {
    try {
      final snapshot = await _db.collection('businesses').get();
      return snapshot.docs.map((doc) => Business.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error al obtener negocios: $e');
      return [];
    }
  }

  // Obtener un negocio específico por ID
  Future<Business?> getBusinessById(String id) async {
    try {
      final doc = await _db.collection('businesses').doc(id).get();
      if (doc.exists) {
        return Business.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error al obtener el negocio: $e');
      return null;
    }
  }

  // Agregar un nuevo miembro a Firestore
  Future<void> addMember(Member member) async {
    try {
      await _db.collection('members').doc(member.id).set(member.toMap());
      print('Miembro agregado correctamente');
    } catch (e) {
      print('Error al agregar miembro: $e');
    }
  }

  // Obtener todos los miembros desde Firestore
  Future<List<Member>> getMembers() async {
    try {
      final snapshot = await _db.collection('members').get();
      return snapshot.docs.map((doc) => Member.fromMap(doc.data())).toList();
    } catch (e) {
      print('Error al obtener miembros: $e');
      return [];
    }
  }

  // Obtener un miembro específico por ID
  Future<Member?> getMemberById(String id) async {
    try {
      final doc = await _db.collection('members').doc(id).get();
      if (doc.exists) {
        return Member.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error al obtener el miembro: $e');
      return null;
    }
  }
}
