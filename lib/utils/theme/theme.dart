import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/theme/custom_themes/appBar_theme.dart';
import 'package:zesty/utils/theme/custom_themes/outlineButton_theme.dart';
import 'package:zesty/utils/theme/custom_themes/text_theme.dart';
import 'package:zesty/utils/theme/custom_themes/textfield_theme.dart';
import 'package:flutter/material.dart';

import 'custom_themes/elevated_btn_theme.dart';
import 'custom_themes/outlineButton_theme.dart';
import 'custom_themes/text_theme.dart';
import 'custom_themes/textfield_theme.dart';

class TAppTheme {
  // TAppTheme._();

  static ThemeData lightTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'poppins',
      brightness: Brightness.light,
      primaryColor: Colors.black,
      scaffoldBackgroundColor: TColors.bgLight,
      textTheme: TTextTheme.lightTextTheme,
      elevatedButtonTheme: TElevatedBtnTheme.lightElevatedBtnTheme,
      outlinedButtonTheme: ToutlinedButtonTheme.lightOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.lightInputDecorationTheme,
      // appBarTheme: TAppBarTheme.LightAppBarTheme
    );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      fontFamily: 'poppins',
      brightness: Brightness.dark,
      primaryColor: Colors.white,
      scaffoldBackgroundColor: TColors.bgDark,
      textTheme: TTextTheme.darkTextTheme,
      elevatedButtonTheme: TElevatedBtnTheme.darkElevatedBtnTheme,
      outlinedButtonTheme: ToutlinedButtonTheme.darkOutlinedButtonTheme,
      inputDecorationTheme: TTextFormFieldTheme.darkInputDecorationTheme,
      // appBarTheme: TAppBarTheme.darkAppBarTheme,
  );
}
