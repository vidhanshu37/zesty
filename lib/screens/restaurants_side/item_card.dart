import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/manage_cart_item.dart';
import '../../utils/constants/media_query.dart';

class itemCard extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final String itemPrice;
  final String itemImageId;
  final VoidCallback updateCartState;
  final String restaurantId;

  const itemCard({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImageId,
    required this.updateCartState,
    required this.restaurantId,
  });

  @override
  State<itemCard> createState() => _itemCardState();
}

class _itemCardState extends State<itemCard> {
  int _itemCount = 0;

  var box = Hive.box(HiveOpenBox.zestyFoodCart);
  int counter = 0;


  void retriveCartData() {
    // Map allData = box.toMap(); // get all data in (map)
    var allKeys = box.keys.toList(); // get all key in (list)

    // bool found = allKeys.any((key) => key == widget.itemImageId);

    // if(found) {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Found")));
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Not Found")));
    // }

   bool temp = allKeys.any((key) {
      if( key == widget.itemImageId) {
        _itemCount = box.get(key);
        return true;
      } else {
        return false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    retriveCartData();
  }

  // void showSnackBar(BuildContext context) {
  //   // Convert Map records to a formatted string
  //   String mapData = ManageCartItem.manageCartItem.entries
  //       .map((entry) => '${entry.key}: ${entry.value}')
  //       .join('\n');
  //
  //   // Show Snackbar
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(mapData),
  //       duration: Duration(seconds: 3), // Duration to display the Snackbar
  //     ),
  //   );
  // }

  Future<void> storeCartData(Map<String, dynamic> newData) async {
    // Map<String, dynamic>? existingData = box.get(HiveOpenBox.zestyFoodCart);
    // print("existing $existingData");
    if(box.isNotEmpty) {
      print("hii");
      String lastRestaurantId = box.values.whereType().last['restaurantId'].toString();
      if (lastRestaurantId == newData['restaurantId']) {
        print("Old restaurant");
        box.put(widget.itemImageId, newData);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("old res")));
      } else {
        print("new restaurant");
        box.clear();
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("new res")));
      }
    } else {
      box.put(widget.itemImageId, newData);
      counter++;
      print("Hello");

    }


    // if(existingData == null) {
    //   await box.put(widget.itemImageId, newData);
    //   counter++;
    // } else if (existingData['restaurantId'] == newData['restaurantId']) {
    //   await box.put(widget.itemImageId, newData);
    //   counter++;
    // } else {
    //   print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAa");
    // }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 180,
          width: ZMediaQuery(context).width - 20,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.transparent,

          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: ZMediaQuery(context).width - 190,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Container(
                      height: 20,
                      width: 20,
                      color: Colors.amber,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.itemName,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      // widget.itemDescription,
                      widget.itemImageId,
                      style: TextStyle(fontSize: 12, color: TColors.darkGrey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(
                      height: 7,
                    ),
                    Text(
                      "₹ ${widget.itemPrice}",
                      style: TextStyle(
                          fontSize: 14,
                          color: TColors.darkerGrey,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 10,
              ),
              SizedBox(
                width: 130,
                height: 150,
                child: Stack(
                  children : [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Container(
                          color: TColors.white,
                          child: Image.network(
                            "https://zesty-backend.onrender.com/menu/get-menu-image/${widget.itemImageId}",
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(color: Colors.grey,);
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                            },
                          ),
                        )),
                    Positioned(
                      bottom: 0,
                      left: 25,
                      child: counter == 0 ? GestureDetector(
                        onTap: () {
                          setState(() {
                            // _itemCount++;
                            // [widget.itemImageId] = _itemCount;
                            // ManageCartItem.manageCartItem[widget.itemImageId] = _itemCount;
                            // box.put(widget.itemImageId, );
                            storeCartData({"qty": counter, "restaurantId": widget.restaurantId});
                            widget.updateCartState();
                          });
                        },
                        child: Container(
                          height: 35,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: TColors.darkGrey),
                          ),
                          child: Center(child: Text("ADD", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: TColors.darkerGrey),)),
                        ),
                      ) : Container(
                        height: 35,
                        width: 80,
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
                              onTap: () {
                                setState(() {
                                  if (counter > 0) counter--;
                                  if(counter == 0) {
                                    // widget.cartItem.remove(widget.itemImageId);
                                    // ManageCartItem.manageCartItem[widget.itemImageId] = _itemCount;
                                    box.delete(widget.itemImageId);
                                    // box.put(widget.itemImageId, {"qty": _itemCount, "restaurantName": widget.restaurantId});

                                  } else {
                                    // widget.cartItem[widget.itemImageId] = _itemCount;
                                    // ManageCartItem.manageCartItem[widget.itemImageId] = _itemCount;
                                    // box.put(widget.itemImageId, _itemCount);
                                    // box.put(widget.itemImageId, {"qty": _itemCount, "restaurantId": widget.restaurantId});
                                    storeCartData({"qty": counter, "restaurantId": widget.restaurantId});
                                  }
                                  widget.updateCartState();
                                });
                              },
                              child: Container(
                                // color: Colors.amber,
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(Icons.remove, size: 16, color: TColors.darkGreen,),
                              ),
                            ),
                            Text(
                              "$counter",
                              style: TextStyle(color: TColors.darkGreen, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // _itemCount++;
                                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.itemImageId} - $_itemCount")));
                                  // widget.cartItem[widget.itemImageId] = _itemCount;
                                  // ManageCartItem.manageCartItem[widget.itemImageId] = _itemCount;
                                  // box.put(widget.itemImageId, _itemCount);
                                  // box.put(widget.itemImageId, {"qty": _itemCount, "restaurantId": widget.restaurantId});
                                  storeCartData({"qty": counter, "restaurantId": widget.restaurantId});
                                  widget.updateCartState();
                                });
                              },
                              child: Container(
                                // color: Colors.amber,
                                padding: EdgeInsets.only(left: 10),
                                child: Icon(Icons.add, size: 16, color: TColors.darkGreen,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ] ,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Divider(
            color: TColors.grey.withOpacity(0.5),
          ),
        )
      ],
    );
  }
}