import 'package:flutter/material.dart';
import 'data/timeline_data.dart';

/// Logic for managing timeline state and operations
class TimelineLogic extends ChangeNotifier {
  List<TimelineEvent> events = [];
  int _currentYear = 2023;

  void init() {
    events = TimelineData.events;
    notifyListeners();
  }

  int get currentYear => _currentYear;

  void setYear(int year) {
    if (_currentYear != year) {
      _currentYear = year;
      notifyListeners();
    }
  }

  String getEraText(int year) {
    if (year < 1990) return 'Early Years';
    if (year < 2000) return 'Growth Period';
    if (year < 2010) return 'Digital Age';
    if (year < 2020) return 'Innovation Era';
    return 'Modern Times';
  }
} 