import 'package:flutter/material.dart';

import '../utils/constants/colors.dart';

class ZElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;
  final double height;
  final double width;
  final Color? bgColor;
  final Color? btnTextColor;

  const ZElevatedButton(
      {required this.title,
      required this.onPress,
      this.height = 50.0,
      this.width = double.infinity,
      this.bgColor,
      this.btnTextColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height,
        width: width,
        child: ElevatedButton(
            onPressed: onPress,
            child: Text(title),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: bgColor,
            foregroundColor: btnTextColor,
            side: BorderSide(color: bgColor ?? TColors.bgLight),
          ),
        )
    );
  }
}
