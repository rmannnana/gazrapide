import 'package:flutter/material.dart';

class Politique extends StatefulWidget {
  const Politique({super.key});

  @override
  State<Politique> createState() => _PolitiqueState();
}

class _PolitiqueState extends State<Politique> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Politique d'utilisation",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text(
                'Dernière mise à jour : 04 Avril 2025',
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              Text(
                'Bienvenue sur Gaz Rapide, une application mobile qui vous permet de localiser et contacter facilement les points de vente de gaz les plus proches de vous.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '1. Objectif de l’application',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Gaz Rapide a pour but de faciliter l\'accès rapide au gaz domestique en connectant les clients avec les vendeurs les plus proches via une carte interactive et des informations de contact à jour.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '2. Collecte et utilisation des données',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nous collectons certaines données personnelles (comme votre localisation, numéro de téléphone) afin d\'assurer le bon fonctionnement de l’application :',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                '• Localisation : utilisée pour afficher les points de vente les plus proches.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '• Identifiant utilisateur : pour permettre la gestion de comptes (connexion, ajout de point de vente...).',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '• Données de contact : pour que les clients puissent appeler directement les vendeurs via l\'application.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                'Ces données ne sont ni vendues, ni partagées à des tiers. Elles sont utilisées uniquement pour améliorer l’expérience utilisateur.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '3. Responsabilités de l’utilisateur',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'En utilisant Gaz Rapide, vous acceptez de :',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                '• Fournir des informations exactes si vous êtes vendeur.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '• Ne pas utiliser l\'application à des fins frauduleuses ou malveillantes.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '• Respecter les autres utilisateurs de la plateforme.',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '• Toute tentative d\'extraction de code source est strictement interdite.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '4. Propriété intellectuelle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Tous les contenus, marques et éléments visuels de Gaz Rapide sont la propriété de leurs détenteurs respectifs. L’application ne peut être copiée ou réutilisée sans autorisation.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '5. Limitation de responsabilité',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nous faisons notre possible pour maintenir les informations à jour, mais nous ne garantissons pas l\'exactitude ou la disponibilité permanente des points de vente. L\'application ne saurait être tenue responsable des erreurs de localisation, d\'indisponibilité ou de défaut de service des vendeurs.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '6. Modifications de la politique',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Nous nous réservons le droit de modifier cette politique à tout moment. Les utilisateurs seront notifiés en cas de changements majeurs.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                '7. Contact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Pour toute question ou réclamation, contactez-nous à : +226 54 28 82 12',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
