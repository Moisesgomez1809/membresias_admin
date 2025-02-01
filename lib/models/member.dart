class Member {
  final String id;
  final String name;
  final String membershipType;
  final String expirationDate;
  final String address;
  final bool isActive;

  Member({
    required this.id,
    required this.name,
    required this.membershipType,
    required this.expirationDate,
    required this.address,
    required this.isActive,
  });

  // Método para convertir un mapa de Firebase Realtime Database en un objeto Member
  factory Member.fromMap(Map<dynamic, dynamic> map) {
    return Member(
      id: map['id'] as String,
      name: map['name'] as String,
      membershipType: map['membershipType'] as String,
      expirationDate: map['expirationDate'] as String,
      address: map['address'] as String,
      isActive: map['isActive'] as bool,
    );
  }

  // Método para convertir un objeto Member en un mapa para Firebase Realtime Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'membershipType': membershipType,
      'expirationDate': expirationDate,
      'address': address,
      'isActive': isActive,
    };
  }
}
