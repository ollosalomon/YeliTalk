// Fichier : lib/features/auth/ui/screens/signup_screen.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:YeliTalk/features/auth/auth_service.dart';
// Importation de l'écran de connexion pour la redirection post-inscription
import 'package:YeliTalk/features/auth/ui/screens/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // 💡 NOUVEAU CONTRÔLEUR : Confirmation du mot de passe
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Ne pas oublier de disposer
    super.dispose();
  }

  // F2.1.1: Logique d'inscription mise à jour
  Future<void> _signup(BuildContext context) async {
    // 1. Validation du formulaire (incluant la confirmation du mot de passe)
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // 2. Vérification supplémentaire : les mots de passe correspondent-ils ?
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        _errorMessage = 'Les mots de passe ne correspondent pas.';
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Tente de créer l'utilisateur
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 💡 CORRECTION: Déconnecter l'utilisateur immédiatement après la création.
      // Firebase le connecte automatiquement lors de createUserWithEmailAndPassword.
      await FirebaseAuth.instance.signOut();

      // 3. Succès : Afficher un message de succès et naviguer vers Login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Compte créé avec succès. Veuillez vous connecter.'),
            backgroundColor: Colors.green,
          ),
        );
        // Rediriger vers LoginScreen sans possibilité de retour à l'inscription
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      // 💡 GESTION PROFESSIONNELLE DES ERREURS
      if (e.code == 'weak-password') {
        message = 'Le mot de passe doit comporter au moins 6 caractères.';
      } else if (e.code == 'email-already-in-use') {
        message = 'Cet email est déjà utilisé par un autre compte.';
      } else if (e.code == 'invalid-email') {
        message = 'L\'adresse email est mal formatée.';
      } else {
        message = 'Erreur d\'inscription. Veuillez réessayer.';
      }

      setState(() {
        _errorMessage = message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Une erreur inattendue est survenue.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ... (Méthodes _navigateToLogin et autres restent inchangées) ...

  void _navigateToLogin() {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // ... (Titre et logo) ...
              Image.asset('assets/images/yelitalk_logo_small.png', height: 80),
              const SizedBox(height: 32),

              Text(
                "S'inscrire",
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // 1. Champ Email avec validation de format
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email.';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Veuillez entrer une adresse email valide.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // 2. Champ Mot de passe
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe.';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit faire au moins 6 caractères.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // 3. 💡 NOUVEAU CHAMP : Confirmation du mot de passe
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez confirmer votre mot de passe.';
                  }
                  // La vérification de la correspondance est faite dans _signup, mais on peut la doubler ici
                  if (value != _passwordController.text) {
                    return 'Les mots de passe ne correspondent pas.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),

              // Affichage de l'erreur
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: theme.colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),

              // Bouton "S'inscrire" principal
              ElevatedButton(
                onPressed: _isLoading ? null : () => _signup(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  backgroundColor: const Color(0xFF007BFF),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Créer un compte',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 30.0),
              const Center(child: Text('—', style: TextStyle(fontSize: 24))),
              const SizedBox(height: 30.0),

              // ... (Boutons Google/Apple - inchangés) ...
              // [Inclure les widgets _buildSocialButton si vous les aviez dans SignupScreen]

              // Lien de connexion
              Center(
                child: TextButton(
                  onPressed: _navigateToLogin,
                  child: const Text(
                    "J'ai déjà un compte (Se connecter)",
                    style: TextStyle(decoration: TextDecoration.underline),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          ),
        ),
      ),
    );
  }

  // NOTE : Si vous avez une méthode _buildSocialButton ici, elle doit être incluse.
}
