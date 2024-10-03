import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      color: Colors.blue,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).titleLarge,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.blue,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[600], fontSize: 14),
      displayLarge: TextStyle(
          color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
    ),
    iconTheme: IconThemeData(
      color: Colors.blue,
      size: 24,
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.blueAccent),
  );

  // Define dark theme
  static final ThemeData darkTheme = ThemeData(
    primaryColor: Colors.deepPurple,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.deepPurple,
      iconTheme: IconThemeData(color: Colors.white),
      toolbarTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).bodyMedium,
      titleTextStyle: TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ).titleLarge,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.deepPurple,
      textTheme: ButtonTextTheme.primary,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.grey[400], fontSize: 14),
      displayLarge: TextStyle(
          color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(color: Colors.grey, fontSize: 12),
    ),
    iconTheme: IconThemeData(
      color: Colors.deepPurple,
      size: 24,
    ),
    colorScheme:
        ColorScheme.fromSwatch().copyWith(secondary: Colors.purpleAccent),
  );
}
