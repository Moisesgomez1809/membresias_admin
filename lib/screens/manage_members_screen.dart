import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/member.dart'; // Modelo de negocio

class ManageMembersScreen extends StatelessWidget {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref();

  Future<List<Member>> _getActiveMembers() async {
    try {
      final snapshot = await _databaseRef
          .child('memberships')
          .orderByChild('isActive')
          .equalTo(true)
          .get();
      if (snapshot.exists) {
        final membersData = snapshot.value as Map<dynamic, dynamic>;
        return membersData.entries.map((entry) {
          final memberData = entry.value as Map<dynamic, dynamic>;
          return Member.fromMap({
            'id': entry.key,
            ...memberData,
          });
        }).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error al obtener los miembros activos: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Miembros Activos')),
      body: FutureBuilder<List<Member>>(
        future: _getActiveMembers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error al cargar miembros: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay miembros activos registrados'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var member = snapshot.data![index];
              return ListTile(
                title: Text(member.name),
                subtitle: Text(
                    'Tipo de Membresía: ${member.membershipType}\nFecha de Expiración: ${member.expirationDate}\nDirección: ${member.address}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    // Lógica para eliminar miembro
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
