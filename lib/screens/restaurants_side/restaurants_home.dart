import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../utils/local_storage/HiveOpenBox.dart';
import '../home/item_cart/cart_page.dart';
import '../home/restaurantSingleItemCard.dart';
import 'custom_widget/mart_itemCard.dart';

class RestaurantsHome extends StatefulWidget {
  final String id;

  const RestaurantsHome({super.key, required this.id});

  @override
  State<RestaurantsHome> createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> {
  final TextEditingController searchbarController = TextEditingController();
  // int _currentIndex = 0;
  Map<String, dynamic>? restaurantData;
  final List<String> _coupons = [
    "Extra ₹75 off",
    "Flat 10% off above ₹500",
    "Free Delivery on orders ₹199+",
    "Buy 1 Get 1 Free",
    "Save ₹50 on your first order",
  ];

  List allMenuItem = [];

  double distanceRestaurantKm = 0;
  double lat = 0;
  double long = 0;

  var box = Hive.box(HiveOpenBox.zestyFoodCart);

  int countCartTotal() {
    int totalAge = box.values.fold(0, (sum, item) {
      if (item is Map<String, dynamic> && item.containsKey('age')) {
        return sum + (item['age'] as int);
      }
      return sum;
    });
    return 0;
  }

  @override
  void initState() {
    super.initState();
    retriveData();
    getRestaurantData(widget.id); //fetch data of restaurant
  }

  Future<void> getRestaurantData(String id) async {
    final url = Uri.parse(ApiConstants.getSingleRestaurantData(id));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        restaurantData = jsonDecode(response.body);
        allMenuItem = restaurantData?['menu'];
        // print("Success");
        setState(() {});
      } else {
        // print("Fail");
      }
    } catch (e) {
      // print(e);
    }
  }

  void updateCartState() {
    setState(() {});
  }

  void retriveData() {
    var hiveBox = Hive.box("zestyBox");
    lat = hiveBox.get("latitude", defaultValue: 21.2049);
    long = hiveBox.get("longitude", defaultValue: 72.8411);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.5),
      ),
      body: restaurantData == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              /// Main content
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Root restaurant card
                        Container(
                          width: double.infinity,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(22),
                                bottomRight: Radius.circular(22)),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(17),
                              ),
                              elevation: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: Colors.green,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Pure Veg",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      restaurantData?['restaurantName'] ?? "Zesty",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineLarge,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "15-20 mins • ${ApiConstants.calculateDistance(lat, long, restaurantData?['latitude'] ?? 21.70, restaurantData?['longitude'] ?? 71.12).toStringAsFixed(1)}km • Katargam",
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      'description line',
                                      style: TextStyle(
                                        color: TColors.darkGrey,
                                        fontSize: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 7,
                        ),

                        /// Searchbar
                        Padding(
                          padding: const EdgeInsets.all(13.0),
                          child: SearchBarHome(
                              searchController: searchbarController),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),

                  /// Item card - menu
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return ItemCard(
                          itemName: allMenuItem[index]['name'] ?? "Zesty",
                          itemDescription: allMenuItem[index]['description'] ?? "Zesty description",
                          itemPrice: allMenuItem[index]['price'] ?? "100",
                          itemImageId: allMenuItem[index]['_id'] ?? "",
                          updateCartState: updateCartState,
                          restaurantId: restaurantData!['_id'],
                          restaurantName: restaurantData!['restaurantName'],
                          itemImageUrl: allMenuItem[index]['image'],
                        );
                      },
                      childCount: allMenuItem.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 300,
                    ),
                  )
                ],
              ),

              /// Bottom cart button
                box.isNotEmpty ? Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 110,
                    width: constraints.maxWidth, // Use constraints from LayoutBuilder
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
                        width: constraints.maxWidth - 40, // Use constraints from LayoutBuilder
                        child: ElevatedButton(
                          onPressed: () {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.toMap().toString())));
                            if(box.isNotEmpty) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CartPage()));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.black,
                            side: BorderSide(color: TColors.black, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total item - ${box.values
                                  .map((order) => order['qty'] as int) // Extract 'qty' from each item
                                  .fold(0, (sum, qty) => sum + qty)}"), // Sum all quantities
                              Text("View cart")
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ) : SizedBox.shrink(),
            ],
          );
        },
      ),
    );
  }
}