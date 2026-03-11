import 'package:flutter/material.dart';
import 'package:gazrapide/pages/landing_page.dart';

class OtpPage extends StatefulWidget {
  final String verificationId;
  final Function(String) onSubmitOTP;

  const OtpPage({
    super.key,
    required this.verificationId,
    required this.onSubmitOTP,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  /// Variables et controlleurs
  final TextEditingController _otpController = TextEditingController();
  bool isLoading = false;

  /// Méthode de vérification du code OTP
  ///Si le code est correct, l'utilisateur est connecté et redirigé
  ///vers la page d'accueil.
  void verifyOTP() async {
    setState(() => isLoading = true);
    String otp = _otpController.text.trim();

    if (otp.length == 6) {
      try {
        await widget.onSubmitOTP(otp);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Entrer un code reçu par SMS.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un code reçu par SMS.")),
      );
    }
    setState(() => isLoading = false);
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
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
                top: 200,
                bottom: 0,
              ),
              child: Column(
                children: [
                  Text(
                    "Vous allez recevoir un code par SMS,",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Écrivez-le ici",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                  SizedBox(height: 36),
                  TextField(
                    controller: _otpController,
                    decoration: InputDecoration(
                      labelText: "Entrez le code reçu par SMS",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30), // Bord arrondi
                        borderSide: BorderSide(
                          color: Colors.black,
                        ), // Contour noir
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: Text(
                          "Annuler",
                          style: TextStyle(color: Colors.white),
                        ),
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
            ),
          ),
        ),
      ),
    );
  }
}
