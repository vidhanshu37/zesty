import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/item_cart/cartPayment.dart';
import 'package:zesty/screens/home/zesty_Mart/zestyMart_payment.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import '../item_cart/cart_page.dart';

class Zestymartcart extends StatefulWidget {
  const Zestymartcart({super.key});

  @override
  State<Zestymartcart> createState() => _ZestymartcartState();
}

class _ZestymartcartState extends State<Zestymartcart> {
  bool isExpanded = false;
  /// create hive object for access address
  var boxAddress = Hive.box(HiveOpenBox.storeAddress);

  /// create hive object for access ZestyMart item
  var box = Hive.box(HiveOpenBox.storeZestyMartItem);


  /// fetch cart data
  List<Map<String, dynamic>> fetchedZestyMartItem = []; // Temporary list to store data
  Future<void> fetchCartData() async {
    for(var id in box.keys) {
      final url = Uri.parse("https://zesty-backend.onrender.com/zestyMart/get/$id");

      try {
        final response = await http.get(url);

        if(response.statusCode == 200) {
          var restaurantData = jsonDecode(response.body);
          fetchedZestyMartItem.add(restaurantData);
          print("successsssssssssssss");
          setState(() {

          });
        } else {
          print("error code  : ${response.statusCode}");
        }
      } catch(e) {
        print(e);
      }
    }
  }
  /// End fetch cart data

  List? quantityMartItem;
  // List to track counters for each item
  late List<int> counters;

  void incrementCounter(int index) {
    setState(() {
      counters[index]++;
      manageMartCart(counters);
    });
  }

  void decrementCounter(int index) {
    if(counters[index] > 0) {
      setState(() {
        counters[index]--;
        manageMartCart(counters);
      });
    }
    countTotalCartZeroOrNot();
  }

  void manageMartCart(List newQty) {
    if(box.isEmpty) return; // item is empty

    List allKeys = box.keys.toList();

    for(int i=0; i<allKeys.length; i++) {

      if(newQty[i] == 0) {
        box.delete(allKeys[i]);
      } else {
        box.put(allKeys[i], newQty[i]);
      }

    }
  }

  /// if cart was empty then return to home
  void countTotalCartZeroOrNot() {
    int sumOfCart = counters.fold(0, (previous, element) => previous + element);
    if(sumOfCart == 0) {
      Navigator.pop(context);
    }
  }

  /// Count delivery fees
  var distanceKm;
  String countDeliveryCharge() {
    distanceKm = ApiConstants.calculateDistance(double.parse(boxAddress.get(HiveOpenBox.storeAddressLat)), double.parse(boxAddress.get(HiveOpenBox.storeAddressLong)), 21.2049, 72.8411);
      if (distanceKm > 0 && distanceKm < 2) {
        return "19";
      } else if (distanceKm >= 2 && distanceKm < 5) {
        return "39";
      } else {
        return (distanceKm * 10).toStringAsFixed(2);
      }
  }

  /// count cart total
  int calculateCartTotal() {
    int cartTotal = 0;

    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
    for(int i=0; i<fetchedZestyMartItem.length; i++) {
      int price = int.parse(fetchedZestyMartItem[i]['price'].toString());
      int qty = counters[i];
      cartTotal += price * qty;
    }
    // setState(() {
    //
    // });
    return cartTotal;
  }

