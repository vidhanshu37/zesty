import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

class ZCustomTextField extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconPressed;
  final VoidCallback? onButtonPressed;
  final bool hideText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final double borderRadius;
  final Color? prefixIconColor;
  final int? maxLength;

  const ZCustomTextField(
      {this.onButtonPressed,
      required this.controller,
      required this.hintText,
      this.labelText,
      this.prefixIcon,
      this.suffixIcon,
      this.onSuffixIconPressed,
      this.hideText = false,
      this.keyboardType,
      this.onChanged,
      this.validator,
      this.borderRadius = 8.0,
      this.prefixIconColor,
      this.maxLength});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: hideText,
      onTap: onButtonPressed,
      onChanged: onChanged,
      validator: validator,
      maxLength: maxLength,
      cursorColor: TColors.black ,
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 12),

        counterText: "",
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: prefixIconColor,
              )
            : null,
        suffixIcon: suffixIcon != null ? Icon(suffixIcon) : null,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              width: 5,
            )),
        contentPadding: EdgeInsets.symmetric(
          vertical: 17.0, // Adjust height here
          horizontal: 12.0, // Adjust horizontal padding
        ),
      ),
    );
  }
}
