import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';

class TElevatedBtnTheme {
  TElevatedBtnTheme._();// to avoid creating instance

  static final lightElevatedBtnTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.bgLight,
      backgroundColor: TColors.buttonPrimaryLight,
      disabledBackgroundColor: TColors.buttonDisabled,
      disabledForegroundColor: TColors.buttonDisabled,
      side: const BorderSide(color: TColors.buttonPrimaryLight),
      padding: const EdgeInsets.symmetric(vertical: 17),
      textStyle: const TextStyle(fontSize: 16, color: TColors.bgLight, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
    ),
  );

  static final darkElevatedBtnTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: TColors.bgDark,
      backgroundColor: TColors.buttonPrimaryDark,
      disabledBackgroundColor: TColors.buttonDisabled,
      disabledForegroundColor: TColors.buttonDisabled,
      side: const BorderSide(color: TColors.buttonPrimaryDark),
      padding: const EdgeInsets.symmetric(vertical: 17),
      textStyle: const TextStyle(fontSize: 16,color: TColors.bgDark, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );
}