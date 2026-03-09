import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gazrapide/pages/home_page.dart';
import 'package:gazrapide/pages/landing_page.dart';
import 'package:gazrapide/pages/politique.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  /// Fonction de déconexion
  Future<void> handleLogout(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Vérifie tous les providers
        for (final providerProfile in user.providerData) {
          if (providerProfile.providerId == 'google.com') {
            await GoogleSignIn().signOut();
          }
        }

        // Déconnexion Firebase (ça couvre toutes les méthodes, même anonyme & phone)
        await FirebaseAuth.instance.signOut();
      }

      // Redirection vers la page Auth
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LandingPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la déconnexion')),
        );
      }
    }
  }

  ///Fonction vers la page Facebook
  final Uri toLaunch = Uri(
    scheme: 'https',
    host: 'wa.me',
    path: '/22654288212',
  );
  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.red[900]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Gaz Rapide",
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Gaz Rapide vous permet de trouver du gaz rapidement et à proximité de votre position.",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                //Bouton Accueil
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Ferme le dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.house, // Icône Google
                              color: Colors.red[900],
                            ),
                          ),
                        ), // Logo depuis font_awesome
                        SizedBox(width: 10),
                        Text(
                          "Accueil",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Bouton Déconnexion
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      handleLogout(context);
                    },
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.powerOff, // Icône Google
                              color: Colors.red[900],
                            ),
                          ),
                        ), // Logo depuis font_awesome
                        SizedBox(width: 10),
                        Text(
                          "Déconnexion",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Bouton Contact
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _launchInBrowser(toLaunch),
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.message, // Icône Google
                              color: Colors.red[900],
                            ),
                          ),
                        ), // Logo depuis font_awesome
                        SizedBox(width: 10),
                        Text(
                          "Contactez-nous",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //Bouton Politique d'utilisation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Politique()),
                      );
                    },
                    style: ElevatedButton.styleFrom(),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                          child: Center(
                            child: FaIcon(
                              FontAwesomeIcons.info, // Icône Google
                              color: Colors.red[900],
                            ),
                          ),
                        ), // Logo depuis font_awesome
                        SizedBox(width: 10),
                        Text(
                          "Politique d'utilisation",
                          style: TextStyle(
                            color: Colors.red[900],
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
