import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData;

  ThemeProvider({required ThemeData themeData}) : _themeData = themeData;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData.brightness == Brightness.dark;

  void toggleTheme() {
    _themeData = _themeData.brightness == Brightness.dark
        ? ThemeData.light()
        : ThemeData.dark();
    notifyListeners();
  }
}
