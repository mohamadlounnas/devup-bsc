import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that manages app settings and preferences
class SettingsService extends ChangeNotifier {
  static const String _introCompletedKey = 'intro_completed';
  
  final SharedPreferences _prefs;
  
  SettingsService(this._prefs);

  /// Whether the user has completed the intro screen
  bool get hasCompletedIntro => _prefs.getBool(_introCompletedKey) ?? false;

  /// Mark the intro screen as completed
  Future<void> completeIntro() async {
    await _prefs.setBool(_introCompletedKey, true);
    notifyListeners();
  }

  /// Reset the intro screen completion state (for testing)
  Future<void> resetIntro() async {
    await _prefs.setBool(_introCompletedKey, false);
    notifyListeners();
  }
} 