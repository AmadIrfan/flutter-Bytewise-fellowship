import 'package:flutter/material.dart';

class ThemeChanger with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themMode => _themeMode;
  void setThemeMod(themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }
}
