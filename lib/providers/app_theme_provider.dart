import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = 'appSettings';
  static const String _themeKey = 'themeMode';

  ThemeMode _themeMode;
  Box<String>? _appSettingsBox;

  AppThemeProvider() : _themeMode = ThemeMode.system {
    _initTheme();
  }

  ThemeMode get themeMode => _themeMode;

  Future<void> _initTheme() async {
    _appSettingsBox = await Hive.openBox<String>(_themeBoxName);
    final storedTheme = _appSettingsBox?.get(_themeKey);
    if (storedTheme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (storedTheme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    notifyListeners();
  }

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    _appSettingsBox?.put(_themeKey, isDarkMode ? 'dark' : 'light');
    notifyListeners();
  }
}
