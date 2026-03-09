import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../models.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

String fullPhoneNumber = ""; // Stocke le numéro complet pour inscription
String fullLoginPhoneNumber = ""; // Stocke le numéro complet pour connexion

//Variables et controlleurs de la connexion
final TextEditingController _phoneLoginController = TextEditingController();

String displayPhone(String input) {
  return "${input.substring(0, 4)} ${input.substring(4)}";
}

// Demande permission pour appel téléphonique
void _makePhoneCall(String phoneNumber) async {
  final permissionStatus = await Permission.phone.status;

  if (permissionStatus.isGranted) {
    // Permission déjà accordée, lance l'appel
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    await launchUrl(callUri);
  } else if (permissionStatus.isDenied || permissionStatus.isRestricted) {
    // Demande la permission
    final result = await Permission.phone.request();

    if (result.isGranted) {
      // Si permission accordée après demande, lance l'appel
      final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
      await launchUrl(callUri);
    } else {
      // Permission refusée -> Affiche un message ou autre
      print('Permission refusée');
    }
  } else if (permissionStatus.isPermanentlyDenied) {
    // Permission bloquée définitivement, propose d'aller dans les paramètres
    openAppSettings();
  }
}

////////////////////////////////////////////////////////////////
/*
/// Fenêtre de saisie du code reçu par SMS pour valider l'inscription
class OtpCheckBox extends StatefulWidget {
  final String verificationId;
  final Function(String) onSubmitOTP;

  const OtpCheckBox({
    Key? key,
    required this.verificationId,
    required this.onSubmitOTP,
  }) : super(key: key);

  @override
  State<OtpCheckBox> createState() => _OtpCheckBoxState();
}

class _OtpCheckBoxState extends State<OtpCheckBox> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bord arrondi
      ),
      content: Column(
        mainAxisSize:
            MainAxisSize.min, // Pour éviter que le dialog soit trop grand
        children: [
          Text(
            "Vous avez reçu un code par SMS,",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            "Saisissez-le ici",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          SizedBox(height: 36),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: "Entrez le code reçu par SMS",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bord arrondi
                borderSide: BorderSide(color: Colors.black), // Contour noir
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop;
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Annuler", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  String otp = _otpController.text.trim();
                  widget.onSubmitOTP(otp);
                },
                child: Text("Valider"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}*/

/// Fenêtre de saisie du code reçu par SMS pour valider l'inscription
class OtpCheckBox extends StatefulWidget {
  final String verificationId;
  final Function(String) onSubmitOTP;

  const OtpCheckBox({
    super.key,
    required this.verificationId,
    required this.onSubmitOTP,
  });

  @override
  State<OtpCheckBox> createState() => _OtpCheckBoxState();
}

