import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class categoryTab extends StatefulWidget {
  final String iconPath, title;

  const categoryTab({
    super.key,
    required this.iconPath,
    required this.title,
  });

  @override
  State<categoryTab> createState() => _categoryTabState();
}

class _categoryTabState extends State<categoryTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      text: widget.title,
      icon: Image.asset(
        widget.iconPath,
        height: 30,
        width: 30,
        fit: BoxFit.cover,
      ),
    );
  }
}
