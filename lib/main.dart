import 'package:flutter/material.dart';
// 1. Importation du Thème et des Écrans
import 'core/theme/app_themes.dart'; // Contient lightTheme et darkTheme
import 'features/auth/ui/screens/splash_screen.dart'; // Notre premier écran (F1.2.1)

void main() {
  // Optionnel: Assurez-vous que les bindings Flutter sont initialisés
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const YeliTalkApp());
}

// F1.1.5: Pour un prototype complet, nous utiliserons un StatefulWidget
// pour simuler le basculement entre les thèmes (Clair/Sombre) au niveau global.
class YeliTalkApp extends StatefulWidget {
  const YeliTalkApp({super.key});

  @override
  State<YeliTalkApp> createState() => _YeliTalkAppState();

  // Méthode statique pour permettre aux widgets enfants de basculer le thème
  static _YeliTalkAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_YeliTalkAppState>()!;
}

class _YeliTalkAppState extends State<YeliTalkApp> {
  // Thème par défaut: Clair
  ThemeMode _themeMode = ThemeMode.light;

  // F1.1.5: Logique de bascule du Mode Sombre
  void toggleTheme(bool isDarkMode) {
    setState(() {
      _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // 2. Métadonnées de l'application
      title: 'YeliTalk',
      debugShowCheckedModeBanner: false,

      // 3. Application du Thème (F1.1.5)
      theme: lightTheme, // Applique le thème clair
      darkTheme: darkTheme, // Applique le thème sombre
      themeMode: _themeMode, // Gère le basculement (light, dark, system)
      // 4. Point de départ (F1.2.1)
      // Le premier widget affiché sera le SplashScreen
      home: const SplashScreen(),
    );
  }
}
