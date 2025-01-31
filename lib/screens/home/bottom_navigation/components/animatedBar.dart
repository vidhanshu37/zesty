import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

class AnimatedBar extends StatelessWidget {
  const AnimatedBar({
    super.key,
    required this.isActive,
  });

  // final RiveAssets selectBottomNav;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      margin: EdgeInsets.only(bottom: 2.0),
      height: 4,
      width: isActive ? 20 : 0,
      decoration: BoxDecoration(
          color: TColors.ligthGreen,
          borderRadius: BorderRadius.all(Radius.circular(12.0))
      ),
    );
  }
}
