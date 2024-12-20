import 'package:flutter/material.dart';

/// Design system exports
export 'spacing.dart';
export 'radius.dart';
export 'elevation.dart';

/// Design system constants and utilities
class DesignSystem {
  /// Animation durations
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);

  /// Animation curves
  static const Curve animationCurve = Curves.easeOutCubic;
  static const Curve animationBouncyCurve = Curves.easeOutBack;
  static const Curve animationSharpCurve = Curves.easeOutQuart;

  /// Opacity values
  static const double opacityDisabled = 0.38;
  static const double opacityLight = 0.5;
  static const double opacityMedium = 0.7;
  static const double opacityHigh = 0.87;
  static const double opacityFull = 1.0;

  /// Z-index values
  static const int zIndexBackground = -1;
  static const int zIndexContent = 0;
  static const int zIndexOverlay = 1;
  static const int zIndexModal = 2;
  static const int zIndexTooltip = 3;
  static const int zIndexSnackbar = 4;

  /// Maximum width constraints
  static const double maxWidthMobile = 600;
  static const double maxWidthTablet = 900;
  static const double maxWidthDesktop = 1200;
  static const double maxWidthContent = 1440;

  /// Aspect ratios
  static const double aspectRatioSquare = 1.0;
  static const double aspectRatioLandscape = 16 / 9;
  static const double aspectRatioPortrait = 3 / 4;
  static const double aspectRatioWide = 21 / 9;

  /// Icon sizes
  static const double iconSizeSmall = 16;
  static const double iconSizeMedium = 24;
  static const double iconSizeLarge = 32;
  static const double iconSizeHuge = 48;

  /// Image sizes
  static const double imageSizeThumbnail = 80;
  static const double imageSizeSmall = 120;
  static const double imageSizeMedium = 200;
  static const double imageSizeLarge = 300;
  static const double imageSizeHuge = 400;

  /// Avatar sizes
  static const double avatarSizeSmall = 32;
  static const double avatarSizeMedium = 40;
  static const double avatarSizeLarge = 56;
  static const double avatarSizeHuge = 72;

  /// Button heights
  static const double buttonHeightSmall = 32;
  static const double buttonHeightMedium = 40;
  static const double buttonHeightLarge = 48;

  /// Input heights
  static const double inputHeightSmall = 32;
  static const double inputHeightMedium = 40;
  static const double inputHeightLarge = 48;

  /// App bar heights
  static const double appBarHeightCompact = 48;
  static const double appBarHeightRegular = 56;
  static const double appBarHeightLarge = 64;
  static const double appBarHeightExpanded = 128;

  /// Bottom navigation bar height
  static const double bottomNavBarHeight = 56;

  /// Bottom sheet heights
  static const double bottomSheetHeightMin = 0.25;
  static const double bottomSheetHeightMid = 0.5;
  static const double bottomSheetHeightMax = 0.9;

  /// Drawer widths
  static const double drawerWidthCompact = 72;
  static const double drawerWidthRegular = 256;
  static const double drawerWidthExpanded = 320;

  /// Returns appropriate max width based on screen width
  static double getResponsiveMaxWidth(double screenWidth) {
    if (screenWidth < maxWidthMobile) return screenWidth;
    if (screenWidth < maxWidthTablet) return maxWidthMobile;
    if (screenWidth < maxWidthDesktop) return maxWidthTablet;
    return maxWidthContent;
  }
} 