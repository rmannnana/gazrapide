import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gazrapide/general_variables.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:universe/universe.dart';

import '../services/firebase/firebase_auth.dart';
import 'home_page.dart';
import 'otp_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? user = FirebaseAuth.instance.currentUser;

  bool isLoading = false;

  /// Variables et controlleurs de l'authentification par téléphone
  final TextEditingController _phoneController = TextEditingController();

  /// Numéro complet (avec l'indicatif du pays). Cette variable est mise à jour
  /// à chaque changement dans le champ de numéro de téléphone.
  String fullPhoneNumber = "";

  @override
  void dispose() {
    /// Libération des ressources des controlleurs
    _phoneController.dispose();
    super.dispose();
  }

  /// Méthode d'authentification via Google
  Future<void> handleGoogleSignIn(BuildContext context) async {
    if (FirebaseAuth.instance.currentUser?.isAnonymous ?? false) {
      await FirebaseAuth.instance.signOut();
    }

    final userCredential = await Auth().signinWithGoogle();

    if (userCredential == null) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion Google annulée ou échouée')),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
  }

  ///Authentification par numero de téléphone. Cette méthode utilise Firebase
  ///pour envoyer un code OTP au numéro de téléphone fourni, et affiche la page de saisie du code.
  ///Elle est appelée lorsque l'utilisateur appuie sur le bouton "Continuer"
  ///après avoir entré son numéro de téléphone.
  void sendCode() async {
    if (isLoading) return;
    if (fullPhoneNumber.isNotEmpty) {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() => isLoading = false);
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Erreur : ${e.message}")));
          setState(() => isLoading = false);
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Un code vous a été envoyé par SMS.")),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => OtpPage(
                    verificationId: verificationId,
                    onSubmitOTP: (otp) async {
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: otp,
                          );
                      // await FirebaseAuth.instance.signOut();
                      await FirebaseAuth.instance.signInWithCredential(
                        credential,
                      );
                      setState(() => isLoading = false);
                      // Le StreamBuilder gère la redirection
                    },
                  ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un numéro valide.")),
      );
      setState(() => isLoading = false);
    }
  }

  /// Fin des méthodes d'authentification

  /// Obtention de la position de l'utilisateur
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!mounted) return; // ✅ manquait ici
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez activer la localisation.")),
      );
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Permission refusée")));
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    if (!mounted) return;
    setState(() {
      userPosition = LatLng(position.latitude, position.longitude);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Position récupérée : $userPosition')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white, size: 30),
            backgroundColor: Colors.red[900],
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back),
            ),
            title: Text(
              "Gaz Rapide",
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 150,
                bottom: 0,
              ),
              child: Column(
                children: [
                  /// Bouton d'authentification avec Google
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    onPressed: () async {
                      await handleGoogleSignIn(context);
                      await _getUserLocation();
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.google,
                        ), // Logo depuis font_awesome
                        SizedBox(width: 10),
                        Text(
                          "Continuer avec Google",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),
                  Text(
                    "ou",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  SizedBox(height: 24),

                  // Champ numéro de téléphone avec indicatif du pays
                  IntlPhoneField(
                    controller: _phoneController,
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
                        fullPhoneNumber =
                            phone
                                .completeNumber; // Récupère le numéro avec indicatif
                      });
                    },
                  ),

                  SizedBox(height: 16),
                  SizedBox(height: 30),

                  /// Bouton d'authentification avec numéro de téléphone
                  /// Ce bouton appelle la méthode sendCode() qui envoi
                  /// un code de vérification et la connexion de l'utilisateur.
                  ElevatedButton(
                    onPressed: sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child:
                        isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              "Continuer",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
