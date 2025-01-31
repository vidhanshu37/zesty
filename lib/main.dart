import 'package:flutter/material.dart';
import 'package:zesty/screens/home/bottom_navigation/bottomNavigation.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/screens/home/rough.dart';
import 'package:zesty/screens/location_access/locationAccess.dart';
import 'package:zesty/screens/location_access/shimmerEffect.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/screens/onboarding/onBoardingScreen.dart';
import 'package:zesty/utils/theme/theme.dart';

import 'myHomePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: LocationAccess(),
    );
  }
}
