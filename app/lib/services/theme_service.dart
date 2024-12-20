import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to manage theme mode changes and persistence
class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  bool _initialized = false;

  ThemeService() {
    _loadThemeMode();
  }

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether the service has been initialized
  bool get initialized => _initialized;

  /// Whether the current theme is dark
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Load saved theme mode from preferences
  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      if (savedTheme != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.name == savedTheme,
          orElse: () => ThemeMode.system,
        );
      }
    } catch (e) {
      debugPrint('Error loading theme mode: $e');
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  /// Save theme mode to preferences
  Future<void> _saveThemeMode(ThemeMode mode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.name);
    } catch (e) {
      debugPrint('Error saving theme mode: $e');
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    switch (_themeMode) {
      case ThemeMode.system:
        _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
        break;
      case ThemeMode.light:
        _themeMode = ThemeMode.dark;
        break;
      case ThemeMode.dark:
        _themeMode = ThemeMode.light;
        break;
    }
    await _saveThemeMode(_themeMode);
    notifyListeners();
  }

  /// Set specific theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _saveThemeMode(mode);
    notifyListeners();
  }

  /// Reset to system theme mode
  Future<void> resetToSystem() async {
    if (_themeMode == ThemeMode.system) return;
    _themeMode = ThemeMode.system;
    await _saveThemeMode(_themeMode);
    notifyListeners();
  }
} 