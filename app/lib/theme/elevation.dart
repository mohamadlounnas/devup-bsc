import 'package:flutter/material.dart';

/// A comprehensive elevation system that follows Material Design 3 guidelines.
/// This class provides consistent elevation values and shadow styles throughout the app.
class Elevation {
  /// No elevation (0.0)
  static const none = 0.0;

  /// Extra small elevation for subtle depth (1.0)
  static const xs = 1.0;

  /// Small elevation for light depth (2.0)
  static const sm = 2.0;

  /// Medium elevation for standard depth (4.0)
  static const md = 4.0;

  /// Large elevation for prominent depth (6.0)
  static const lg = 6.0;

  /// Extra large elevation for major depth (8.0)
  static const xl = 8.0;

  /// Huge elevation for dramatic depth (12.0)
  static const huge = 12.0;

  /// Standard card elevation
  static const card = sm;

  /// Elevated card elevation
  static const cardElevated = md;

  /// Dialog elevation
  static const dialog = xl;

  /// Bottom sheet elevation
  static const bottomSheet = lg;

  /// App bar elevation
  static const appBar = sm;

  /// Floating action button elevation
  static const fab = md;

  /// Menu elevation
  static const menu = lg;

  /// Snackbar elevation
  static const snackbar = huge;

  /// Returns a list of box shadows for the given elevation
  static List<BoxShadow> getShadows(
    double elevation, {
    Color? shadowColor,
    double opacity = 0.2,
  }) {
    if (elevation == 0) return [];

    final color = shadowColor ?? const Color(0xFF000000);

    return [
      BoxShadow(
        color: color.withOpacity(opacity * 0.3),
        blurRadius: elevation * 1.5,
        offset: Offset(0, elevation * 0.5),
      ),
      BoxShadow(
        color: color.withOpacity(opacity * 0.2),
        blurRadius: elevation * 3,
        offset: Offset(0, elevation),
      ),
    ];
  }

  /// Returns appropriate elevation based on screen width
  static double getResponsiveElevation(double screenWidth) {
    if (screenWidth < 600) return sm;
    if (screenWidth < 900) return md;
    return lg;
  }
}

/// Extension methods for responsive elevation
extension ElevationExtension on BuildContext {
  /// Returns the appropriate elevation based on screen size
  double get responsiveElevation =>
      Elevation.getResponsiveElevation(MediaQuery.of(this).size.width);

  /// Returns the appropriate shadows based on screen size
  List<BoxShadow> get responsiveShadows =>
      Elevation.getShadows(responsiveElevation);

  /// Returns shadows with custom color and opacity
  List<BoxShadow> getShadowsWithColor(
    Color color, {
    double? elevation,
    double opacity = 0.2,
  }) =>
      Elevation.getShadows(
        elevation ?? responsiveElevation,
        shadowColor: color,
        opacity: opacity,
      );
} 