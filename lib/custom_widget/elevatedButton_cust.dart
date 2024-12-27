import 'package:flutter/material.dart';

class ZElevatedButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPress;

  const ZElevatedButton({required this.title, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        width: double.infinity,
        child: ElevatedButton(onPressed: onPress, child: Text(title)));
  }
}
