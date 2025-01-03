import 'dart:ui';
import 'package:flutter/material.dart';

class TColors {
  TColors._();

// App Basic Colors
  static const Color primary = Color(0xFF030401);
  static const Color secondary = Color(0xFF676A6C);
  // static const Color accent = Color(0xFFb0c7ff);

  static const Color ligthGreen = Color(0xffCAE97C);

// Gradient color [example]
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
    Colors.white,
    Colors.black,
  ]);

// Text Colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C7570);
  static const Color textWhite = Colors.white;

//   prefix and suffix icon color
  static const Color prefixLight = Color(0xff474647);
  static const Color prefixDark = Color(0xff9D9C9C);


// Background Colors
  static const Color bgLight = Color(0xFFFCF8F3);
  static const Color bgDark = Color(0xFF161617);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  // Background Container Colors
  static const Color lightContainer = Color (0xFFF6F6F6);
  static Color darkContainer = TColors.white.withOpacity(0.1);

// Button Colors
  static const Color buttonPrimaryLight = Color (0xFF030401);
  static const Color buttonPrimaryDark = Color (0xFFFCF8F3);
  static const Color buttonSecondary = Color (0xFF6C757D);
  static const Color buttonDisabled = Color (0xFFC4C4C4);

// Border Colors
//   static const Color borderPrimary = Color (0xFFD9D909);
//   static const Color borderSecondary = Color (0xFFE6E6E6);

// Error and Validation Colors
  static const Color error = Color (0xFFD32F2F);
  static const Color success = Color (0xFF388E3C);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color (0xFF1976D2);

  // Neutral Shades
  static const Color black = Color (0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color shimmerGrey = Color(0xFFBFBFBF);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
  static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color (0xFFFFFFFF);

}


