import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/utils/constants/colors.dart';

class Cart_Page extends StatefulWidget {
  const Cart_Page({super.key});

  @override
  State<Cart_Page> createState() => _CartPageState();
}

class _CartPageState extends State<Cart_Page> {
  int _itemCount = 0;
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    color: TColors.bgLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Margherita pizza",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                    SizedBox(height: 3,),
                                    Text("Cheese Burst,Medium",style: Theme.of(context).textTheme.labelMedium,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                  ],
                                ),
                                SizedBox(width: 35,),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: TColors.black)
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (_itemCount > 0) _itemCount--;
                                          });
                                        },
                                        child: Container(
                                          // color: Colors.amber,
                                          padding: EdgeInsets.only(right: 10),
                                          child: Icon(Icons.remove, size: 14, color: Colors.black),
                                        ),
                                      ),
                                      Text(
                                        "$_itemCount",
                                        style: TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _itemCount++;
                                          });
                                        },
                                        child: Container(
                                          // color: Colors.amber,
                                          padding: EdgeInsets.only(left: 10),
                                          child: Icon(Icons.add, size: 14, color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text("₹200",style: Theme.of(context).textTheme.bodySmall,),
                              ],
                            )
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Margherita pizza",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 3,),
                                      Text("Cheese Burst,Medium",style: Theme.of(context).textTheme.labelMedium,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    ],
                                  ),
                                  SizedBox(width: 45,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: TColors.black)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_itemCount > 0) _itemCount--;
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.remove, size: 14, color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          "$_itemCount",
                                          style: TextStyle(color: Colors.black, fontSize: 12),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _itemCount++;
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(Icons.add, size: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("₹200",style: Theme.of(context).textTheme.bodySmall,),
                                ],
                              )
                          ),
                          Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Margherita pizza",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold),),
                                      SizedBox(height: 3,),
                                      Text("Cheese Burst,Medium",style: Theme.of(context).textTheme.labelMedium,overflow: TextOverflow.ellipsis,maxLines: 1,),
                                    ],
                                  ),
                                  SizedBox(width: 45,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: TColors.black)
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (_itemCount > 0) _itemCount--;
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(Icons.remove, size: 14, color: Colors.black),
                                          ),
                                        ),
                                        Text(
                                          "$_itemCount",
                                          style: TextStyle(color: Colors.black, fontSize: 12),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _itemCount++;
                                            });
                                          },
                                          child: Container(
                                            // color: Colors.amber,
                                            padding: EdgeInsets.only(left: 10),
                                            child: Icon(Icons.add, size: 14, color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 15,),
                                  Text("₹200",style: Theme.of(context).textTheme.bodySmall,),
                                ],
                              )
                          ),
                          SizedBox(height: 10,),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: TColors.darkGrey)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){},
                                    child: Text("Cooking requests",style: TextStyle(fontSize: 12,color: TColors.darkGrey),),
                                  ),
                                ),
                              ),
                              SizedBox(width: 5,),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: TColors.darkGrey)
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: (){},
                                    child: Text("+ Add more items",style: TextStyle(fontSize: 12,color: TColors.darkGrey),),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ),
                  SizedBox(height: 10,),
                  Card(
                    color: TColors.bgLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text("SAVINGS CORNER",style: TextStyle(fontSize: 12,color: TColors.darkGrey),),
                          SizedBox(height: 3,),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(Icons.local_offer,color: Colors.red,),
                            title: Text("Apply Coupon",style: TextStyle(fontSize: 13)),
                            trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
                            onTap: (){
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Card(
                    color: TColors.bgLight,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: Column(
                      children: [
                        ExpansionTile(
                          iconColor: TColors.black,
                          collapsedShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide.none
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide.none
                          ),
                          title: Row(
                            children: [
                              Icon(Icons.receipt_long,color: Colors.green,),
                              SizedBox(width: 10,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("To Pay ₹345",style: Theme.of(context).textTheme.bodyLarge,),
                                  Text("Incl. all taxes & charges",style: Theme.of(context).textTheme.labelMedium),
                                ],
                              ),
                            ],
                          ),
                          trailing: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down),
                          onExpansionChanged: (bool expanded) {
                            setState(() {
                              isExpanded = expanded;
                            });
                          },
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Divider(
                                    color: TColors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    Text("Item Total",style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 180,),
                                    Text("₹288",style: Theme.of(context).textTheme.labelLarge,),
                                  ],
                                ),
                                SizedBox(height: 6,),
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    Text("Delivery Fee | 6.0 kms",style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 90,),
                                    Text("₹33.00",style: Theme.of(context).textTheme.labelLarge,),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Divider(
                                    color: TColors.grey,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    Text("Delivery Tip",style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 160,),
                                    InkWell(onTap: (){},
                                      child: Text("Add tip",style: TextStyle(color: Colors.red),),)
                                  ],
                                ),
                                SizedBox(height: 10,),
                                Row(
                                  children: [
                                    SizedBox(width: 20,),
                                    Text("GST & Restaurant Charges",style: Theme.of(context).textTheme.bodySmall,),
                                    SizedBox(width: 60,),
                                    Text("₹15.84",style: Theme.of(context).textTheme.labelLarge,),
                                  ],
                                ),
                              ],
                            ),
                            // ListTile(
                            //   dense: true,
                            //   //contentPadding: EdgeInsets.zero,
                            //   title: Text("Item Total",style: Theme.of(context).textTheme.bodySmall,),
                            //   trailing: Text("₹288",style: Theme.of(context).textTheme.labelMedium,),
                            // ),
                            // ListTile(
                            //   dense: true,
                            //   //contentPadding: EdgeInsets.zero,
                            //   title: Text("Delivery Fee | 6.0 kms",style: Theme.of(context).textTheme.bodyMedium,),
                            //   trailing: Text("₹33.00",style: Theme.of(context).textTheme.labelMedium,),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Divider(
                            //     color: TColors.grey,
                            //   ),
                            // ),
                            // ListTile(
                            //   dense: true,
                            //   //contentPadding: EdgeInsets.zero,
                            //   title: Text("Platform Fee",style: Theme.of(context).textTheme.bodyMedium,),
                            //   trailing: Text("₹8.00",style: Theme.of(context).textTheme.labelMedium,),
                            // ),
                            // ListTile(
                            //   dense: true,
                            //   //contentPadding: EdgeInsets.zero,
                            //   title: Text("GST & Restaurant Charges",style: Theme.of(context).textTheme.bodyMedium,),
                            //   trailing: Text("₹15.84",style: Theme.of(context).textTheme.labelMedium,),
                            // ),
                            Divider(
                              color: TColors.grey,
                            ),
                            ListTile(
                              title: Text("To Pay",style: TextStyle(fontWeight: FontWeight.bold),),
                              trailing: Text("₹345",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: TColors.black)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 250,) /// for button adjustment remove
                ],
              ),
            ),
            Positioned(
              bottom: 10,
                left: 10,
                child: ZElevatedButton(title: "Place Order", onPress: (){}), )
          ],
        ),
      ),
    );
  }
}
