import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gazrapide/widgets/drawer.dart';
import 'package:gazrapide/widgets/dialogs.dart';
import 'package:universe/universe.dart';
import '../general_variables.dart';
import '../models.dart';
import '../services/firebase/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Shop> shopsList = [];

  List<Marker> markers = [];

  Shop? userShop; // Variable pour stocker le shop de l'utilisateur

  @override
  void initState() {
    super.initState();
    getShopsStream().listen((updatedShops) {
      setState(() {
        shopsList = updatedShops;

        ///Récupération du point de vente de l'utilisateur connecté
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        final anonymous = FirebaseAuth.instance.currentUser?.isAnonymous;
        if (anonymous == false) {
          if (currentUserId != null) {
            userShop = updatedShops.firstWhere(
              (shop) => shop.ownerid == currentUserId,
              orElse: () {
                // Si aucun Shop n'est trouvé, créer un nouveau Shop
                Shop newShop = Shop(
                  id: '', // L'ID sera généré par Firestore
                  name: 'Nouveau point de vente',
                  phonenumbers: [],
                  availablebrands: [],
                  latitude: 0.0, // Valeurs par défaut à modifier après création
                  longitude: 0.0,
                  ownerid: currentUserId, // Assignation de l'ownerId
                );
                // Ajouter ce nouveau shop à Firestore
                createShopOnFirestore(newShop);

                shopsList.add(newShop);

                return newShop; // Retourne ce shop temporairement en local
              },
            );
          }
        }
        print(
          "🔍 Shop de l'utilisateur: ${userShop?.name ?? 'Aucun'}: ${userShop?.phonenumbers ?? 'Aucun'}: ${userShop?.ownerid ?? 'Aucun'} \n Nombre de point de vente: ${shopsList.length} ",
        );

        /// Générer les markers
        markers =
            shopsList.map((shop) {
              return Marker(
                LatLng(shop.latitude, shop.longitude),
                data: shop,
                widget: MarkerIcon(
                  icon: Icons.location_on,
                  color: Colors.red[900],
                ),
              );
            }).toList();
      });
    });
  }

  ///Requête des points de vente depuis firestore
  Stream<List<Shop>> getShopsStream() {
    final CollectionReference shops0 = FirebaseFirestore.instance.collection(
      "sellingpoint",
    );
    return shops0.snapshots().map((snapshot) {
      List<Shop> shops =
          snapshot.docs
              .map((doc) {
                try {
                  Shop shop = Shop.fromFirestore(doc);
                  print(
                    "✅ Shop chargé: ${shop.name}, 📞 Téléphones: ${shop.phonenumbers}, 🏷️ Marques: ${shop.availablebrands}, 🏷️ Propriétaire: ${shop.ownerid}",
                  );
                  return shop;
                } catch (e) {
                  return null; // On retourne null pour gérer l'erreur
                }
              })
              .whereType<Shop>()
              .toList(); // Filtre les valeurs null pour éviter un crash
      return shops;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white, size: 30),
        backgroundColor: Colors.red[900],
        centerTitle: true,
        title: Text(
          "Map",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: U.GoogleMap(
          center: (userPosition != null) ? userPosition : LatLng(12.35, -1.53),
          type: GoogleMapType.Street,
          zoom: 12,
          live: true,
          moveWhenLive: false,
          showLocator: true,
          markers: U.MarkerLayer(
            markers,
            onTap: (latlng, data) {
              print("Marker cliqué : ${data.name}");
              CustomDialogs.showShopDetails(context, data);
            },
          ),
        ),
      ),
      drawer: MainDrawer(),
      bottomNavigationBar:
          !auth.currentUser!.isAnonymous
              ? BottomAppBar(
                color: Colors.white,
                shape: const CircularNotchedRectangle(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        onPressed: () {
                          CustomDialogs.showEditShopBottomSheet(
                            context,
                            userShop!,
                          );
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.shop),
                            SizedBox(width: 10),
                            Text(
                              "Mes informations",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          CustomDialogs.editStockBottomSheet(
                            context,
                            userShop!,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(FontAwesomeIcons.edit),
                            SizedBox(width: 10),
                            Text(
                              "Gérer mon stock",
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              : null, // On aura pas de BottomBar si l'utilisateur est anonyme
    );
  }
}
