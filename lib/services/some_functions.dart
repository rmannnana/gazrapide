import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home_page.dart';
import '../pages/landing_page.dart';

Future<void> toHomePage({
  required BuildContext context,
  required VoidCallback updateStateCallback,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Vous êtes connecté(e)")),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => HomePage()),
  );

  // Mettez à jour l'état via callback
  updateStateCallback();

  // Persiste la valeur
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', true);
}

Future<void> toLandingPage({
  required BuildContext context,
  required VoidCallback updateStateCallback,
}) async {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Vous êtes déconnecté(e)")),
  );
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LandingPage()),
  );

  updateStateCallback();

  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLogged', false);
}
