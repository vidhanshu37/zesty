import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zesty/screens/home/zesty_Mart/single_Product/tableRow.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../../../utils/constants/colors.dart';
import '../zestyMartCart.dart';
class Addtocartbutton extends StatefulWidget {
  final List imageUrl;
  final String name;
  final String weight;
  final String price;
  final String itemId;
  final String description;

  const Addtocartbutton({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.weight,
    required this.price,
    required this.description,
    required this.itemId,
  });

  @override
  State<Addtocartbutton> createState() => _AddtocartbuttonState();
}

class _AddtocartbuttonState extends State<Addtocartbutton> {
  int currentIndex = 0;
  int itemCount = 0;

  var box = Hive.box(HiveOpenBox.storeZestyMartItem);

  // box.isEmoty ? Sizedbox.shrink :  cart button

  void _retrieveCartData() {
    var allKeys = box.keys.toList();
    bool temp = allKeys.any((key) {
      if (key == widget.itemId) {
        // var data = box.get(key);
        itemCount = box.get(key);
        return true;
      } else {
        return false;
      }
    });
  }

  void storeZestyMartData(int quantity, String id) {
    if(quantity == 0) {
      box.delete(id);
      print("delete trigger");
    } else{
      box.put(id, quantity);
    }
    // box.clear();
  }

  @override
  void initState() {
    super.initState();
    _retrieveCartData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _retrieveCartData();
  }

  @override
  Widget build(BuildContext context) {
    return  ValueListenableBuilder(
        valueListenable: Hive.box(HiveOpenBox.storeZestyMartItem).listenable(),
        builder: (_, Box box, __) {
          var allKeys = box.keys.toList();
          bool temp = allKeys.any((key) {
            if (key == widget.itemId) {
              // var data = box.get(key);
              itemCount = box.get(key);
              return true;
            } else {
              return false;
            }
          });
          return Stack(
            children: [
              SingleChildScrollView(
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
                                        currentIndex = index;
                                      });
                                    },
                                  ),
                                  items: widget.imageUrl.map((imagePath) {
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
                                    children: widget.imageUrl.asMap().entries.map((entry) {
                                      return Container(
                                        width: currentIndex == entry.key ? 10 : 8,
                                        height: currentIndex == entry.key ? 10 : 8,
                                        margin: EdgeInsets.symmetric(horizontal: 3),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: currentIndex == entry.key
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
                                  Text(widget.name,style: TextStyle(fontSize: 17,color: TColors.black,fontWeight: FontWeight.bold),),
                                  SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.weight,style: TextStyle(fontSize: 13,color: TColors.darkGrey),),
                                          SizedBox(height: 3,),
                                          Text("₹${widget.price}",style: TextStyle().copyWith(fontSize: 15.0, color: TColors.black,fontWeight: FontWeight.bold)),
                                        ],
                                      ),

                                      /// Add to cart button
                                      itemCount == 0
                                          ? GestureDetector(
                                        onTap: (){
                                          itemCount++;
                                          storeZestyMartData(itemCount,widget.itemId);
                                          print("CART VALUE : ${box.keys.toString()} and ${box.values.toString()}");
                                          print(box!.toMap().entries
                                              .map((entry) => "${entry.key}: ${entry.value}")
                                              .join("\n"));
                                          setState(() {

                                          });
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 100,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              border: Border.all(color: TColors.grey),
                                              boxShadow:[ BoxShadow(
                                                  color: TColors.grey,
                                                  spreadRadius: 1,
                                                  blurRadius: 1
                                              )]
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
                                              onTap: (){
                                                if (itemCount > 0) {
                                                  itemCount--;
                                                  storeZestyMartData(itemCount,widget.itemId);
                                                  print("CART VALUE : ${box.keys.toString()} and ${box.values.toString()}");
                                                  setState(() {
                                                  });
                                                }
                                              },
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
                                              "$itemCount",
                                              style: TextStyle(
                                                color: TColors.darkGreen,
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                itemCount++;
                                                storeZestyMartData(itemCount,widget.itemId);
                                                print("CART VALUE : ${box.keys.toString()} and ${box.values.toString()}");
                                                setState(() {

                                                });

                                              },
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
                            Text("Highlights",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: TColors.black),),
                            SizedBox(height: 10,),
                            Table(
                              border: TableBorder.symmetric(inside: BorderSide(width: 1,color: Colors.grey.shade300)),
                              columnWidths: {
                                0: FlexColumnWidth(1),
                                1: FlexColumnWidth(2),
                              },
                              children: [
                                tableRow("Box Contents","1x${widget.name}"),
                                tableRow("Pack Size",widget.weight),
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
                            Text("Description",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: TColors.black),),
                            SizedBox(height: 20,),
                            Text(widget.description,style: TextStyle(fontSize: 14,color: TColors.black),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 110,
                      )
                    ],
                  ),
                ),
              ),
              /// Bottom cart button
              box.isNotEmpty ? Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 110,
                  width: double.infinity, // Use constraints from LayoutBuilder
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    color: TColors.bgLight,
                    boxShadow: [
                      BoxShadow(
                        color: TColors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: SizedBox(
                      height: 60,
                      width: double.infinity, // Use constraints from LayoutBuilder
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.toMap().toString())));
                            if(box.isNotEmpty) {
                              Navigator.push(context, MaterialPageRoute(builder: (builder) => Zestymartcart()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.black,
                            side: BorderSide(color: TColors.black, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Sum all quantities
                              Text("Total item: ${ box!.values
                                  .whereType<num>() // Ensure only numbers are considered
                                  .fold<int>(0, (prev, element) => prev + element.toInt()) }"),
                              Text("View cart")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ) : SizedBox.shrink(),
            ],
          );
        },
    );


  }
}
