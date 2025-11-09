// Fichier : lib/features/auth/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // F2.1.4: Méthode de connexion avec Google
  Future<User?> signInWithGoogle() async {
    try {
      // 1. Déclenche le flux d'authentification
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // L'utilisateur a annulé la connexion
        return null;
      }

      // 2. Obtient les détails d'authentification à partir de la requête
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Crée un nouvel identifiant Firebase à partir de l'identifiant Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Connecte l'utilisateur avec Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Erreur de connexion Firebase: ${e.message}');
    } catch (e) {
      throw Exception('Erreur de connexion Google: $e');
    }
  }

  // Méthode de déconnexion
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
