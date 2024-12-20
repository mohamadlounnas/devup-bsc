import 'package:flutter/material.dart';

/// A comprehensive spacing system that follows Material Design 3 guidelines.
/// This class provides consistent spacing values throughout the app.
class Spacing {
  /// Micro spacing for very tight areas (2.0)
  static const micro = 2.0;

  /// Extra small spacing for minimal separation (4.0)
  static const xs = 4.0;

  /// Small spacing for close elements (8.0)
  static const sm = 8.0;

  /// Medium spacing for standard separation (12.0)
  static const md = 12.0;

  /// Default spacing for general use (16.0)
  static const lg = 16.0;

  /// Large spacing for emphasized separation (20.0)
  static const xl = 20.0;

  /// Extra large spacing for major sections (24.0)
  static const xxl = 24.0;

  /// Huge spacing for dramatic separation (32.0)
  static const huge = 32.0;

  /// Massive spacing for major layout sections (48.0)
  static const massive = 48.0;

  /// Standard page padding for consistent page margins
  static EdgeInsets get pagePadding => EdgeInsets.all(lg);

  /// Compact page padding for smaller screens
  static EdgeInsets get pageCompactPadding => EdgeInsets.all(md);

  /// Standard card padding
  static EdgeInsets get cardPadding => EdgeInsets.all(lg);

  /// Compact card padding
  static EdgeInsets get cardCompactPadding => EdgeInsets.all(md);

  /// List item padding
  static EdgeInsets get listItemPadding => EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Compact list item padding
  static EdgeInsets get listItemCompactPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Dialog padding
  static EdgeInsets get dialogPadding => EdgeInsets.all(xl);

  /// Button padding
  static EdgeInsets get buttonPadding => EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  /// Compact button padding
  static EdgeInsets get buttonCompactPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Form field padding
  static EdgeInsets get formFieldPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Chip padding
  static EdgeInsets get chipPadding => EdgeInsets.symmetric(
    horizontal: md,
    vertical: xs,
  );

  /// Grid spacing
  static const gridSpacing = lg;

  /// Compact grid spacing
  static const gridCompactSpacing = md;

  /// Section spacing
  static const sectionSpacing = xxl;

  /// Responsive breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  /// Returns appropriate spacing based on screen width
  static double getResponsiveSpacing(double screenWidth) {
    if (screenWidth < mobileBreakpoint) return md;
    if (screenWidth < tabletBreakpoint) return lg;
    return xl;
  }

  /// Returns appropriate insets based on screen width
  static EdgeInsets getResponsiveInsets(double screenWidth) {
    final spacing = getResponsiveSpacing(screenWidth);
    return EdgeInsets.all(spacing);
  }

  /// Returns appropriate horizontal insets based on screen width
  static EdgeInsets getResponsiveHorizontalInsets(double screenWidth) {
    final spacing = getResponsiveSpacing(screenWidth);
    return EdgeInsets.symmetric(horizontal: spacing);
  }

  /// Returns appropriate vertical insets based on screen width
  static EdgeInsets getResponsiveVerticalInsets(double screenWidth) {
    final spacing = getResponsiveSpacing(screenWidth);
    return EdgeInsets.symmetric(vertical: spacing);
  }
}

/// Extension methods for responsive spacing
extension SpacingExtension on BuildContext {
  /// Returns true if the screen is considered mobile size
  bool get isMobile => MediaQuery.of(this).size.width < Spacing.mobileBreakpoint;

  /// Returns true if the screen is considered tablet size
  bool get isTablet =>
      MediaQuery.of(this).size.width >= Spacing.mobileBreakpoint &&
      MediaQuery.of(this).size.width < Spacing.tabletBreakpoint;

  /// Returns true if the screen is considered desktop size
  bool get isDesktop =>
      MediaQuery.of(this).size.width >= Spacing.desktopBreakpoint;

  /// Returns the appropriate spacing based on screen size
  double get responsiveSpacing =>
      Spacing.getResponsiveSpacing(MediaQuery.of(this).size.width);

  /// Returns the appropriate insets based on screen size
  EdgeInsets get responsiveInsets =>
      Spacing.getResponsiveInsets(MediaQuery.of(this).size.width);

  /// Returns the appropriate horizontal insets based on screen size
  EdgeInsets get responsiveHorizontalInsets =>
      Spacing.getResponsiveHorizontalInsets(MediaQuery.of(this).size.width);

  /// Returns the appropriate vertical insets based on screen size
  EdgeInsets get responsiveVerticalInsets =>
      Spacing.getResponsiveVerticalInsets(MediaQuery.of(this).size.width);
} 