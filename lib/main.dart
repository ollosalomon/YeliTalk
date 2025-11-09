import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'firebase_options.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_themes.dart';
import 'features/auth/ui/screens/splash_screen.dart';
import 'package:YeliTalk/core/theme/theme_notifier.dart';

// FUSION DES DEUX FONCTIONS main() EN UNE SEULE ASYNCHRONE
Future<void> main() async {
  // 1. Assure que les bindings (y compris celui de FlutterFire) sont initialisés.
  WidgetsFlutterBinding.ensureInitialized();

  // 2. INITIALISATION DE FIREBASE (REQUIERT firebase_options.dart)
  try {
    // Le code échouait ici car firebase_options n'existait pas.
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ INITIALISATION FIREBASE RÉUSSIE.");
  } catch (e) {
    // Si la génération de firebase_options.dart ne fonctionne pas,
    // l'erreur sera "MissingPluginException" ou "PlatformException".
    print("❌ ERREUR D'INITIALISATION FIREBASE : $e");
    // Optionnel : Afficher un écran d'erreur critique à l'utilisateur ici
  }

  // 3. Lancement de l'application avec Provider.
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const YeliTalkApp(),
    ),
  );
}

// YeliTalkApp reste inchangé
class YeliTalkApp extends StatelessWidget {
  const YeliTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeNotifier.themeMode,

      // Le SplashScreen gère désormais la redirection vers Login/Home
      home: const SplashScreen(),
    );
  }
}
