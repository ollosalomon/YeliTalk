import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:YeliTalk/core/theme/theme_notifier.dart';
import 'package:YeliTalk/features/profile/ui/screens/about_screen.dart';
// 💡 NOUVEL IMPORT : Votre service d'authentification
import 'package:YeliTalk/features/auth/auth_service.dart';
// NOUVEL IMPORT : Pour rediriger vers l'écran de connexion
import 'package:YeliTalk/features/auth/ui/screens/login_screen.dart';

// CHANGEMENT : Transformé en StatefulWidget pour gérer l'instance AuthService
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Instance du service d'authentification
  final AuthService _authService = AuthService();
  bool _isSigningOut = false;

  // F2.1.5: Déconnexion réelle avec Firebase
  Future<void> _logout() async {
    setState(() {
      _isSigningOut = true;
    });

    try {
      // 1. Appelle la méthode de déconnexion (qui gère Firebase et Google Sign-In)
      await _authService.signOut();

      // 2. Supprime toutes les routes précédentes et navigue vers l'écran de connexion
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (Route<dynamic> route) => false, // Supprime toutes les routes
        );
      }
    } catch (e) {
      // Gérer l'erreur de déconnexion (bien que rare)
      debugPrint('Erreur de déconnexion : $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la déconnexion. Veuillez réessayer.'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final theme = Theme.of(context);

    // Note: Pour afficher le nom et l'email réels, nous aurions besoin d'accéder
    // à `FirebaseAuth.instance.currentUser` ici.

    return Scaffold(
      appBar: AppBar(title: const Text('Profil & Paramètres'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            // F1.6.1: Avatar, Nom, Email
            // ... (Widgets d'information utilisateur inchangés) ...
            const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
            const SizedBox(height: 8),
            Text(
              'John Doe',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'john.doe@exemple.com',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),

            const Divider(),

            // ... (Tous les _buildSettingsItem, _buildToggleItem, etc. restent inchangés) ...

            // [COLLEZ ICI TOUT LE CODE DE VOS WIDGETS UTILITAIRES]
            // ... (Ex: _buildSettingsItem, _buildToggleItem, _buildDestructiveItem, _buildSliderItem) ...
            // Pour ne pas surcharger la réponse, nous supposons que ces méthodes sont incluses.
            _buildSettingsItem(
              context,
              icon: Icons.person_outline,
              title: 'Compte',
              subtitle: 'Modifier profil, Changer mot de passe',
              onTap: () => debugPrint('Naviguer vers Modifier Profil (F1.6.2)'),
            ),
            _buildSettingsItem(
              context,
              icon: Icons.history,
              title: 'Historique de conversation',
              onTap: () => debugPrint('Naviguer vers Historique (F1.6.2)'),
            ),
            _buildToggleItem(
              context,
              icon: Icons.wb_sunny_outlined,
              title: 'Mode Sombre',
              value: themeNotifier.themeMode == ThemeMode.dark,
              onChanged: (isDark) {
                themeNotifier.setThemeMode(
                  isDark ? ThemeMode.dark : ThemeMode.light,
                );
              },
            ),
            _buildSliderItem(
              context,
              icon: Icons.text_fields,
              title: 'Taille du texte',
              onChanged: (value) =>
                  debugPrint('Taille du texte ajustée à $value'),
            ),
            _buildToggleItem(
              context,
              icon: Icons.notifications_none,
              title: 'Notifications',
              value: true,
              onChanged: (value) =>
                  debugPrint('Notifications : $value (F1.6.5)'),
            ),
            const Divider(),
            _buildDestructiveItem(
              context,
              icon: Icons.delete_outline,
              title: 'Effacer l\'historique',
              onTap: () => debugPrint(
                'Ouvrir dialogue confirmation Effacer Historique (F1.6.6)',
              ),
            ),
            _buildSettingsItem(
              context,
              icon: Icons.cloud_download_outlined,
              title: 'Télécharger mes données',
              onTap: () => debugPrint('Télécharger données (F1.6.7)'),
            ),
            _buildDestructiveItem(
              context,
              icon: Icons.person_remove_alt_1_outlined,
              title: 'Supprimer mon compte',
              onTap: () => debugPrint(
                'Ouvrir dialogue confirmation Suppression Compte (F1.6.8)',
              ),
            ),
            const Divider(),
            _buildSettingsItem(
              context,
              icon: Icons.info_outline,
              title: 'Aide & À Propos',
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const AboutScreen()));
              },
            ),

            const SizedBox(height: 30),

            // Bouton de Déconnexion mis à jour
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: OutlinedButton(
                onPressed: _isSigningOut
                    ? null
                    : _logout, // Désactivation pendant la déconnexion
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: theme.colorScheme.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: _isSigningOut
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: theme.colorScheme.error,
                        ),
                      )
                    : Text(
                        'Déconnexion',
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  // 💡 N'OUBLIEZ PAS D'INCLURE ICI TOUTES VOS MÉTHODES _buildSettingsItem, _buildToggleItem, etc.

  // Widget utilitaire pour les liens de paramètres
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  // Widget utilitaire pour les toggles (Mode Sombre, Notifications)
  Widget _buildToggleItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(title),
      trailing: Switch(value: value, onChanged: onChanged),
      onTap: () => onChanged(!value),
    );
  }

  // Widget utilitaire pour les actions destructrices (en rouge)
  Widget _buildDestructiveItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final color = Colors.red.shade700;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }

  // Widget utilitaire pour le Slider (Taille du texte)
  Widget _buildSliderItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Theme.of(context).primaryColor),
          title: Text(title),
        ),
        Slider(
          value: 0.5, // Valeur mockée par défaut
          min: 0.0,
          max: 1.0,
          divisions: 3,
          onChanged: onChanged,
        ),
        const Divider(),
      ],
    );
  }
}
