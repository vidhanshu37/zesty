import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:zesty/screens/home/bottom_navigation/rive_utils/rive_utils.dart';
import 'package:zesty/utils/constants/colors.dart';

import 'components/animatedBar.dart';
import 'models/riveAsstes.dart';

class BottomNavigation extends StatefulWidget {

  final bool isVisible;
  const BottomNavigation({super.key, required this.isVisible});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  RiveAssets selectBottomNav = bottomNavs.first;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: widget.isVisible ? 62.0 : 0.0,
        margin: EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
            color: TColors.darkerGrey,
            borderRadius: BorderRadius.all(Radius.circular(24.0)),
            boxShadow: [
              // BoxShadow(
              //     color: TColors.darkerGrey.withOpacity(0.3),
              //     offset: Offset(0, 20),
              //     blurRadius: 20)
            ]
        ),
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ...List.generate(
              bottomNavs.length,
                  (index) => GestureDetector(
                onTap: () {
                  if (bottomNavs[index] != selectBottomNav) {
                    setState(() {
                      selectBottomNav = bottomNavs[index];
                    });
                  }
      
                  bottomNavs[index].input!.change(true);
                  Future.delayed(const Duration(seconds: 1), () {
                    bottomNavs[index].input!.change(false);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: bottomNavs[index] == selectBottomNav,),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: bottomNavs[index] == selectBottomNav
                            ? 1
                            : 0.5,
                        child: RiveAnimation.asset(
                          bottomNavs.first.src, // src is same for all
                          artboard: bottomNavs[index].artboard,
                          onInit: (artboard) {
                            StateMachineController controller =
                            RiveUtils.getRiveController(artboard,
                                stateMachineController:
                                bottomNavs[index]
                                    .stateMachineName);
                            bottomNavs[index].input =
                            controller.findSMI("active") as SMIBool;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ))
        ]),
      ),
    );
  }
}


