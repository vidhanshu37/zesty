import 'package:flutter/material.dart';
import 'package:zesty/screens/location_access/locationAccess.dart';
import 'package:zesty/screens/login_process/signin.dart';
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
      title: 'Flutter Demo',
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      home: signin(),
    );
  }
}
