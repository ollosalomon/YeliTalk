import 'package:flutter/material.dart';

// Importation mockée vers l'écran suivant pour le prototype
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    // F1.2.1: Simulation de la durée du splash screen (2 secondes)
    Future.delayed(const Duration(seconds: 2), () {
      // NFR1.2.2: S'assurer que le temps de démarrage est rapide

      // Dans l'Étape 1 (mocké), on navigue vers l'écran de Login
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // Utilisation d'un Scaffold simple avec la couleur de fond
    // Le logo (Image.asset) est centré.
    return Scaffold(
      backgroundColor: Colors.white, // Fond blanc comme sur la maquette
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset nécessite que l'image soit dans /assets/images et déclarée dans pubspec.yaml
            Image.asset('assets/images/yelitalk_logo.png', height: 150),
            const SizedBox(height: 16),
            Text(
              'YeliTalk',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: const Color(0xFF007BFF), // Bleu vif du logo de la figure
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
