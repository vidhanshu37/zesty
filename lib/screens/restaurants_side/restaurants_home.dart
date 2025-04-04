import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/screens/home/user_profile/add_balance.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;

import '../../myHomePage.dart';
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
  Map<String, dynamic>? restaurantData;



  List allMenuItem = [];
  List filteredItemDetails = [];

  double distanceRestaurantKm = 0;
  double lat = 0;
  double long = 0;

  var box = Hive.box(HiveOpenBox.zestyFoodCart);


  @override
  void initState() {
    super.initState();
    retriveData();
    getRestaurantData(widget.id); //fetch data of restaurant
  }

  List allCategory = [];
  void getAllCategory() {
    allCategory = allMenuItem.map((item) => item['category']).toSet().toList();
    allCategory.insert(0, "All");
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
        getAllCategory();
        selectCategoryData();
      } else {
        // print("Fail");
      }
    } catch (e) {
      // print(e);
    }
  }

  void filterSearchResult(String query){
    if (query.isEmpty){
      filteredItemDetails = allMenuItem;
    } else {
      setState(() {
        filteredItemDetails = allMenuItem.where((item) {
          String itemName = item['name'].toString().toLowerCase();
          return itemName.contains(query.toLowerCase());
        },).toList();
      });
    }
  }

  String nameSelectCategory = "All";

  void selectCategoryData() {
      if (nameSelectCategory == "All") {
      setState(() {
        filteredItemDetails = allMenuItem.toList();
      });
    } else {
      setState(() {
        filteredItemDetails = allMenuItem.where((item) {
          String categoryName = item['category'].toString();
          return categoryName.contains(nameSelectCategory);
        }).toList();
      });
    }

  }

  void updateCartState() {
    setState(() {});
  }

  void retriveData() {
    var hiveBox = Hive.box(HiveOpenBox.storeAddress);
    lat = double.parse(hiveBox.get(HiveOpenBox.storeAddressLat, defaultValue: "21.2049"));
    long = double.parse(hiveBox.get(HiveOpenBox.storeAddressLong, defaultValue: "72.8411"));
  }


  String countDeliveryTime(){
    double distance = ApiConstants.calculateDistance(lat, long, restaurantData?['latitude'] ?? 21.70, restaurantData?['longitude'] ?? 71.12);
    if (distance < 3) {
      return "15-20 mins";
    } else if (distance >= 3 && distance < 5) {
      return "20-25 mins";
    } else if (distance >= 5 && distance < 7) {
      return "30-35 mins";
    } else {
      return "45-50 mins";
    }
  }


  void _showFloatingMenu(BuildContext context) async {
       nameSelectCategory = await Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => FloatingMenuScreen(categoryItems: allCategory.toList(), bottom: box.isEmpty ? 20 : 100 ),
    ));
       selectCategoryData();
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });

    return Scaffold(
      backgroundColor: restaurantData == null ? Color(0xfffefefe) : TColors.bgLight,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.5),
      ),
      body: restaurantData == null
          ? Center(
        child: Card(
          color: Color(0xfffefefe),
          elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset('assets/images/bike_loader.gif', height: 120, width: 120, fit: BoxFit.cover,),
            )),
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
                          // height: 200,
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
                                      height: 20,
                                    ),
                                    restaurantData?['veg'] == 'veg' ? Row(
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
                                    ) : SizedBox(height:0,),

                                    SizedBox(
                                      height: 10,
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
                                      countDeliveryTime() + " • ${ApiConstants.calculateDistance(lat, long, restaurantData?['latitude'] ?? 21.2049, restaurantData?['longitude'] ?? 72.8411).toStringAsFixed(1)}km • ${restaurantData?['selectedArea']}",
                                      style: TextStyle(fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(restaurantData?['cuisines'] ?? "(Burger, Pizza, Fast Food)", style: Theme.of(context).textTheme.labelMedium,),
                                    SizedBox(
                                      height: 10,
                                    )
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
                            onChange: filterSearchResult,
                              searchController: searchbarController),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),

                 /// Search the item
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final itemList = filteredItemDetails;
                        return ItemCard(
                          itemName: itemList[index]['name'] ?? "Zesty",
                          itemDescription: itemList[index]['description'] ?? "Zesty description",
                          itemPrice: (double.parse(itemList[index]['price']).roundToDouble()).toStringAsFixed(0) ?? "100",
                          itemImageId: itemList[index]['_id'] ?? "",
                          updateCartState: updateCartState,
                          restaurantId: restaurantData!['_id'],
                          restaurantName: restaurantData!['restaurantName'],
                          itemImageUrl: itemList[index]['image'],
                          foodType: itemList[index]['foodType'],
                        );
                      },
                      childCount: filteredItemDetails.length,
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: searchbarController.text.isNotEmpty && filteredItemDetails.length == 0 ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                      child: Text('No results found for "${searchbarController.text}"', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),),
                    ) : SizedBox.shrink() ,
                  ),


                  /// Shop Address & disclaimer & FSSAI license no.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        height: 500,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Disclaimer:", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),),
                            SizedBox(height: 10,),
                            noteItem(text: "All prices are set direct by the restaurant.", fontSize: 13, fontColor: TColors.darkerGrey,),
                            SizedBox(height: 3,),
                            noteItem(text: "All nutritional information is indicative, values are per serve as shared by the restaurant and may vary depending on the ingredients and portion size.", fontSize: 13, fontColor: TColors.darkerGrey,),
                            SizedBox(height: 3,),
                            noteItem(text: "An average active adult requires 2,000 kcal energy per day, however, calorie needs may vary.", fontSize: 13, fontColor: TColors.darkerGrey,),
                            SizedBox(height: 3,),
                            noteItem(text: "Dish details might be AI crafted for a better experience.", fontSize: 13, fontColor: TColors.darkerGrey,),
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Divider(color: TColors.grey,),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(restaurantData?["restaurantName"], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                  SizedBox(height: 6,),
                                  Row(
                                    children: [
                                      Icon(Icons.location_on_rounded, size: 14,),
                                      SizedBox(width: 10,),
                                      Expanded(child: Text("Shop number ${restaurantData?['shopNumber']}, ${restaurantData?['selectedArea']}, ${restaurantData?['city']}, ${restaurantData?['state']}, ${restaurantData?['pincode']}", style: TextStyle(fontSize: 12, color: TColors.darkerGrey,),maxLines: 3,overflow: TextOverflow.ellipsis,)),
                                    ],
                                  )
                                ],
                              ),
                              
                            )

                          ],
                        ),
                      ),
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
                        width: constraints.maxWidth - 40, // Use constraints from LayoutBuilder
                        child: ElevatedButton(
                          onPressed: () {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(nameSelectCategory)));
                            if(box.isNotEmpty) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => CartPage(deliveryTime: countDeliveryTime())));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.black,
                            side: BorderSide(color: TColors.black, width: 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
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

      floatingActionButton: restaurantData == null ? SizedBox.shrink() : Stack(
        children: [
          Positioned(
            bottom: box.isNotEmpty ? 100 : 20 ,
            right: 20,
            child: SizedBox(
              height: 75,
              width: 75,
              child: FloatingActionButton(onPressed: (){
                _showFloatingMenu(context);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(nameSelectCategory)));
              },
              elevation: 5.0,
                shape: CircleBorder(),
              backgroundColor: Colors.black,
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note_rounded, color: Colors.white,),
                  SizedBox(height: 5,),
                  Text("MENU", style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Colors.white),)
                ],
                      ),),
            ),
          ),
        ],
      ),
    );
  }
}


