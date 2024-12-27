import 'package:flutter/cupertino.dart';

class ZMediaQuery {
  final BuildContext context;

  ZMediaQuery(this.context);

  /// Returns whether the device is in dark mode
  bool get isDarkMode {
    final brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  /// Return screen's height and width
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
}