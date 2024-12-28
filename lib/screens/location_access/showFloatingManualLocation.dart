import 'package:flutter/material.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/media_query.dart';
import 'FloatingManualLocation.dart';

// Method to show bottom sheet
void showFloatingSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Makes the sheet floating
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        height: ZMediaQuery(context).height - 60,
        width: ZMediaQuery(context).width,
        decoration: BoxDecoration(
          color: ZMediaQuery(context).isDarkMode ? TColors.bgDark : TColors.bgLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 15.0), // Adjust as needed
          child: ManualLocation(),
        ),
      );
    },
  );
}