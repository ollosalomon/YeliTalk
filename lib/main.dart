import 'package:flutter/material.dart';
import 'core/theme/app_themes.dart'; // Contient lightTheme et darkTheme
import 'features/auth/ui/screens/splash_screen.dart'; // Notre premier écran (F1.2.1)
import 'package:provider/provider.dart'; // Assurez-vous d'avoir la dépendance provider
import 'package:YeliTalk/core/theme/theme_notifier.dart'; // Importez le ThemeNotifier

void main() {
  runApp(
    // 1. Utilisez ChangeNotifierProvider pour rendre ThemeNotifier accessible
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const YeliTalkApp(),
    ),
  );
}

// YeliTalkApp est un StatelessWidget, car la gestion de l'état (thème)
// est déléguée au ThemeNotifier via Provider.
class YeliTalkApp extends StatelessWidget {
  const YeliTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Écoutez les changements de thème (géré par ThemeNotifier)
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false, // Recommandé en prototype
      // F1.1.5: Définition des thèmes clair et sombre
      theme: lightTheme, // Votre thème clair
      darkTheme: darkTheme, // Votre thème sombre
      // La propriété themeMode est lue depuis le Notifier
      themeMode: themeNotifier.themeMode,

      // Point de départ de l'application (F1.2.1)
      home: const SplashScreen(),
    );
  }
}
