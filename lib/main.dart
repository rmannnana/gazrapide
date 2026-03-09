import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gazrapide/general_variables.dart';
import 'package:gazrapide/pages/home_page.dart';
import 'package:gazrapide/pages/landing_page.dart';
import 'package:gazrapide/pages/loading_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(), // toujours à jour
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Écran de chargement pendant la vérification de l'état de connexion
          return MaterialApp(home: LoadingScreen());
        } else if (snapshot.hasData) {
          // Utilisateur connecté (anonyme ou non)
          return MaterialApp(home: HomePage());
        } else {
          // Aucun utilisateur connecté
          return MaterialApp(home: LandingPage());
        }
      },
    );
  }
}
