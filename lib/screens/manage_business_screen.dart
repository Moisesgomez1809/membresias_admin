import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/business.dart'; // Modelo de negocio

class ManageBusinessScreen extends StatefulWidget {
  @override
  _ManageBusinessScreenState createState() => _ManageBusinessScreenState();
}

class _ManageBusinessScreenState extends State<ManageBusinessScreen> {
  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();
  List<Business> businesses = [];
  bool isLoading = true; // Para mostrar el cargador

  @override
  void initState() {
    super.initState();
    _fetchBusinesses();
  }

  void _fetchBusinesses() async {
    try {
      final snapshot = await databaseRef.child('business').get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;
        final List<Business> allBusinesses = data.entries.map((entry) {
          final businessData = entry.value as Map<dynamic, dynamic>;
          return Business.fromMap({
            'id': entry.key,
            ...businessData,
          });
        }).toList();

        setState(() {
          businesses = allBusinesses;
          isLoading = false; // Ocultar el cargador
        });
      } else {
        setState(() {
          isLoading = false; // Ocultar el cargador
        });
      }
    } catch (e) {
      print('Error al obtener los negocios: $e');
      setState(() {
        isLoading = false; // Ocultar el cargador
      });
    }
  }

  Future<void> _deleteBusiness(String id) async {
    try {
      await databaseRef.child('business/$id').remove();
      setState(() {
        businesses.removeWhere((business) => business.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Negocio eliminado exitosamente')),
      );
    } catch (e) {
      print('Error al eliminar el negocio: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el negocio: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gestión de Negocios')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : businesses.isEmpty
              ? Center(child: Text('No hay negocios registrados'))
              : ListView.builder(
                  itemCount: businesses.length,
                  itemBuilder: (context, index) {
                    var business = businesses[index];
                    return ListTile(
                      title: Text(business.name),
                      subtitle: Text(
                          'Ubicación: ${business.location}\nNúmero de Contacto: ${business.contactNumber}\nCorreo de Acceso: ${business.accessEmail}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteBusiness(business.id);
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
