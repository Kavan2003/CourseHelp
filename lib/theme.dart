import 'package:flutter/material.dart';

class AppTheme {
  // Color Palette
  static const Color deepBlue = Color(0xFF1A237E);
  static const Color teal = Color(0xFF00897B);
  static const Color coral = Color(0xFFFF5722);
  static const Color amber = Color(0xFFFFC107);
  static const Color offWhite = Color(0xFFF5F5F5);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color darkGray = Color(0xFF424242);

  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 24,
    color: darkGray,
  );

  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    color: darkGray,
  );

  static const TextStyle bodyText = TextStyle(
    fontFamily: 'Open Sans',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: darkGray,
  );

  static const TextStyle buttonText = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: Colors.white,
  );

  // Button Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: deepBlue,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  static final ButtonStyle secondaryButton = OutlinedButton.styleFrom(
    foregroundColor: deepBlue,
    side: const BorderSide(color: deepBlue),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );

  // Input Field Styles
  static final InputDecoration inputDecoration = InputDecoration(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: lightGray),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: const BorderSide(color: teal, width: 2),
    ),
  );

  // Card Styles
  static final BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 0,
        blurRadius: 4,
        offset: const Offset(0, 2),
      ),
    ],
    border: Border.all(color: lightGray),
  );

  // Modal Styles
  static final BoxDecoration modalDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.5),
        spreadRadius: 0,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Theme Data
  static ThemeData get themeData {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: deepBlue),
      useMaterial3: true,
      textTheme: const TextTheme(
        headlineLarge: heading1,
        headlineMedium: heading2,
        bodyLarge: bodyText,
        labelLarge: buttonText,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: inputDecoration.border,
        focusedBorder: inputDecoration.focusedBorder,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: primaryButton),
      outlinedButtonTheme: OutlinedButtonThemeData(style: secondaryButton),
      appBarTheme: AppBarTheme(
        backgroundColor: deepBlue,
        foregroundColor: Colors.white,
        titleTextStyle: heading1.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: deepBlue,
        selectedItemColor: amber,
        unselectedItemColor: offWhite,
        selectedLabelStyle: buttonText,
        unselectedLabelStyle: buttonText.copyWith(color: offWhite),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: teal,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 6,
        margin: const EdgeInsets.all(8),
      ),
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: Colors.white,
        titleTextStyle: heading1,
        contentTextStyle: bodyText,
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.all(teal),
        checkColor: MaterialStateProperty.all(Colors.white),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.all(teal),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(teal),
        trackColor: MaterialStateProperty.all(teal.withOpacity(0.5)),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: amber,
        unselectedLabelColor: offWhite,
        labelStyle: buttonText,
        unselectedLabelStyle: buttonText.copyWith(color: offWhite),
        indicator: const BoxDecoration(
          border: const Border(
            bottom: BorderSide(color: amber, width: 2),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: darkGray,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: buttonText.copyWith(color: Colors.white),
      ),
    );
  }
}
