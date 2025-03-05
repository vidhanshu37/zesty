import 'package:flutter/material.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/electronics_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/grocery_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
class Electroniccategory extends StatefulWidget {
  const Electroniccategory({super.key});

  @override
  State<Electroniccategory> createState() => _ElectroniccategoryState();
}

class _ElectroniccategoryState extends State<Electroniccategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back,color: Colors.black,)),
        ),
        body: ElectronicsTab()
    );
  }
}
