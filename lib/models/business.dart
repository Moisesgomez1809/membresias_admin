class Business {
  final String id;
  final String name;
  final String location;
  final String contactNumber;
  final String accessEmail;

  Business({
    required this.id,
    required this.name,
    required this.location,
    required this.contactNumber,
    required this.accessEmail,
  });

  // Método para convertir un mapa de Firebase Realtime Database en un objeto Business
  factory Business.fromMap(Map<dynamic, dynamic> map) {
    return Business(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      location: map['location'] as String? ?? '',
      contactNumber: map['contactNumber'] as String? ?? '',
      accessEmail: map['accessEmail'] as String? ?? '',
    );
  }

  // Método para convertir un objeto Business en un mapa para Firebase Realtime Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'contactNumber': contactNumber,
      'accessEmail': accessEmail,
    };
  }
}
