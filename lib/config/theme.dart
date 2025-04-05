import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF007AFF); // iOS blue
  static const Color secondaryColor = Color(0xFF34C759); // iOS green
  static const Color accentColor = Color(0xFFFF9500); // iOS orange
  static const Color backgroundColor =
      Color(0xFFF2F2F7); // iOS light gray background
  static const Color cardColor = Colors.white;
  static const Color errorColor = Color(0xFFFF3B30); // iOS red
  static const Color textColor = Color(0xFF000000);
  static const Color secondaryTextColor = Color(0xFF8E8E93); // iOS gray

  // Typography
  static const TextStyle headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textColor,
    letterSpacing: -0.5,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textColor,
    letterSpacing: -0.5,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w400,
    color: textColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: secondaryTextColor,
  );

  // Theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      error: errorColor,
      background: backgroundColor,
      surface: cardColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: cardColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: textColor,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: IconThemeData(color: primaryColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(double.infinity, 50),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 1),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
    ),
    cardTheme: CardTheme(
      color: cardColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    useMaterial3: true,
  );
}
