import 'package:flutter/material.dart';

class AppColors {
  // Primary colors that work well in both light and dark mode
  static Color getPrimaryColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.blue.shade300
        : Colors.blue.shade600;
  }

  // Surface colors with good contrast
  static Color getSurfaceColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : Colors.white;
  }

  // Background colors
  static Color getBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF121212)
        : Colors.grey.shade50;
  }

  // Text colors with high contrast
  static Color getPrimaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  static Color getSecondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : Colors.black54;
  }

  static Color getTertiaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white60
        : Colors.grey.shade600;
  }

  // Program area colors that work in both themes
  static Color getProgramColor(String program, {bool isDark = false}) {
    final baseColors = {
      'hts': Colors.blue,
      'tx': Colors.green,
      'pmtct': Colors.pink,
      'tb': Colors.orange,
      'kp': Colors.purple,
      'ovc': Colors.teal,
    };

    final color = baseColors[program.toLowerCase()] ?? Colors.grey;
    return isDark ? color.shade400 : color.shade600;
  }

  // Card colors with good contrast
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF1E1E1E)
        : Colors.white;
  }

  // Border colors
  static Color getBorderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;
  }

  // Chip colors
  static Color getChipBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2C2C2C)
        : Colors.grey.shade100;
  }

  static Color getChipTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }

  // Search bar colors
  static Color getSearchBarColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF2C2C2C)
        : Colors.white;
  }

  // Divider colors
  static Color getDividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.grey.shade700
        : Colors.grey.shade300;
  }
}