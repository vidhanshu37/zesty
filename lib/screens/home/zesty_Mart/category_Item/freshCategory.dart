import 'package:flutter/material.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
class Freshcategory extends StatefulWidget {
  const Freshcategory({super.key});

  @override
  State<Freshcategory> createState() => _FreshcategoryState();
}

class _FreshcategoryState extends State<Freshcategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
      ),
      body: FreshTab()
    );
  }
}