class _OtpCheckBoxState extends State<OtpCheckBox> {
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  void verifyOTP() async {
    setState(() => isLoading = true);

    String otp = _otpController.text.trim();

    if (otp.length == 6) {
      try {
        await widget.onSubmitOTP(otp);
        Navigator.pop(context); // Ferme la boîte de dialogue après succès
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Erreur : Code OTP invalide.")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un code OTP valide.")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bord arrondi
      ),
      content: Column(
        mainAxisSize:
            MainAxisSize.min, // Pour éviter que le dialog soit trop grand
        children: [
          Text(
            "Vous avez reçu un code par SMS,",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            "Saisissez-le ici",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
          ),
          SizedBox(height: 36),
          TextField(
            controller: _otpController,
            decoration: InputDecoration(
              labelText: "Entrez le code reçu par SMS",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30), // Bord arrondi
                borderSide: BorderSide(color: Colors.black), // Contour noir
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Annuler", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: isLoading ? null : verifyOTP,
                child:
                    isLoading
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text("Valider"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

///////////////////////////////////////////////////////////////////////////
// Fenêtre de saisie du numéro de téléphone pour récupérer le mot de passe
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Bord arrondi
      ),
      content: Column(
        mainAxisSize:
            MainAxisSize.min, // Pour éviter que le dialog soit trop grand
        children: [
          Text(
            "Quel est votre numéro de téléphone ?",
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 36),
          IntlPhoneField(
            controller: _phoneLoginController,
            decoration: InputDecoration(
              labelText: "Entrez votre numéro de téléphone",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            initialCountryCode: 'BF', // Par défaut, Burkina Faso
            onChanged: (phone) {
              setState(() {
                fullLoginPhoneNumber =
                    phone.completeNumber; // Récupère le numéro avec indicatif
              });
            },
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme le dialog
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text("Annuler", style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop;
                },
                child: Text("Valider"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Fonction pour mettre à jour les informations d'un point sur Firestore
Future<void> updateShopOnFirestore(Shop shop) async {
  try {
    final shopRef = FirebaseFirestore.instance
        .collection("sellingpoint")
        .doc(shop.id);

    // Assurer que phoneNumbers est bien une liste de chaînes de caractères
    List<String> validPhoneNumbers =
        shop.phonenumbers
            .where((phone) => phone.isNotEmpty) // Filtrer les numéros vides
            .toList();

    /*
    print('_____________________${shop.phonenumbers}');
    print('_________________________${validPhoneNumbers}');
    */
    // Mise à jour des informations du shop
    await shopRef.update({
      'name': shop.name,

      'phonenumbers': validPhoneNumbers,
      'location': GeoPoint(
        shop.latitude,
        shop.longitude,
      ), // Mise à jour de la localisation
      // Ajoutez ici d'autres champs à mettre à jour si nécessaire
    });

    print("✅ Shop mis à jour avec succès sur Firestore");
  } catch (e) {
    print("❌ Erreur lors de la mise à jour du Shop sur Firestore: $e");
  }
}

/// Fonction pour mettre à jour le stock d'un point sur Firestore
Future<void> updateShopStoreFirestore(Shop shop) async {
  try {
    final shopRef = FirebaseFirestore.instance
        .collection("sellingpoint")
        .doc(shop.id);

    await shopRef.update({'availablebrands': shop.availablebrands});

    print("✅ Stock mis à jour avec succès sur Firestore");
  } catch (e) {
    print("❌ Erreur lors de la mise à jour du stock: $e");
  }
}

class CustomDialogs {
  // BottomSheet pour voir les détails d'un point de vente
  static void showShopDetails(BuildContext context, Shop selectedShop) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedShop.name,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Text(
                        "Gaz disponibles",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedShop.availablebrands.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const FaIcon(FontAwesomeIcons.circleDot),
                        title: Text(
                          selectedShop.availablebrands[index],
                          style: TextStyle(fontWeight: FontWeight.w800),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                "Contacter le point de vente",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                children:
                    selectedShop.phonenumbers.map((number) {
                      return ElevatedButton.icon(
                        onPressed: () => _makePhoneCall(number),
                        icon: const Icon(Icons.phone),
                        label: Text(
                          displayPhone(number),
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900],
                          foregroundColor: Colors.white,
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Ferme la BottomSheet
                },
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      },
    );
  }

  // BottoSheet de mise à jour des infos d'un point de vente
  static void showEditShopBottomSheet(BuildContext context, Shop shop) {
    TextEditingController nameController = TextEditingController(
      text: shop.name,
    );

    // Initialisation des numéros de téléphone
    List<String> phonenumbers = List.generate(
      3,
      (index) =>
          shop.phonenumbers.length > index ? shop.phonenumbers[index] : '',
    );

    // Initialisation de la localisation avec les coordonnées du shop
    ValueNotifier<List<double>> locationNotifier = ValueNotifier([
      shop.latitude,
      shop.longitude,
    ]);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Champ Nom
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nom du point de vente',
                        ),
                      ),
                      SizedBox(height: 16),

                      // Bouton de récupération de la position actuelle de l'utilisateur
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder<List<double>>(
                            valueListenable: locationNotifier,
                            builder: (context, loc, child) {
                              return Text(
                                loc.isNotEmpty
                                    ? '( ${loc[0].toStringAsFixed(4)}_${loc[1].toStringAsFixed(4)} )'
                                    : 'Position non définie',
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              bool serviceEnabled =
                                  await Geolocator.isLocationServiceEnabled();
                              if (!serviceEnabled) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Activez le service de localisation',
                                    ),
                                  ),
                                );
                                return;
                              }

                              LocationPermission permission =
                                  await Geolocator.checkPermission();
                              if (permission == LocationPermission.denied) {
                                permission =
                                    await Geolocator.requestPermission();
                                if (permission == LocationPermission.denied) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Permission refusée'),
                                    ),
                                  );
                                  return;
                                }
                              }

                              if (permission ==
                                  LocationPermission.deniedForever) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Permission définitivement refusée',
                                    ),
                                  ),
                                );
                                return;
                              }

                              Position position =
                                  await Geolocator.getCurrentPosition(
                                    desiredAccuracy: LocationAccuracy.high,
                                  );

                              locationNotifier.value = [
                                position.latitude,
                                position.longitude,
                              ];
                            },
                            child: Text('Enregistrer votre position actuelle.'),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),

                      // Champs Téléphone avec IntlPhoneField
                      Column(
                        children: List.generate(3, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: IntlPhoneField(
                              initialValue: phonenumbers[index],
                              decoration: InputDecoration(
                                labelText: 'Téléphone ${index + 1}',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              initialCountryCode: 'BF',
                              onChanged: (phone) {
                                setState(() {
                                  phonenumbers[index] = phone.completeNumber;
                                });
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 16),

                      // Boutons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Annuler'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Mettre à jour les données du shop localement
                              shop.name = nameController.text;
                              shop.phonenumbers = phonenumbers;

                              // Mettre à jour les coordonnées du shop avec la nouvelle localisation
                              shop.latitude = locationNotifier.value[0];
                              shop.longitude = locationNotifier.value[1];
                              // Mettre à jour Firestore
                              await updateShopOnFirestore(shop);

                              // Fermer la bottomSheet
                              Navigator.pop(context, shop);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900],
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Valider'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  // BottomSheet de mise à jour du stock d'un point de vente
  static void editStockBottomSheet(BuildContext context, Shop shop) {
    /// Liste complète des marques disponibles
    List<String> allBrands = [
      "Sodigaz 12kg",
      "Oryx 6kg",
      "Total 12kg",
      "Oryx 12kg",
      "Sodigaz 6kg",
      "Total 6kg",
    ];

    /// Liste des marques sélectionnées (initialisée avec les marques déjà présentes dans `shop`)
    List<String> selectedBrands = List.from(shop.availablebrands);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Sélectionnez les marques disponibles",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      // Affichage des cases à cocher pour les marques
                      Column(
                        children:
                            allBrands.map((brand) {
                              return CheckboxListTile(
                                title: Text(brand),
                                value: selectedBrands.contains(brand),
                                onChanged: (bool? value) {
                                  setState(() {
                                    if (value == true) {
                                      selectedBrands.add(brand);
                                    } else {
                                      selectedBrands.remove(brand);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                      ),

                      SizedBox(height: 16),

                      // Boutons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Annuler'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Mettre le stock à jour localement
                              shop.availablebrands = selectedBrands;

                              // Mettre à jour sur Firestore
                              await updateShopStoreFirestore(shop);

                              // Fermer la bottomSheet
                              Navigator.pop(context, shop);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[900],
                              foregroundColor: Colors.white,
                            ),
                            child: Text('Valider'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
