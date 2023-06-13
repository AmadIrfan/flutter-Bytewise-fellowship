import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeChanger with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  void setThemeMod(ThemeMode? mode) {
    _themeMode = mode!;
    notifyListeners();
  }

  void setTheme() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    int? i = sp.getInt('themeModeInt');
    if (i == 0) {
      setThemeMod(ThemeMode.light);
    } else if (i == 1) {
      setThemeMod(ThemeMode.dark);
    } else if (i == 2) {
      setThemeMod(ThemeMode.system);
    } else {
      setThemeMod(ThemeMode.system);
    }
    notifyListeners();
  }

  void getTheme(int num) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.setInt('themeModeInt', num);
    setTheme();
  }
}
