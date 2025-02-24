import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoryHome extends StatelessWidget {

  final String categoryImageId, categoryName;
  const CategoryHome({super.key, required this.categoryImageId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(categoryName),
      ),
    );
  }
}
