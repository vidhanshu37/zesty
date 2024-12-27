import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, color: Colors.black, fontWeight: FontWeight.bold),
    headlineMedium: const TextStyle().copyWith(fontSize: 24.0, color: Colors.black, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle().copyWith(fontSize: 18.0, color: Colors.black, fontWeight: FontWeight.w600),

    titleLarge: const TextStyle().copyWith(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w600),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w500),
    titleSmall: const TextStyle().copyWith(fontSize: 16.0, color: Colors.black, fontWeight: FontWeight.w400),

    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.w500),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, color: Colors.black, fontWeight: FontWeight.normal),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, color: Colors.black, fontWeight: FontWeight.normal),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.normal),
    
  );

  static TextTheme darkTextTheme = TextTheme(
      headlineLarge: const TextStyle().copyWith(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.bold),
      headlineMedium: const TextStyle().copyWith(fontSize: 24.0, color: Colors.white, fontWeight: FontWeight.w600),
      headlineSmall: const TextStyle().copyWith(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.w600),

      titleLarge: const TextStyle().copyWith(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w600),
      titleMedium: const TextStyle().copyWith(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w500),
      titleSmall: const TextStyle().copyWith(fontSize: 16.0, color: Colors.white, fontWeight: FontWeight.w400),

      bodyLarge: const TextStyle().copyWith(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w500),
      bodyMedium: const TextStyle().copyWith(fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.normal),
      bodySmall: const TextStyle().copyWith(fontSize: 14.0, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.w500),

    labelLarge: const TextStyle().copyWith(fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.normal),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.normal),
  );
}
