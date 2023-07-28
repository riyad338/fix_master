import 'package:flutter/material.dart';

enum ThemeModeType { Light, Dark }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light(); // Initialize with a default theme
  ThemeModeType _themeModeType = ThemeModeType.Light;

  ThemeProvider() {
    _setThemeData();
  }

  ThemeData get themeData => _themeData;
  ThemeModeType get themeModeType => _themeModeType;

  void toggleTheme() {
    _themeModeType = _themeModeType == ThemeModeType.Light
        ? ThemeModeType.Dark
        : ThemeModeType.Light;
    _setThemeData();
    notifyListeners();
  }

  void _setThemeData() {
    _themeData = _themeModeType == ThemeModeType.Light
        ? ThemeData.light()
        : ThemeData.dark();
  }
}
