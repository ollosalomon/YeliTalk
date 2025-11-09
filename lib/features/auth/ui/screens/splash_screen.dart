// Fichier : lib/features/auth/ui/screens/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:YeliTalk/features/home/ui/screens/home_screen.dart';
import 'package:YeliTalk/features/auth/ui/screens/login_screen.dart';

// F1.2.1: Écran de splash/vérification d'authentification
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthState();
  }

  // Logique pour vérifier si un utilisateur est déjà connecté
  void _checkAuthState() {
    // Écoute les changements d'état d'authentification (connexion/déconnexion)
    // Le listener se déclenche immédiatement à l'ouverture pour vérifier l'état actuel.
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        // Ajout d'un petit délai pour simuler un écran de chargement visuel
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (user == null) {
            // Utilisateur non connecté -> va à l'écran de connexion
            _navigateTo(const LoginScreen());
          } else {
            // Utilisateur connecté -> va à l'écran d'accueil
            _navigateTo(const HomeScreen());
          }
        });
      }
    });
  }

  // Méthode de navigation professionnelle pour remplacer l'écran actuel
  void _navigateTo(Widget screen) {
    // Vérifie si la navigation est possible avant d'appeler pushReplacement
    if (Navigator.of(context).mounted) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => screen));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Affichage simple du logo ou d'un indicateur de chargement
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simuler le chargement du logo YeliTalk
            Image.asset('assets/images/yelitalk_logo_small.png', height: 100),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            Text(
              "Vérification de la session...",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
