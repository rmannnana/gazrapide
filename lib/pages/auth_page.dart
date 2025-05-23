import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gazrapide/general_variables.dart';
import 'package:gazrapide/pages/home_page.dart';
import 'package:gazrapide/pages/landing_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:universe/universe.dart';
import '../services/firebase/firebase_auth.dart';
import '../widgets/dialogs.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? user = FirebaseAuth.instance.currentUser;

  ///Variables et controlleurs de l'inscription
  //bool _isSigninObscured = true;
  final TextEditingController _phoneSigninController = TextEditingController();
  final TextEditingController _passwordSigninController =
      TextEditingController();

  /// Variables et controlleurs de la connexion
  //bool _isLoginObscured = true;
  final TextEditingController _phoneLoginController = TextEditingController();
  final TextEditingController _passworLoginController = TextEditingController();

  /// Numéros complets (avec l'indicatif du pays) pour inscription
  String fullSigninPhoneNumber = "";
  String fullLoginPhoneNumber = "";

  @override
  void dispose() {
    /// Inscription
    _phoneSigninController.dispose();
    _passwordSigninController.dispose();

    /// Connexion
    _phoneLoginController.dispose();
    _passworLoginController.dispose();
    super.dispose();
  }

  /// Google Auth
  Future<void> handleGoogleSignIn(BuildContext context) async {
    final userCredential = await Auth().signinWithGoogle();
    if (userCredential != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la connexion avec Google')),
      );
    }
  }

  ///Authentification par numero de téléphone
  Future<void> _submitPhoneNumber(BuildContext context) async {
    String phoneNumber = fullSigninPhoneNumber.trim();
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message.toString());
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder:
              (context) => OtpCheckBox(
                verificationId: verificationId,
                onSubmitOTP: (otp) async {
                  try {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: otp,
                        );

                    await FirebaseAuth.instance.signInWithCredential(
                      credential,
                    );

                    // Fermer la boîte de dialogue
                    Navigator.pop(context);

                    // Rediriger ou changer d'état ici (par exemple vers HomePage)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
                  } catch (e) {
                    print("Erreur OTP: $e");
                    // Afficher un message d'erreur si besoin
                  }
                },
              ),
        );
      },

      codeAutoRetrievalTimeout: (String verificationID) {},
    );
  }

  ////////////////////////////////////
  void sendCode() async {
    if (fullSigninPhoneNumber.isNotEmpty) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: fullSigninPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur : ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => OtpCheckBox(
              verificationId: verificationId,
              onSubmitOTP: (otp) async {
                try {
                  PhoneAuthCredential credential =
                  PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otp,
                  );

                  await FirebaseAuth.instance.signInWithCredential(credential);

                  // Fermer la boîte de dialogue
                  Navigator.pop(context);

                  // Rediriger vers la page d'accueil
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } catch (e) {
                  print("Erreur OTP: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Code OTP incorrect ou expiré.")),
                  );
                }
              },
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            ///this.verificationId = verificationId;
            verificationId = verificationId;
          });
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un numéro valide.")),
      );
    }
  }

  ////////////////////////////////////////////////////////
  /// Fin de fonctions d'authentification

  /// Obtention de la position de l'utilisateur
  Future<void> _getUserLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Tu peux afficher un message ou ouvrir les paramètres
      print("Location service désactivé");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        print("Permission refusée");
        return;
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      userPosition = LatLng(position.latitude, position.longitude);
    });

    print('Position récupérée : $userPosition');
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
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
            /*bottom: TabBar(
              labelStyle: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ), // Taille et épaisseur du texte actif
              unselectedLabelStyle: TextStyle(
                fontSize: 16,
              ), // Taille du texte inactif
              labelColor: Colors.black, // Couleur du texte actif
              unselectedLabelColor: Colors.grey, // Couleur du texte inactif
              tabs: [Tab(text: "Inscription"), Tab(text: "Connexion")],
            ),*/
          ),
          body: Center(
            // Onglet d'inscription
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 200,
                bottom: 0,
              ),
              child: Column(
                children: [
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
                    onPressed:
                        () => {handleGoogleSignIn(context), _getUserLocation()},
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
                    controller: _phoneSigninController,
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
                        fullSigninPhoneNumber =
                            phone
                                .completeNumber; // Récupère le numéro avec indicatif
                      });
                    },
                  ),

                  SizedBox(height: 16),

                  /// Champ mot de passe avec icône pour afficher/cacher
                  /*TextField(
                    controller: _passwordSigninController,
                    obscureText: _isSigninObscured,
                    decoration: InputDecoration(
                      labelText: "Mot de passe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isSigninObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _isSigninObscured = !_isSigninObscured;
                          });
                        },
                      ),
                    ),
                  ),*/
                  SizedBox(height: 30),

                  /// Bouton de validation
                  ElevatedButton(
                    onPressed: () {},

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
                    child: Text(
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
          /*TabBarView(
            children: [
              Center(
                // Onglet d'inscription
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 20,
                    bottom: 0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        user != null
                            ? "${user?.displayName}"
                            : 'Utilisateur déconnecté',
                      ),
                      ElevatedButton(
                        onPressed: () => handleGoogleSignIn(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.google, // Icône Google
                              color: Colors.red[900],
                            ), // Logo depuis font_awesome
                            SizedBox(width: 10),
                            Text(
                              "Continuer avec Google",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[900],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                      Text(
                        "ou",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 24),

                      // Champ numéro de téléphone avec indicatif du pays
                      IntlPhoneField(
                        controller: _phoneSigninController,
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
                            fullSigninPhoneNumber =
                                phone
                                    .completeNumber; // Récupère le numéro avec indicatif
                          });
                        },
                      ),

                      SizedBox(height: 16),

                      // Champ mot de passe avec icône pour afficher/cacher
                      TextField(
                        controller: _passwordSigninController,
                        obscureText: _isSigninObscured,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isSigninObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isSigninObscured = !_isSigninObscured;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 30),

                      // Bouton de validation
                      ElevatedButton(
                        onPressed: () {
                          _submitPhoneNumber(context);
                        },

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
                        child: Text(
                          "S'inscrire",
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
              Center(
                // Onglet de connexion
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 40,
                    right: 40,
                    top: 20,
                    bottom: 0,
                  ),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () => handleGoogleSignIn(context),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.google, // Icône Google
                              color: Colors.red[900], // Couleur rouge Google
                            ), // Logo depuis font_awesome
                            SizedBox(width: 10),
                            Text(
                              "Continuer avec Google",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red[900],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 15),
                      Text(
                        "ou",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SizedBox(height: 15),

                      // Champ numéro de téléphone avec indicatif du pays
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
                                phone
                                    .completeNumber; // Récupère le numéro avec indicatif
                          });
                        },
                      ),

                      SizedBox(height: 10),

                      // Champ mot de passe avec icône pour afficher/cacher
                      TextField(
                        controller: _passworLoginController,
                        obscureText: _isLoginObscured,
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Angles arrondis
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isLoginObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isLoginObscured = !_isLoginObscured;
                              });
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 15),

                      // Bouton de validation
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[900], // Couleur rouge
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Angles arrondis
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 16,
                          ),
                        ),
                        child: Text(
                          "Se connecter",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),

                      TextButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => ForgotPassword(),
                          );
                        },
                        child: Text(
                          "Mot de passe oublié ?",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),*/
        ),
      ),
    );
  }
}
