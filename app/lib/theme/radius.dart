import 'package:flutter/material.dart';

/// A comprehensive radius system that follows Material Design 3 guidelines.
/// This class provides consistent corner rounding values throughout the app.
class AppRadius {
  /// No rounding (0.0)
  static const none = 0.0;

  /// Extra small rounding for subtle curves (4.0)
  static const xs = 4.0;

  /// Small rounding for light curves (8.0)
  static const sm = 8.0;

  /// Medium rounding for standard curves (12.0)
  static const md = 12.0;

  /// Large rounding for prominent curves (16.0)
  static const lg = 16.0;

  /// Extra large rounding for major curves (20.0)
  static const xl = 20.0;

  /// Circular rounding (9999.0)
  static const circular = 9999.0;

  /// Standard card border radius
  static BorderRadius get card => BorderRadius.circular(lg);

  /// Compact card border radius
  static BorderRadius get cardCompact => BorderRadius.circular(md);

  /// Button border radius
  static BorderRadius get button => BorderRadius.circular(md);

  /// Compact button border radius
  static BorderRadius get buttonCompact => BorderRadius.circular(sm);

  /// Chip border radius
  static BorderRadius get chip => BorderRadius.circular(circular);

  /// Dialog border radius
  static BorderRadius get dialog => BorderRadius.circular(xl);

  /// Bottom sheet border radius
  static BorderRadius get bottomSheet => BorderRadius.only(
    topLeft: Radius.circular(xl),
    topRight: Radius.circular(xl),
  );

  /// Search field border radius
  static BorderRadius get searchField => BorderRadius.circular(circular);

  /// Form field border radius
  static BorderRadius get formField => BorderRadius.circular(sm);

  /// Returns appropriate border radius based on screen width
  static double getResponsiveRadius(double screenWidth) {
    if (screenWidth < 600) return md;
    if (screenWidth < 900) return lg;
    return xl;
  }

  /// Returns appropriate border radius based on screen width
  static BorderRadius getResponsiveBorderRadius(double screenWidth) {
    return BorderRadius.circular(getResponsiveRadius(screenWidth));
  }
}

/// Extension methods for responsive radius
extension RadiusExtension on BuildContext {
  /// Returns the appropriate radius based on screen size
  double get responsiveRadius =>
      AppRadius.getResponsiveRadius(MediaQuery.of(this).size.width);

  /// Returns the appropriate border radius based on screen size
  BorderRadius get responsiveBorderRadius =>
      AppRadius.getResponsiveBorderRadius(MediaQuery.of(this).size.width);
} 