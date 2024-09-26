import 'package:flutter/material.dart';
import 'package:my_todoo_app/themes/theme.dart';

class ThemesProvider with ChangeNotifier {
  bool isDarkMode = false;

  ThemeData get currentTheme => isDarkMode ? darkMode : lightMode;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    notifyListeners();
  }

}
