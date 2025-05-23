import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models.dart';

Future<void> createShopOnFirestore(Shop shop) async {
  try {
    final docRef = FirebaseFirestore.instance.collection("sellingpoint").doc();

    await docRef.set({
      'name': shop.name,
      'phonenumbers': shop.phonenumbers,
      'availablebrands': shop.availablebrands,
      'location': GeoPoint(shop.latitude, shop.longitude),
      'ownerid': shop.ownerid,
    });

    print("✅ Nouveau Shop créé avec succès sur Firestore !");
  } catch (e) {
    print("❌ Erreur lors de la création du Shop sur Firestore: $e");
  }
}
