import 'package:flutter/material.dart';

class AppThemes {
  ThemeMode getMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
    }
    return ThemeMode.system;
  }

  ThemeData light() {
    const Color accentColor = Colors.deepPurpleAccent;
    const Color cardColor = Color(0xFFEEEEEE);

    final ThemeData base = ThemeData(
     brightness: Brightness.light,
      primarySwatch: _materialColor(accentColor),
      primaryColor: accentColor,
      scaffoldBackgroundColor: Colors.white,
      indicatorColor: accentColor,
      cardColor: cardColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.grey[700],
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: accentColor,
        unselectedItemColor: Colors.black,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
      ),
    );
    return base;
  }

  ThemeData dark() {
    const Color primaryColor = Color(0xFF202020);
    const Color cardColor = Color(0xFF272727);

    final ThemeData base = ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _materialColor(Colors.white),
      primaryColor: primaryColor,
      cardColor: cardColor,
      backgroundColor: primaryColor,
      splashColor: Colors.white10,
      indicatorColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      scaffoldBackgroundColor: primaryColor,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        backgroundColor: cardColor,
        foregroundColor: Colors.grey[400],
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
      tabBarTheme: const TabBarTheme(
        labelColor: Colors.black,
        unselectedLabelColor: Colors.white,
      ),
    );
    return base;
  }
}

MaterialColor _materialColor(Color color) {
  List<double> strengths = [.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (final double strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}
