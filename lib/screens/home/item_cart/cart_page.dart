import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/item_cart/coupons.dart';
import 'package:zesty/screens/restaurants_side/restaurants_home.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/constants/media_query.dart';
import '../../../utils/local_storage/HiveOpenBox.dart';

class CartPage extends StatefulWidget {

  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool isExpanded = false;

  bool checkCouponDiscount = false;

  // List to track counters for each item
  late List<int> counters;

  // get restaurant details
  List<Map<String, dynamic>> restaurantDetails = [];

  var box = Hive.box(HiveOpenBox.zestyFoodCart);
  var boxAddress = Hive.box(HiveOpenBox.storeAddress);
  List quantityItemList = [];

  List packagingCharge = [];

  /// Store name, latitude, longitude
  String resName = "";
  double latitude = 0.0;
  double longitude = 0.0;

  var total = 0.0;

  String lastRestaurantId = "";

  Map<String, String> couponData = {};


  /// For particular restaurant data
  Future<void> getRestaurantData() async {

    // get restaurant id
    Map<dynamic, dynamic> rawData = box.toMap(); // Convert to Map
    Map<String, dynamic> cartData = Map<String, dynamic>.from(rawData);

    if (cartData.isEmpty) return null; // Check if cart is empty

    String lastKey = cartData.keys.last; // Get the last item key
    lastRestaurantId = cartData[lastKey]['restaurantId']; // Get the restaurantId

    // call api for single restaurant
    final url = Uri.parse(ApiConstants.getSingleRestaurantData(lastRestaurantId));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        Map<String, dynamic> singleRestaurantData = jsonDecode(response.body);
        resName = singleRestaurantData['restaurantName'] ?? 'null';
        latitude = singleRestaurantData['latitude'] ?? 21.71;
        longitude = singleRestaurantData['longitude'] ?? 71.21;
        total = calculateDistance();
        print("get restaurant data }");
        setState(() {});
      } else {
        print("Fail restaurant");
      }
    } catch (e) {
      print(e);
    }
  }
  
  @override
  void initState() {
    super.initState();
    getQuantity();
    fetchCartData();
    getRestaurantData(); // get restaurant data
    // calculateDistance(); // calculate distance

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (box.isNotEmpty && quantityItemList.length >= box.length) {
        counters = List.generate(box.length, (index) => quantityItemList[index] ?? 1);
      } else {
        counters = List.generate(box.length, (index) => 1); // Default all to 1 if empty
      }
      setState(() {}); // Ensure UI updates after list is initialized
    });


    // if (box.length > 0 && quantityItemList.isNotEmpty) {
    //   counters = List.generate(box.length, (index) => quantityItemList[index] ?? 1);
    // } else {
    //   counters = []; // Initialize as empty list if no items are present
    // }
  }

  void incrementCounter(int index) {
    setState(() {
      counters[index]++;
      manageCartItem(counters);
    });
  }

  void decrementCounter(int index) {
    if(counters[index] > 0) {
      setState(() {
        counters[index]--;
        manageCartItem(counters);
      });
    }
    countTotalCartZeroOrNot();
  }


  /// If cart less than zero than close the cart page
  void countTotalCartZeroOrNot() {
    int sumOfCart = counters.fold(0, (previous, element) => previous + element);
    if(sumOfCart == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => RestaurantsHome(id: lastRestaurantId)));
    }
  }

  /// Update old quantity value with new value (which might change on cart)
  void manageCartItem(List newQty) {
    if(box.isEmpty) return; // item is empty

    List keys = box.keys.toList();

    for(int i=0; i<keys.length; i++) {
      if(i < newQty.length) {
        int singleQty = newQty[i];

        if(singleQty == 0) {
          box.delete(keys[i]);
        } else {
          Map<String, dynamic> existingData = Map<String, dynamic>.from(box.get(keys[i]));
          existingData['qty'] = newQty[i];
          box.put(keys[i], existingData);
        }
      }
    }
  }

  /// Count total price (quantity * price)
  double calculateTotalCartValue() {
    double total = 0.0;
    for(int i=0; i< restaurantDetails.length; i++) {
      double price = double.parse(restaurantDetails[i]['price'].toString());
      int qty = counters[i];
      total += price * qty;
    }
    return total;
  }

  void getCouponId() async {
    couponData = await Navigator.push(context, MaterialPageRoute(builder: (context) => Coupons(updateCartUI: updateCartUI, calculateTotalCartValue: calculateTotalCartValue())));
  }

  var couponDiscount = 0.0;

  /// Count coupon value (after apply coupon discount)
  void countDiscountCoupon() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("hello")));
    double totalCartValue = calculateTotalCartValue();
    double discount;
    if ( totalCartValue > double.parse(couponData['minAmtReq'] ?? '150.0') ) {
      discount = totalCartValue * (double.parse(couponData['discountPercentage'] ?? '60') / 100);
      if( discount > double.parse(couponData["discountUpto"] ?? '1.0')) {
        couponDiscount = double.parse(couponData["discountUpto"] ?? '1.0');
        setState(() {

        });
      } else {
        couponDiscount = discount;
        setState(() {

        });
      }
    } else {
      couponDiscount = 0;
      setState(() {

      });
    }
  }

  /// fetch cart data from hive database
  Future<void> fetchCartData() async {
    var allKeys = box.keys.toList();
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(allKeys.toString())));
    List<Map<String, dynamic>> fetchedRestaurants = []; // Temporary list to store data

    for(var id in allKeys) {
      final url = Uri.parse("https://zesty-backend.onrender.com/menu/get/$id");

      try {
        final response = await http.get(url);

        if(response.statusCode == 200) {
          var restaurantData = jsonDecode(response.body);
          fetchedRestaurants.add(restaurantData);
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

    setState(() {
      restaurantDetails = fetchedRestaurants;
      packagingCharge = List.generate(box.length, (index) => restaurantDetails[index]['packagingCharge'] ?? '0.0');
    });

  }

  /// Get all quantity of item
  void getQuantity() {
    quantityItemList.clear();
    for(var value in box.values) {
        quantityItemList.add(value['qty']);
    }
    // print(quantityItemList);
  }

  double calculateDistance() {
    var hiveBox = Hive.box("zestyBox");
    var lat = hiveBox.get("latitude", defaultValue: 21.2049);
    var long = hiveBox.get("longitude", defaultValue: 72.8411);
    return ApiConstants.calculateDistance(latitude, longitude, lat, long);
  }

  double calculateDeliveryCharge() {
    if( total > 0 && total < 2) {
      return 20;
    } else if (total > 2 && total < 5) {
      return 40;
    }
    return total * 10;
  }

  /// Count grand total include all charges, tax, etc.
  String getTotal() {
    double totalCartValue = double.parse(calculateTotalCartValue().toStringAsFixed(2)) ?? 0.0;
    double deliveryCharge = double.parse(calculateDeliveryCharge().toStringAsFixed(2)) ?? 0.0;
    double totalPackagingCharge = packagingCharge
        .map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
        .fold(0.0, (sum, element) => sum + element); // Sum all packaging charges
    double tax = totalCartValue * 0.05; // Calculate 5% tax

    double totalValue = (totalCartValue + deliveryCharge + totalPackagingCharge + tax - couponDiscount) ?? 0.0;
    // double totalValue = ( 0 + deliveryCharge + 0 + 0) ?? 0.0;
    String formattedTotalValue = totalValue.toStringAsFixed(2);
    return formattedTotalValue;
  }

  void updateCartUI() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (couponData != null && couponData.isNotEmpty) {
        countDiscountCoupon();
      }
    });

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => RestaurantsHome(id: lastRestaurantId)));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => RestaurantsHome(id: lastRestaurantId)));
            // Navigator.popUntil(context, (route) { return route.settings.name == '/RestaurantsHome';});
          }, icon: Icon(Icons.arrow_back)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text("Ordering from, ", style: Theme.of(context).textTheme.labelMedium,),
              Text(resName, style: Theme.of(context).textTheme.bodyLarge,),
            ],
          ),
          centerTitle: false,
        ),
        // backgroundColor: Color(0xffefeef3),
        body: restaurantDetails.isEmpty || quantityItemList.isEmpty || resName == "" ? Center(child: CircularProgressIndicator()) : Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
      
                /// Location address select
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
                    subtitle: Text("${boxAddress.get(HiveOpenBox.storeAddressTitle)}, ${boxAddress.get(HiveOpenBox.storeAddressSubTitle)}", style: Theme.of(context).textTheme.labelMedium, maxLines: 1,),
                    trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: TColors.darkerGrey,),
                  ),
                ),
              ),
      
                /// Item cart information
                Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    // elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => RestaurantsHome(id: lastRestaurantId)));
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
                          /// Item cart description
                          ListView.builder(shrinkWrap: true, itemCount: restaurantDetails.length, physics: BouncingScrollPhysics(), itemBuilder: (context, index) {
                            return cartPageItemDisplay(quantity: quantityItemList[index], counter: counters[index], itemName: restaurantDetails[index]['name'], varientOrDescription: restaurantDetails[index]['description'] ?? 'na',
                                onDecrement: () => decrementCounter(index), onIncrement: () => incrementCounter(index),
                                price: restaurantDetails[index]['price'] ?? '10');
                          }),
                        ],
                      ),
                    )),
                SizedBox(
                  height: 0,
                ),
      
                /// Coupons
                Card(
                  color: TColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "SAVINGS CORNER",
                          style: TextStyle(
                              fontSize: 12, color: TColors.darkGrey),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.local_offer,
                            color: Colors.red,
                          ),
                          title: couponDiscount == 0
                              ? Text("Apply Coupon",style: TextStyle(fontSize: 13))
                              : Text("₹${couponDiscount.toStringAsFixed(2)} saved with '${couponData['promoCode'] ?? ""}'"),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: TColors.darkerGrey,),
                          onTap: () => getCouponId(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
      
                /// Total Bill
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
                            Text(
                              "To Pay " + getTotal(),
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
                                    couponDiscount == 0.0
                                    ? Text(
                                      "₹${calculateTotalCartValue().toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    )
                                    : Row(children: [
                                      Text(
                                        "₹${calculateTotalCartValue().toStringAsFixed(2)}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium?.copyWith(decoration: TextDecoration.lineThrough),
                                      ),
                                      SizedBox(width: 8,),
                                      Text("₹${(calculateTotalCartValue() - couponDiscount).toStringAsFixed(2)}")
                                    ],)
      
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),

                              /// Coupon discount
                              couponDiscount == 0.0 ? SizedBox.shrink() :Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "item Discount",
                                      style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500, decoration: TextDecoration.underline)
                                    ),
                                    Text(
                                      "₹${couponDiscount.toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge?.copyWith(color: TColors.darkGreen, fontWeight: FontWeight.bold),
                                    ),

                                  ],
                                ),
                              ),


                              /// Delivery fees - price
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Delivery Fee | ${calculateDistance().toStringAsFixed(1)} kms",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      "₹ ${calculateDeliveryCharge().toStringAsFixed(2)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Divider(
                                  color: TColors.grey,
                                ),
                              ),
      
                              /// Delivery tips
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Delivery Tip",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
      
                                    InkWell(
                                      onTap: () {},
                                      child: Text(
                                        "Add tip",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
      
                              /// Packaging charge - price
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Packaging charge",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      "₹${packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                                          .fold(0.0, (sum, element) => sum + element) }", // Sum all elements}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
      
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
      
                              /// GST charge
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "GST & Restaurant Charges",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    Text(
                                      "₹${(calculateTotalCartValue() * 0.05).toStringAsFixed(2)}", // Sum all elements}",
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
                                Text(
                                  "₹"+getTotal(),
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
                SizedBox(
                  height: 30,
                ),
      
                /// for button adjustment remove
                ZElevatedButton(title: "Make Payment", onPress: (){
      
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(couponDiscount.toString())));

                      // item total
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                  //     "${(double.parse(calculateTotalCartValue().toStringAsFixed(2)))}")));
      
                  //delivery charge
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                  //     "${(double.parse(calculateDeliveryCharge().toStringAsFixed(2)))}")));
      
      
                  // packaging charge
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                  //         "${packagingCharge}")));
      
                  // GST & charge
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
                  //         "${(calculateTotalCartValue() * 0.05)}")));
      
      
                  })
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class cartPageItemDisplay extends StatelessWidget {

  final int quantity;
  final int counter;
  final String itemName;
  final String varientOrDescription;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String price;

  const cartPageItemDisplay({
    super.key,
    required this.quantity,
    required this.counter,
    required this.itemName,
    required this.varientOrDescription,
    required this.onDecrement,
    required this.onIncrement,
    required this.price,
  });


  @override
  Widget build(BuildContext context) {
    return counter != 0 ? Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: 70,
        width: double.infinity,
        child: Row(
          // mainAxisAlignment:
          // MainAxisAlignment.spaceBetween,
          children: [
            /// Item name and description
            Expanded(
              flex: 55,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,  overflow: TextOverflow.ellipsis,
                    ), maxLines: 1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    varientOrDescription,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 10,
            ),
            /// Add or remove item
            Expanded(
              flex: 28,
              child: Container(
                height: 35,
                width: 80,
                padding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(8),
                  border:
                  Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    // remove button
                    InkWell(
                      onTap: onDecrement,
                      child: Container(
                        height: 35,
                        width: 25,
                        padding:
                        EdgeInsets.only(right: 4),
                        child: Icon(Icons.remove,
                            size: 16,
                            color: TColors.darkerGrey),
                      ),
                    ),
                    // counter
                    Text(
                      "$counter",
                      style: TextStyle(
                          color: TColors.darkerGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    // add button
                    InkWell(
                      onTap: onIncrement,
                      child: Container(
                        height: 35,
                        width: 25,
                        padding:
                        EdgeInsets.only(left: 4),
                        child: Icon(Icons.add,
                            size: 16,
                            color: TColors.darkerGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),


            /// Item price
            Expanded(
              flex: 20,
              child: Text(
                "₹${(double.parse(price) * counter).toStringAsFixed(1)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),
          ],
        )) : SizedBox.shrink() ;
  }
}