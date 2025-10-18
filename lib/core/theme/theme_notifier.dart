// Fichier : lib/core/theme/theme_notifier.dart
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  // Par défaut : mode clair
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  // F1.6.3 : Fonction pour basculer le mode sombre/clair
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    // Notifie les widgets abonnés que le thème a changé
    notifyListeners();
  }

  // Option pour définir le thème directement
  void setThemeMode(ThemeMode mode) {
    if (mode != _themeMode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
