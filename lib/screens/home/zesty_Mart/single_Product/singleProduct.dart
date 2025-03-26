import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:zesty/screens/home/zesty_Mart/single_Product/addToCartButton.dart';
import 'package:zesty/screens/home/zesty_Mart/single_Product/tableRow.dart';

import '../../../../utils/constants/colors.dart';

class Singleproduct extends StatefulWidget {
  final String id;
  const Singleproduct(
      {super.key,required this.id});

  @override
  State<Singleproduct> createState() => _SingleproductState();
}

class _SingleproductState extends State<Singleproduct> {
  Map<String, dynamic>? Product;

  List imageUrl = [];


  Future<void> fetchData() async{
    final url = Uri.parse("https://zesty-backend.onrender.com/zestyMart/get/${widget.id}");

    try{
      final response = await http.get(url);
      if (response.statusCode == 200){
        setState(() {
          Product = jsonDecode(response.body);
          imageUrl = Product?['images'];
          print("success");
        });
      } else{
        print("Fail");
      }
    }catch (e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.bgLight,
      appBar: AppBar(
        backgroundColor: TColors.bgLight,
        title: Product != null ? Text(Product?['name'],style: TextStyle(color: TColors.black),) : SizedBox.shrink(),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: TColors.black,)),
      ),
      body: imageUrl.isNotEmpty && Product != null ?
       Addtocartbutton(
           imageUrl: imageUrl,
           name: Product?['name'],
           weight: Product?['weight'],
           price: Product?['price'],
           description: Product?['description'],
           itemId : widget.id,
       )
          : Center(child: Lottie.asset('assets/lottie/zestyMart_loader.json', height: 200, width: 200),),
    );
  }
}
