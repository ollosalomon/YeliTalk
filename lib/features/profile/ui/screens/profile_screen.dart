import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:YeliTalk/core/theme/theme_notifier.dart';
import 'package:YeliTalk/features/profile/ui/screens/about_screen.dart'; // NOUVEAU

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fonction pour les actions du bouton de déconnexion
  void _logout(BuildContext context) {
    // F1.2.3: La déconnexion est simulée pour l'Étape 1
    print("Déconnexion simulée. Retour à l'écran de connexion.");
    // Retour à l'écran de connexion (SplashScreen naviguerait vers Login)
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    // Écoutez le ThemeNotifier pour la bascule Mode Sombre (F1.1.5)
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil & Paramètres',
        ), // Ajusté le titre comme dans votre image
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            // F1.6.1: Avatar, Nom, Email
            const CircleAvatar(
              radius: 40,
              // Remplacez par le chemin de l'image de profil réelle
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 8),
            Text(
              'John Doe',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'john.doe@exemple.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 20),

            const Divider(), // Séparateur visuel
            // F1.6.2: Modifier profil
            _buildSettingsItem(
              context,
              icon: Icons.person_outline,
              title: 'Compte',
              subtitle: 'Modifier profil, Changer mot de passe',
              onTap: () => print('Naviguer vers Modifier Profil (F1.6.2)'),
            ),

            // Historique de conversation (F1.6.2)
            _buildSettingsItem(
              context,
              icon: Icons.history,
              title: 'Historique de conversation',
              onTap: () => print('Naviguer vers Historique (F1.6.2)'),
            ),

            // F1.6.3: Toggle Mode Sombre (avec ThemeNotifier)
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

            // F1.6.4: Slider Taille du texte (Mocké)
            _buildSliderItem(
              context,
              icon: Icons.text_fields,
              title: 'Taille du texte',
              // Note: L'implémentation réelle de la taille du texte est plus complexe
              // et utilise le `MediaQuery` ou un Provider pour l'héritage.
              onChanged: (value) => print('Taille du texte ajustée à $value'),
            ),

            // F1.6.5: Gestion notifications (Toggle mocké)
            _buildToggleItem(
              context,
              icon: Icons.notifications_none,
              title: 'Notifications',
              value: true,
              onChanged: (value) => print('Notifications : $value (F1.6.5)'),
            ),

            const Divider(),

            // F1.6.6: Effacer l'historique
            _buildDestructiveItem(
              context,
              icon: Icons.delete_outline,
              title: 'Effacer l\'historique',
              onTap: () => print(
                'Ouvrir dialogue confirmation Effacer Historique (F1.6.6)',
              ),
            ),

            // F1.6.7: Télécharger mes données (RGPD)
            _buildSettingsItem(
              context,
              icon: Icons.cloud_download_outlined,
              title: 'Télécharger mes données',
              onTap: () => print('Télécharger données (F1.6.7)'),
            ),

            // F1.6.8: Supprimer mon compte
            _buildDestructiveItem(
              context,
              icon: Icons.person_remove_alt_1_outlined,
              title: 'Supprimer mon compte',
              onTap: () => print(
                'Ouvrir dialogue confirmation Suppression Compte (F1.6.8)',
              ),
            ),

            const Divider(),

            // F1.7: Aide & À Propos (NOUVEAU LIEN)
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

            // Bouton de Déconnexion
            const SizedBox(height: 30),
            OutlinedButton(
              onPressed: () => _logout(context),
              child: const Text('Déconnexion'),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

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
      onTap: () => onChanged(!value), // Permet de toggler en tapant le ListTile
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
