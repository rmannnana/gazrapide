import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gazrapide/general_variables.dart';
import 'package:gazrapide/pages/home_page.dart';
import 'package:gazrapide/pages/landing_page.dart';

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
      // Désigne la page à afficher selon l'état de l'authentification
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        print("STREAM EVENT");
        print("snapshot.hasData = ${snapshot.hasData}");
        print("uid = ${snapshot.data?.uid}");
        print("isAnonymous = ${snapshot.data?.isAnonymous}");

        if (snapshot.hasData) {
          return MaterialApp(home: HomePage());
        } else {
          return MaterialApp(home: LandingPage());
        }
      },
    );
  }
}
