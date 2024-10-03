import 'package:flutter/material.dart';

class Constants {
  static const String appName = 'My Calculator App';
  static const String welcomeMessage = 'Welcome to the Calculator App!';

  static const Color primaryColor = Color(0xFF2196F3); // Blue
  static const Color accentColor = Color(0xFF03DAC6); // Teal
  static const Color errorColor = Color(0xFFB00020); // Red

  static const double defaultPadding = 16.0;
  static const double defaultMargin = 16.0;

  static const TextStyle headerTextStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  static const TextStyle bodyTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black,
  );

  static const double iconSize = 24.0;

  static const String networkErrorMessage =
      'Failed to connect to the network. Please try again.';
  static const String unexpectedErrorMessage =
      'An unexpected error occurred. Please try again later.';
}
