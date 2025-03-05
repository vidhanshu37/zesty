import 'package:flutter/material.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/grocery_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
class Grocerycategory extends StatefulWidget {
  const Grocerycategory({super.key});

  @override
  State<Grocerycategory> createState() => _GrocerycategoryState();
}

class _GrocerycategoryState extends State<Grocerycategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        ),
        body: GroceryTab()
    );
  }
}
