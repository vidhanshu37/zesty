import 'package:flutter/material.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/grocery_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/home_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
class Homecategory extends StatefulWidget {
  const Homecategory({super.key});

  @override
  State<Homecategory> createState() => _HomecategoryState();
}

class _HomecategoryState extends State<Homecategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        ),
        body: HomeTab()
    );
  }
}