  @override
  void initState() {
    super.initState();
    fetchCartData();
    quantityMartItem = box.values.toList();
    countDeliveryCharge();
    calculateCartTotal();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (box.isNotEmpty && quantityMartItem!.length >= box.length) {
        counters = List.generate(box.length, (index) => quantityMartItem![index] ?? 1);
      } else {
        counters = List.generate(box.length, (index) => 1); // Default all to 1 if empty
      }
      setState(() {}); // Ensure UI updates after list is initialized
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Ordering from, ", style: Theme.of(context).textTheme.labelMedium,),
            Text("ZestyMart", style: Theme.of(context).textTheme.bodyLarge,)
          ],
        ),
      ),
      body: fetchedZestyMartItem.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.black,)) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              /// Delivery Address
              Card(
                color: TColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: ListTile(
                    leading: Icon(Icons.location_on_rounded),
                    title: Text("Delivery Address", style: Theme.of(context).textTheme.bodyLarge,),
                    subtitle: Text("${boxAddress.get(HiveOpenBox.storeAddressTitle)}", style: Theme.of(context).textTheme.labelMedium, maxLines: 1,),
                  ),
                ),
              ),

              /// zestyMart item card
              Card(
                color: TColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          /// Add more item button
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "+ Add more items",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: TColors.darkGreen),
                            ),
                          ),
                        ],
                      ),
                      /// ZestyMart Item list
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: fetchedZestyMartItem.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                        return cartPageItemDisplay(quantity: quantityMartItem![index], counter: counters[index], itemName: fetchedZestyMartItem[index]['name'], varientOrDescription: fetchedZestyMartItem[index]['description'] ?? 'na',
                            onDecrement: () => decrementCounter(index), onIncrement: () => incrementCounter(index),
                            price: fetchedZestyMartItem[index]['price'] ?? '10');
                      }),
                    ],
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              /// To pay card
              Card(
                color: TColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                // elevation: 2,
                child: Column(
                  children: [
                    ExpansionTile(
                      iconColor: TColors.black,
                      collapsedShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide.none),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          boxAddress.get(HiveOpenBox.userZestyLite) == "true" && distanceKm < 7 ? Text(
                            "To Pay ₹${(calculateCartTotal()  + (calculateCartTotal() * 0.05)).round()}",
                            // "To Pay ₹${(double.parse(calculateTotalCartValue().toStringAsFixed(2)) + double.parse(calculateDeliveryCharge().toStringAsFixed(2)) + packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                            //     .fold(0.0, (sum, element) => sum + element) + calculateTotalCartValue() * 0.05).toStringAsFixed(2)}",

                            style:
                            Theme.of(context).textTheme.bodyLarge,
                          ) : Text(
                            "To Pay ₹${(calculateCartTotal() + double.parse(countDeliveryCharge()) + (calculateCartTotal() * 0.05)).round()}",
                            // "To Pay ₹${(double.parse(calculateTotalCartValue().toStringAsFixed(2)) + double.parse(calculateDeliveryCharge().toStringAsFixed(2)) + packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                            //     .fold(0.0, (sum, element) => sum + element) + calculateTotalCartValue() * 0.05).toStringAsFixed(2)}",

                            style:
                            Theme.of(context).textTheme.bodyLarge,
                          ),
                          Text("Incl. all taxes & charges",
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium),
                        ],
                      ),
                      trailing: Icon(isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down),
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


                            /// Item total - price
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Item Total",
                                    style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500),
                                  ),
                                  Text("₹${calculateCartTotal()}",
                                    // "₹${calculateTotalCartValue().toStringAsFixed(2)}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),

                            /// Delivery fees - price
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Delivery Fee | "
                                        "${distanceKm.toStringAsFixed(2)}"
                                        "km",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                  boxAddress.get(HiveOpenBox.userZestyLite) == "true" && distanceKm < 7 ? Row(
                                    children: [
                                      Text(
                                        "₹"+countDeliveryCharge(),
                                        // "${calculateDeliveryCharge().toStringAsFixed(2)}"
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!.copyWith(decoration: TextDecoration.lineThrough),
                                      ),
                                      SizedBox(width: 8,),
                                      Text("Free", style: Theme.of(context)
                                          .textTheme
                                          .labelLarge?.copyWith(color: TColors.darkGreen, fontWeight: FontWeight.bold),)
                                    ],
                                  ) :  Text(
                                    "₹"+countDeliveryCharge(),
                                    // "${calculateDeliveryCharge().toStringAsFixed(2)}"
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ) ,
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Divider(
                                color: TColors.grey,
                              ),
                            ),

                            // /// Delivery tips
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Text(
                            //         "Delivery Tip",
                            //         style: Theme.of(context)
                            //             .textTheme
                            //             .bodySmall,
                            //       ),
                            //
                            //       InkWell(
                            //         onTap: () {},
                            //         child: Text(
                            //           "Add tip",
                            //           style: TextStyle(color: Colors.red),
                            //         ),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            // SizedBox(
                            //   height: 10,
                            // ),

                            /// GST charge
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "GST & Others Charges",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                  Text(
                                    "₹${(calculateCartTotal() * 0.05).toStringAsFixed(2)}",
                                        // "${(calculateTotalCartValue() * 0.05).toStringAsFixed(2)}", // Sum all elements}",
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge,
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                        // ListTile(
                        //   dense: true,
                        //   //contentPadding: EdgeInsets.zero,
                        //   title: Text(
                        //     "Item Total",
                        //     style: Theme.of(context).textTheme.bodySmall,
                        //   ),
                        //   trailing: Text(
                        //     "₹288",
                        //     style:
                        //     Theme.of(context).textTheme.labelMedium,
                        //   ),
                        // ),
                        // ListTile(
                        //   dense: true,
                        //   //contentPadding: EdgeInsets.zero,
                        //   title: Text(
                        //     "Delivery Fee | 6.0 kms",
                        //     style: Theme.of(context).textTheme.bodyMedium,
                        //   ),
                        //   trailing: Text(
                        //     "₹33.00",
                        //     style:
                        //     Theme.of(context).textTheme.labelMedium,
                        //   ),
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
                        //   title: Text(
                        //     "Platform Fee",
                        //     style: Theme.of(context).textTheme.bodyMedium,
                        //   ),
                        //   trailing: Text(
                        //     "₹8.00",
                        //     style:
                        //     Theme.of(context).textTheme.labelMedium,
                        //   ),
                        // ),
                        // ListTile(
                        //   dense: true,
                        //   //contentPadding: EdgeInsets.zero,
                        //   title: Text(
                        //     "GST & Restaurant Charges",
                        //     style: Theme.of(context).textTheme.bodyMedium,
                        //   ),
                        //   trailing: Text(
                        //     "₹15.84",
                        //     style:
                        //     Theme.of(context).textTheme.labelMedium,
                        //   ),
                        // ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            color: TColors.grey,
                          ),
                        ),

                        /// to pay last
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "To Pay",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),
                              boxAddress.get(HiveOpenBox.userZestyLite) == "true" && distanceKm < 7 ? Text(
                                "₹${(calculateCartTotal() + (calculateCartTotal() * 0.05)).round()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ) : Text(
                                "₹${(calculateCartTotal() + double.parse(countDeliveryCharge()) + (calculateCartTotal() * 0.05)).round()}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge,
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20,),

              ZElevatedButton(title: "Make Payment", onPress: () {
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.keys.toString())));
                boxAddress.get(HiveOpenBox.userZestyLite) == "true" && distanceKm < 7 ?
                Navigator.push(context, MaterialPageRoute(builder: (builder) => ZestyMartPayment(totalPrice: (calculateCartTotal() + (calculateCartTotal() * 0.05)).round().toString())))
               : Navigator.push(context, MaterialPageRoute(builder: (builder) => ZestyMartPayment(totalPrice: (calculateCartTotal() + double.parse(countDeliveryCharge()) + (calculateCartTotal() * 0.05)).round().toString())))

                ;
              })

            ],
          ),
        ),
      ),
    );
  }
}

