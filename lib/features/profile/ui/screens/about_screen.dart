// Fichier : lib/features/profile/ui/screens/about_screen.dart

import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Aide & À Propos'), elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // F1.7.1: Logo de l'app
            Image.asset('assets/images/yelitalk_logo_small.png', height: 80),
            const SizedBox(height: 8),

            // F1.7.1: Version de l'application (Mockée)
            Text(
              'Version 1.0.0 (Prototype Etape 1)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 32),

            // F1.7.2: Description courte du produit
            Text(
              'YeliTalk est la marketplace conversationnelle qui vous connecte à des agents IA spécialisés pour répondre à vos questions sur le contexte local ivoirien (Droit, Immobilier, Santé, etc.).',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 40),

            // F1.7.4: Formulaire contact support (Mocké comme un bouton)
            ListTile(
              leading: Icon(Icons.support_agent, color: theme.primaryColor),
              title: const Text('Contacter le Support'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () =>
                  print('Navigation vers le formulaire de contact (F1.7.4)'),
            ),
            const Divider(),

            // F1.7.3: FAQ (Mockée)
            ListTile(
              leading: Icon(Icons.help_outline, color: theme.primaryColor),
              title: const Text('Questions Fréquentes (FAQ)'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => print('Navigation vers la FAQ (F1.7.3)'),
            ),
            const Divider(),
            const SizedBox(height: 40),

            // F1.6.9: Liens légaux (CGU, Politique de confidentialité, Licences)
            Text('Informations Légales', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),

            _buildLegalLink(
              context,
              'Conditions Générales d\'Utilisation',
              () => print('Afficher CGU'),
            ),
            _buildLegalLink(
              context,
              'Politique de Confidentialité',
              () => print('Afficher Politique de Confidentialité'),
            ),
            _buildLegalLink(
              context,
              'Licences Logiciels Libres',
              () => showLicensePage(context: context),
            ),
            const SizedBox(height: 40),

            // F1.7.5: Disclaimer sur l'utilisation de l'IA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '⚠️ Disclaimer IA : Les réponses fournies par nos agents GPT sont à titre informatif uniquement et ne constituent pas un avis professionnel ou légal. Veuillez consulter un expert qualifié pour des décisions importantes.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.red.shade700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegalLink(
    BuildContext context,
    String title,
    VoidCallback onTap,
  ) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        title,
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
