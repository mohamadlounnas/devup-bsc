import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// A custom theme class that provides a beautiful night city theme for the app
/// with modern, sleek colors that represent a smart city at night
class AppTheme {
  /// Primary colors for the night city theme
  static const _nightBlue = Color(0xFF0A192F);    // Darker blue for background
  static const _neonBlue = Color(0xFF64FFDA);     // Bright cyan for primary actions
  static const _deepPurple = Color(0xFF1D1E3C);   // Deep purple for containers
  static const _neonPurple = Color(0xFF7B61FF);   // Bright purple for accents
  static const _cityGray = Color(0xFF1A1B2E);     // Dark blue-gray for surfaces
  static const _neonPink = Color(0xFFFF61E6);     // Bright pink for highlights
  static const _lightBg = Color(0xFFF8F9FC);      // Light background
  static const _lightSurface = Color(0xFFFFFFFF);  // Light surface
  static const _lightAccent = Color(0xFF6E56CF);   // Light mode accent

  /// Get the dark theme data for the night city theme
  static ThemeData getDarkTheme() => _getTheme(true);

  /// Get the light theme data
  static ThemeData getLightTheme() => _getTheme(false);

  /// Internal method to generate theme data
  static ThemeData _getTheme(bool isDark) {
    final darkGradient = [
      [
        const Color(0xFF0A1325),
        const Color(0xFF1A1B2E),
        const Color(0xFF1D1E3C),
      ],
      [
        const Color(0xFF0A192F).withOpacity(0.95),
        const Color(0xFF1A1B2E).withOpacity(0.95),
        const Color(0xFF1D1E3C).withOpacity(0.95),
      ],
    ];

    final lightGradient = [
      [
        const Color(0xFFF8F9FC),
        const Color(0xFFF0F1F5),
        const Color(0xFFE8E9F0),
      ],
      [
        const Color(0xFFF8F9FC).withOpacity(0.95),
        const Color(0xFFF0F1F5).withOpacity(0.95),
        const Color(0xFFE8E9F0).withOpacity(0.95),
      ],
    ];

    final colorScheme = isDark 
      ? ColorScheme.dark(
          primary: _neonBlue,
          onPrimary: _nightBlue,
          primaryContainer: _deepPurple,
          onPrimaryContainer: _neonBlue,
          secondary: _neonPurple,
          onSecondary: Colors.white,
          secondaryContainer: _deepPurple.withOpacity(0.7),
          onSecondaryContainer: _neonPurple,
          tertiary: _neonPink,
          onTertiary: Colors.white,
          tertiaryContainer: _neonPink.withOpacity(0.15),
          onTertiaryContainer: _neonPink,
          background: _nightBlue,
          onBackground: Colors.white,
          surface: _cityGray,
          onSurface: Colors.white,
          surfaceVariant: _cityGray.withOpacity(0.7),
          onSurfaceVariant: Colors.white70,
          outline: Colors.white24,
          outlineVariant: Colors.white12,
          shadow: Colors.black,
        )
      : ColorScheme.light(
          primary: _lightAccent,
          onPrimary: Colors.white,
          primaryContainer: _lightAccent.withOpacity(0.15),
          onPrimaryContainer: _lightAccent,
          secondary: _neonPurple,
          onSecondary: Colors.white,
          secondaryContainer: _neonPurple.withOpacity(0.15),
          onSecondaryContainer: _neonPurple,
          tertiary: _neonPink,
          onTertiary: Colors.white,
          tertiaryContainer: _neonPink.withOpacity(0.15),
          onTertiaryContainer: _neonPink,
          background: _lightBg,
          onBackground: Colors.black,
          surface: _lightSurface,
          onSurface: Colors.black,
          surfaceVariant: _lightSurface.withOpacity(0.7),
          onSurfaceVariant: Colors.black87,
          outline: Colors.black12,
          outlineVariant: Colors.black12,
          shadow: Colors.black,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      colorScheme: colorScheme,
      
      // Card theme with glass morphism effect
      cardTheme: CardTheme(
        elevation: isDark ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
            width: 1.5,
          ),
        ),
        color: (isDark ? _cityGray : _lightSurface).withOpacity(0.8),
        clipBehavior: Clip.antiAlias,
      ),
      
