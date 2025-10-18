import 'package:flutter/material.dart'; // <-- C'est l'importation manquante !

// --- Fichier mocké du thème pour compléter l'exemple ---
// Créez ce fichier: lib/core/theme/app_themes.dart

// F1.1.5: Nous réutilisons les thèmes définis dans la réponse précédente

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: const Color(0xFFE88A1A), // Orange
  scaffoldBackgroundColor: const Color(0xFFF7F7F7),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFE88A1A),
    secondary: Color(0xFF008D47),
    background: Color(0xFFF7F7F7),
    onBackground: Colors.black,
  ),
  // ... autres configurations ...
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: const Color(0xFFE88A1A), // Orange
  scaffoldBackgroundColor: const Color(0xFF121212),
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFE88A1A),
    secondary: Color(0xFF008D47),
    background: Color(0xFF121212),
    onBackground: Colors.white,
  ),
  // ... autres configurations ...
);
