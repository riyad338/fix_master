// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// enum ThemeModeType { Light, Dark }
//
// class ThemeProvider extends ChangeNotifier {
//   ThemeData _themeData = ThemeData.light(); // Initialize with a default theme
//   ThemeModeType _themeModeType = ThemeModeType.Light;
//
//   ThemeProvider() {
//     _setThemeData();
//   }
//
//   ThemeData get themeData => _themeData;
//   ThemeModeType get themeModeType => _themeModeType;
//
//   void toggleTheme() async {
//     _themeModeType = _themeModeType == ThemeModeType.Light
//         ? ThemeModeType.Dark
//         : ThemeModeType.Light;
//     _setThemeData();
//     SharedPreferences prefs;
//     prefs = await SharedPreferences.getInstance();
//
//     if (_themeData == ThemeData.dark()) {
//       _themeData = ThemeData.dark();
//       await prefs.setBool("darkTheme", false);
//     } else {
//       _themeData = ThemeData.light();
//       await prefs.setBool("darkTheme", true);
//     }
//
//     notifyListeners();
//   }
//
//   void _setThemeData() {
//     _themeData = _themeModeType == ThemeModeType.Light
//         ? ThemeData.light()
//         : ThemeData.dark();
//   }
// }
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeType { Light, Dark }

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = ThemeData.light(); // Initialize with a default theme
  ThemeModeType _themeModeType = ThemeModeType.Light;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;
  ThemeModeType get themeModeType => _themeModeType;

  void toggleTheme() async {
    _themeModeType = _themeModeType == ThemeModeType.Light
        ? ThemeModeType.Dark
        : ThemeModeType.Light;
    _setThemeData();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
        "themeMode", _themeModeType.index); // Save the theme mode index

    notifyListeners();
  }

  void _setThemeData() {
    _themeData = _themeModeType == ThemeModeType.Light
        ? ThemeData.light()
        : ThemeData.dark();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeModeIndex =
        prefs.getInt("themeMode") ?? 0; // Default to light theme if not found
    _themeModeType = ThemeModeType.values[themeModeIndex];
    _setThemeData();
    notifyListeners();
  }
}
