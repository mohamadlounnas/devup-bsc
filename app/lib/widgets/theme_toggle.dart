import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';

/// A beautiful animated theme toggle button
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeService = context.watch<ThemeService>();
    final isDark = themeService.isDarkMode;

    return Tooltip(
      message: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: InkWell(
        onTap: themeService.toggleTheme,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return RotationTransition(
                turns: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              key: ValueKey(isDark),
              color: isDark 
                ? theme.colorScheme.primary 
                : theme.colorScheme.primary,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
} 