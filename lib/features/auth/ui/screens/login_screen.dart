import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Importation du nouveau service
import 'package:YeliTalk/features/auth/auth_service.dart';

import 'package:YeliTalk/features/home/ui/screens/home_screen.dart';
import 'package:YeliTalk/features/auth/ui/screens/signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService(); // Instance du service
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;
  bool _isLoading = false;
  bool _isLoadingGoogle = false; // Nouvel état pour le bouton Google
  bool _rememberMe = false;

  // ... (Méthodes _login, _navigateToSignup, et dispose restent inchangées) ...

  Future<void> _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Si le code atteint ici, c'est réussi
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      // 💡 GESTION PROFESSIONNELLE DES ERREURS
      // On masque la distinction entre email inexistant et mauvais mot de passe
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') {
        message = 'Identifiants invalides : Email ou mot de passe incorrect.';
      } else if (e.code == 'too-many-requests') {
        message = 'Trop de tentatives. Veuillez réessayer plus tard.';
      } else if (e.code == 'network-request-failed') {
        message = 'Problème de connexion réseau. Vérifiez votre Internet.';
      } else {
        // Pour les autres erreurs inattendues, on donne un message générique
        message = 'Erreur de connexion : Veuillez vérifier vos identifiants.';
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

  // F2.1.4: Logique de connexion Google implémentée
  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoadingGoogle = true;
      _errorMessage = null;
    });

    try {
      final User? user = await _authService.signInWithGoogle();

      if (user != null && mounted) {
        // Succès : Naviguer vers l'écran principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else if (user == null) {
        // L'utilisateur a annulé la connexion, pas une erreur, on n'affiche rien.
        debugPrint('Connexion Google annulée par l\'utilisateur.');
      }
    } on Exception catch (e) {
      // Afficher l'erreur retournée par le AuthService
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      setState(() {
        _isLoadingGoogle = false;
      });
    }
  }

  void _navigateToSignup() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const SignupScreen()));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              Image.asset('assets/images/yelitalk_logo_small.png', height: 80),
              const SizedBox(height: 32),

              Text(
                'Se connecter',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // ... (Formulaire Email/Mdp) ...
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre email.';
                  }
                  // Expression régulière simple pour valider le format de l'email
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value)) {
                    return 'Veuillez entrer une adresse email valide.';
                  }
                  return null;
                },
              ),
              // ...
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Mot de passe'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre mot de passe.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                  const Text('Se souvenir de moi'),
                ],
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

              // Bouton "Se connecter" principal (Email/Mdp)
              ElevatedButton(
                onPressed: _isLoading || _isLoadingGoogle
                    ? null
                    : () => _login(
                        context,
                      ), // Désactivation si Google est en cours
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
                        'Se connecter',
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
              ),

              const SizedBox(height: 30.0),

              const Center(child: Text('—', style: TextStyle(fontSize: 24))),

              const SizedBox(height: 30.0),

              // Bouton Google mis à jour
              _buildSocialButton(
                context,
                'Continuer avec Google',
                'assets/images/google_logo.png',
                _isLoading || _isLoadingGoogle
                    ? () {}
                    : _signInWithGoogle, // Appel à la méthode Firebase
                isLoading: _isLoadingGoogle,
              ),
              const SizedBox(height: 16.0),

              // Bouton Apple
              _buildSocialButton(
                context,
                'Continuer avec Apple',
                'assets/images/apple_logo.png',
                () => debugPrint("Connexion Apple simulée"),
                isLoading: false,
              ),

              const SizedBox(height: 30.0),

              // Lien d'inscription
              Center(
                child: TextButton(
                  onPressed: _navigateToSignup,
                  child: const Text(
                    "S'inscrire",
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

  // Widget utilitaire mis à jour pour supporter le chargement
  Widget _buildSocialButton(
    BuildContext context,
    String text,
    String iconPath,
    VoidCallback onPressed, {
    required bool isLoading,
  }) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
          ? const SizedBox(
              height: 24.0,
              width: 24.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Image.asset(iconPath, height: 24.0),
      label: Text(
        text,
        style: TextStyle(
          fontSize: 16.0,
          color: Theme.of(
            context,
          ).colorScheme.onBackground.withOpacity(isLoading ? 0.5 : 1.0),
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
