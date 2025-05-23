import 'package:flutter/material.dart';
import 'package:gazrapide/pages/auth_page.dart';
import 'package:gazrapide/pages/home_page.dart';
import 'package:gazrapide/pages/politique.dart';

import '../services/firebase/firebase_auth.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  /// Connexion Anonyme
  Future<void> handleAnonymousSignIn(BuildContext context) async {
    await Auth().signinAnonymously();

    // Redirection après connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Image(
                  image: AssetImage('assets/img/logo.png'),
                  height: 200,
                  width: 200,
                ),
                Text(
                  "Gaz Rapide",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Trouvez du Gaz Rapidement",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              width: 300,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => handleAnonymousSignIn(context),
                      child: Text("Je cherche un point de vente"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigation vers AuthPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthPage()),
                        );
                      },
                      child: Text("Je vend le Gaz"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[900],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Politique()),
                      );
                    },
                    child: Text(
                      "Politique d'utilisation",
                      style: TextStyle(
                        color: Colors.red[900],
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
------- Design de ElevetadeButton --------
ElevatedButton(
  onPressed: () {
    print("Bouton pressé !");
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Couleur du bouton
    foregroundColor: Colors.white, // Couleur du texte
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // Padding interne
    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Style du texte
    shape: RoundedRectangleBorder( // Bordures arrondies
      borderRadius: BorderRadius.circular(20),
    ),
    elevation: 5, // Ombre sous le bouton
  ),
  child: Text("Cliquer"),
)

 */
