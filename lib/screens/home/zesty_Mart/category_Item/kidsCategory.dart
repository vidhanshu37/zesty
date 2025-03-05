import 'package:flutter/material.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/grocery_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/kids_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
class Kidscategory extends StatefulWidget {
  const Kidscategory({super.key});

  @override
  State<Kidscategory> createState() => _KidscategoryState();
}

class _KidscategoryState extends State<Kidscategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        ),
        body: KidsTab()
    );
  }
}
