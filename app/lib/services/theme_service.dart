import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service responsible for managing app theme state
class ThemeService extends ChangeNotifier {
  bool _isDarkMode = false;
  static const _key = 'isDarkMode';

  /// Whether the app is in dark mode
  bool get isDarkMode => _isDarkMode;

  /// Initialize theme state from preferences
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool(_key) ?? false;
    notifyListeners();
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, _isDarkMode);
    notifyListeners();
  }
} 