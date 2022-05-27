import 'package:flutter/material.dart';

class AppThemes {
  ThemeMode getMode(final String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  ThemeData light() {
    const Color primaryColor = Color(0xFF244A9A);

    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(primary: primaryColor),
      appBarTheme: const AppBarTheme(
        color: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: Colors.black,
      ),
    );
  }

  ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF004A77),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
      ),
    );
  }
}
