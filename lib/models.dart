import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final String phone;

  User({required this.name, required this.phone});
}

class Shop {
  String id;
  String name;
  List<String> phonenumbers;
  List<String> availablebrands;
  double latitude;
  double longitude;
  String ownerid;

  Shop({
    required this.id,
    required this.name,
    required this.phonenumbers,
    required this.availablebrands,
    required this.latitude,
    required this.longitude,
    required this.ownerid,
  });

  factory Shop.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    GeoPoint geoPoint = data['location'] ?? GeoPoint(0.0, 0.0);

    return Shop(
      id: doc.id,
      name: data['name'] ?? '',
      phonenumbers: List<String>.from(data['phonenumbers'] ?? []),
      availablebrands: List<String>.from(data['availablebrands'] ?? []),
      latitude: geoPoint.latitude,
      longitude: geoPoint.longitude,
      ownerid: data['ownerid'] ?? '',
    );
  }
}