      // AppBar theme with blur effect
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: (isDark ? _cityGray : _lightSurface).withOpacity(0.7),
        foregroundColor: isDark ? Colors.white : Colors.black,
        centerTitle: true,
      ),
      
      // Input decoration theme with modern styling
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: (isDark ? _cityGray : _lightSurface).withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark ? _neonBlue : _lightAccent,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      
      // Button themes with glow effect
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: isDark ? 4 : 2,
          shadowColor: (isDark ? _neonBlue : _lightAccent).withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: isDark ? _neonBlue : _lightAccent,
          foregroundColor: isDark ? _nightBlue : Colors.white,
        ),
      ),
      
      // Chip theme with modern styling
      chipTheme: ChipThemeData(
        backgroundColor: Colors.transparent,
        selectedColor: (isDark ? _neonBlue : _lightAccent).withOpacity(0.15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : Colors.black87,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? Colors.white12 : Colors.black12,
            width: 1.5,
          ),
        ),
      ),
      
      // Text themes with modern typography
      textTheme: _getTextTheme(isDark),
      
      // Icon theme with glow effect
      iconTheme: IconThemeData(
        color: isDark ? _neonBlue : _lightAccent,
        size: 24,
      ),
      
      // Floating action button theme with glow
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: isDark ? _neonBlue : _lightAccent,
        foregroundColor: isDark ? _nightBlue : Colors.white,
        elevation: isDark ? 8 : 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      
      // Bottom navigation bar theme with glass effect
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: (isDark ? _cityGray : _lightSurface).withOpacity(0.8),
        selectedItemColor: isDark ? _neonBlue : _lightAccent,
        unselectedItemColor: isDark ? Colors.white54 : Colors.black45,
        type: BottomNavigationBarType.fixed,
        elevation: isDark ? 8 : 4,
      ),
      
      // Dialog theme with glass effect
      dialogTheme: DialogTheme(
        backgroundColor: (isDark ? _cityGray : _lightSurface).withOpacity(0.9),
        elevation: isDark ? 24 : 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
      ),
      
      // Snackbar theme with glass effect
      snackBarTheme: SnackBarThemeData(
        backgroundColor: (isDark ? _cityGray : _lightSurface).withOpacity(0.9),
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.black,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: isDark ? 8 : 4,
      ),

      // Extensions
      extensions: [
        CustomThemeExtension(
          backgroundGradient: isDark ? darkGradient : lightGradient,
          cardBorder: isDark 
            ? const Border.fromBorderSide(BorderSide(
                color: Colors.white10,
                width: 1.5,
              ))
            : const Border.fromBorderSide(BorderSide(
                color: Colors.black12,
                width: 1.5,
              )),
          glassBackground: (isDark ? Colors.white : Colors.black).withOpacity(0.05),
          glassHighlight: (isDark ? Colors.white : Colors.black).withOpacity(0.1),
        ),
      ],
    );
  }

  static TextTheme _getTextTheme(bool isDark) {
    final color = isDark ? Colors.white : Colors.black;
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 57,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.25,
        height: 1.12,
        color: color,
      ),
      displayMedium: TextStyle(
        fontSize: 45,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        height: 1.16,
        color: color,
      ),
      displaySmall: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        letterSpacing: 0,
        height: 1.22,
        color: color,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
        color: color,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.29,
        color: color,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.33,
        color: color,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.27,
        color: color,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.15,
        height: 1.5,
        color: color,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.1,
        height: 1.43,
        color: color,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
        color: color,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
        color: color,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
        color: color,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.5,
        color: color,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
        color: color,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
        color: color,
      ),
    );
  }
}

/// Custom theme extension for additional properties
class CustomThemeExtension extends ThemeExtension<CustomThemeExtension> {
  final List<List<Color>> backgroundGradient;
  final Border cardBorder;
  final Color glassBackground;
  final Color glassHighlight;

  const CustomThemeExtension({
    required this.backgroundGradient,
    required this.cardBorder,
    required this.glassBackground,
    required this.glassHighlight,
  });

  @override
  CustomThemeExtension copyWith({
    List<List<Color>>? backgroundGradient,
    Border? cardBorder,
    Color? glassBackground,
    Color? glassHighlight,
  }) {
    return CustomThemeExtension(
      backgroundGradient: backgroundGradient ?? this.backgroundGradient,
      cardBorder: cardBorder ?? this.cardBorder,
      glassBackground: glassBackground ?? this.glassBackground,
      glassHighlight: glassHighlight ?? this.glassHighlight,
    );
  }

  @override
  CustomThemeExtension lerp(
    covariant CustomThemeExtension? other,
    double t,
  ) {
    if (other is! CustomThemeExtension) {
      return this;
    }

    return CustomThemeExtension(
      backgroundGradient: backgroundGradient,
      cardBorder: Border.lerp(cardBorder, other.cardBorder, t) ?? cardBorder,
      glassBackground: Color.lerp(glassBackground, other.glassBackground, t) ?? glassBackground,
      glassHighlight: Color.lerp(glassHighlight, other.glassHighlight, t) ?? glassHighlight,
    );
  }
} 