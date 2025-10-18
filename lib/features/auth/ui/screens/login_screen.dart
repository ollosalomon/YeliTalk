import 'package:flutter/material.dart';
// Importation mockée vers l'écran principal pour le prototype
import 'package:YeliTalk/features/home/ui/screens/home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  // Logique de navigation mockée pour l'Étape 1
  void _mockLogin(BuildContext context) {
    // F1.2.3: La connexion est simulée sans API
    print("Connexion simulée. Naviguation vers l'accueil.");
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  void _mockGoogleLogin() {
    // F1.2.3: Bouton "Continuer avec Google" (mocké)
    print("Connexion Google simulée.");
  }

  void _mockSignup() {
    // F1.2.4: Bouton "S'inscrire" (mocké)
    print("Naviguer vers l'écran d'inscription.");
    // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        // Utilisation de la couleur de fond pour l'AppBar comme sur la maquette
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo de YeliTalk
            Image.asset('assets/images/yelitalk_logo_small.png', height: 80),
            const SizedBox(height: 32),

            // Titre "Se connecter"
            Text(
              'Se connecter',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),

            // Formulaire (F1.2.3)
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Mot de passe'),
            ),
            const SizedBox(height: 8.0),

            // "Se souvenir de moi" (Checkbox)
            Row(
              children: [
                Checkbox(value: false, onChanged: (val) {}),
                const Text('Se souvenir de moi'),
              ],
            ),

            const SizedBox(height: 24.0),

            // Bouton "Se connecter" principal (F1.2.3)
            ElevatedButton(
              onPressed: () => _mockLogin(context),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color(0xFF007BFF), // Bleu du bouton
              ),
              child: const Text(
                'Se connecter',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),

            const SizedBox(height: 30.0),

            // Séparateur
            const Center(child: Text('—', style: TextStyle(fontSize: 24))),

            const SizedBox(height: 30.0),

            // Boutons de connexion OAuth (F1.2.3)
            // Bouton Google
            _buildSocialButton(
              context,
              'Continuer avec Google',
              'assets/images/google_logo.png',
              _mockGoogleLogin,
            ),
            const SizedBox(height: 16.0),
            // Bouton Apple (si nécessaire pour iOS)
            _buildSocialButton(
              context,
              'Continuer avec Apple',
              'assets/images/apple_logo.png',
              () => print("Connexion Apple simulée"),
            ),

            const SizedBox(height: 30.0),

            // Lien d'inscription (F1.2.4)
            Center(
              child: TextButton(
                onPressed: _mockSignup,
                child: const Text(
                  'S\'inscrire',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
            ),
            const SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    String text,
    String iconPath,
    VoidCallback onPressed,
  ) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(iconPath, height: 24.0),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}

// Fichier mocké pour la navigation (à développer plus tard)
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  // F1.3.2: Bottom Navigation à implémenter ici
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Accueil (Marketplace) - Étape 1 Mockée')),
    );
  }
}
