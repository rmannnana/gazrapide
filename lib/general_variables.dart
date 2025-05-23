import 'package:firebase_auth/firebase_auth.dart';
import 'package:universe/universe.dart';

import 'models.dart';

var auth = FirebaseAuth.instance;

LatLng? userPosition;

// Variable globale pour stocker les shops

Shop pointdevente = Shop(
  id: "giruognfvk",
  name: 'Point de vente par défaut',
  availablebrands: ["Pas de Gaz ici"],
  phonenumbers: ["Pas de numéro de téléphone"],
  latitude: 12.0,
  longitude: -1.1,
  ownerid: '123456789',
);

/*List<Shop> shopsList = [
  Shop(
    name: 'Mr NANA',
    availablebrands: ["Sodigaz 12KG", "Oryx 12KG", "Total 12KG", "Sodigaz 6KG"],
    phonenumbers: ["+22654288212", "+22654288212", "+22654288212"],
    location: [12.35, -1.53],
  ),
  Shop(
    name: 'Tantie Colette',
    availablebrands: ["Sodigaz 12KG", "Oryx 12KG", "Total 12KG", "Sodigaz 6KG"],
    phonenumbers: ["+22654288212", "+22654288212", "+22654288212"],
    location: [14.5, -1.4],
  ),
  Shop(
    name: 'Mr Zida',
    availablebrands: ["Sodigaz 12KG", "Oryx 12KG", "Total 12KG", "Sodigaz 6KG"],
    phonenumbers: ["+22654288212", "+22654288212", "+22654288212"],
    location: [13.7, -2.2],
  ),
  Shop(
    name: 'Mme Sandrine',
    availablebrands: ["Sodigaz 12KG", "Oryx 12KG", "Total 12KG", "Sodigaz 6KG"],
    phonenumbers: ["+22654288212", "+22654288212", "+22654288212"],
    location: [11.6, -2.01],
  ),
  Shop(
    name: 'Mr Sawadogo',
    availablebrands: ["Sodigaz 12KG", "Oryx 12KG", "Total 12KG", "Sodigaz 6KG"],
    phonenumbers: ["+22654288212", "+22654288212", "+22654288212"],
    location: [13.4, -2.3],
  ),
];*/
