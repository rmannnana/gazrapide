import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? verificationId;

  void sendCode() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneController.text,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Auto-sign in si possible
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur : ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          this.verificationId = verificationId;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Connexion par téléphone")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Numéro de téléphone"),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: sendCode,
              child: Text("Envoyer le code"),
            ),
          ],
        ),
      ),
    );
  }
}
