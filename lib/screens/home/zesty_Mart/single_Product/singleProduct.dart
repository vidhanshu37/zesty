import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/constants/colors.dart';

class Singleproduct extends StatefulWidget {
  final String id;
  const Singleproduct(
      {super.key,required this.id});

  @override
  State<Singleproduct> createState() => _SingleproductState();
}

class _SingleproductState extends State<Singleproduct> {
  int _currentIndex = 0;
  int _itemCount = 0;
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
      appBar: AppBar(
        title: Product != null ? Text(Product?['name']) : SizedBox.shrink(),
      ),
      body: imageUrl.isNotEmpty && Product != null ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: TColors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 1)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 300,
                            enlargeCenterPage: true,
                            viewportFraction: 0.9,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                          items: imageUrl.map((imagePath) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                imagePath,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            );
                          }).toList(),
                        ),
                        // Dot Indicator
                        Positioned(
                          bottom: 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: imageUrl.asMap().entries.map((entry) {
                              return Container(
                                width: _currentIndex == entry.key ? 10 : 8,
                                height: _currentIndex == entry.key ? 10 : 8,
                                margin: EdgeInsets.symmetric(horizontal: 3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? Colors.black
                                      : TColors.grey,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Divider(color: TColors.grey,),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(Product?['name'],style: Theme.of(context).textTheme.titleLarge,),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(Product?['weight'],style: TextStyle(fontSize: 13,color: TColors.darkGrey),),
                                    SizedBox(height: 3,),
                                    Text("₹${Product?['price']}",style: Theme.of(context).textTheme.bodyMedium,),
                                  ],
                                ),
                                _itemCount == 0
                                    ? GestureDetector(
                                  //onTap: _incrementItem,
                                  onTap: (){},
                                  child: Container(
                                    height: 35,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: TColors.darkGrey),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: TColors.darkerGrey,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                    : Container(
                                  height: 35,
                                  width: 100,
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: TColors.darkGreen),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        //onTap: _decrementItem,
                                        onTap: (){},
                                        child: Container(
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(
                                            Icons.remove,
                                            size: 16,
                                            color: TColors.darkGreen,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "$_itemCount",
                                        style: TextStyle(
                                          color: TColors.darkGreen,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      GestureDetector(
                                        //onTap: _incrementItem,
                                        onTap: (){},
                                        child: Container(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(
                                            Icons.add,
                                            size: 16,
                                            color: TColors.darkGreen,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: TColors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 1)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8,),
                    Text("Highlights",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Table(
                      border: TableBorder.symmetric(inside: BorderSide(width: 1,color: Colors.grey.shade300)),
                      columnWidths: {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                      },
                      children: [
                        tableRow("Box Contents","1x${Product?['name']}"),
                        tableRow("Pack Size",Product?['weight']),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: TColors.grey,
                          blurRadius: 2,
                          spreadRadius: 1,
                          offset: Offset(0, 1)
                      )
                    ]
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5,),
                    Text("Description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text(Product?['description'],style: TextStyle(fontSize: 14),),
                  ],
                ),
              )
            ],
          ),
        ),
      ) : Center(child: CircularProgressIndicator(color: TColors.black,),),
    );
  }
  TableRow tableRow(String title,String value){
    return TableRow(
      children:[
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(value),
        ),
      ]
    );
  }
}
