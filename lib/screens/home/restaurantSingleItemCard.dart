import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/manage_cart_item.dart';
import '../../utils/constants/media_query.dart';

class ItemCard extends StatefulWidget {
  final String itemName;
  final String itemDescription;
  final String itemPrice;
  final String itemImageId;
  final VoidCallback updateCartState;
  final String restaurantId;
  final String restaurantName;
  final String itemImageUrl;

  const ItemCard({
    super.key,
    required this.itemName,
    required this.itemDescription,
    required this.itemPrice,
    required this.itemImageId,
    required this.updateCartState,
    required this.restaurantId,
    required this.restaurantName,
    required this.itemImageUrl,
  });

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int _itemCount = 0;
  var box = Hive.box(HiveOpenBox.zestyFoodCart);

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

  void _retrieveCartData() {
    var allKeys = box.keys.toList();
    bool temp = allKeys.any((key) {
      if (key == widget.itemImageId) {
        var data = box.get(key);
        _itemCount = data['qty'] ?? 0;
        return true;
      } else {
        return false;
      }
    });
  }

  Future<void> _storeCartData(int quantity) async {
    final newData = {
      'qty': quantity,
      'restaurantId': widget.restaurantId,
    };

    // Check if the cart is not empty
    if (box.isNotEmpty) {
      final lastRestaurantId = box.values.last['restaurantId'];
      if (lastRestaurantId == widget.restaurantId) {
        // Same restaurant, update the item
        box.put(widget.itemImageId, newData);
      } else {
        // Different restaurant, show confirmation dialog
        final shouldClearCart = await _showConfirmationDialog(context);
        if (shouldClearCart == true) {
          // User confirmed, clear the cart and add the new item
          // _itemCount - 1;
          box.clear();
          widget.updateCartState;
          // box.put(widget.itemImageId, newData);
        } else {
          // User canceled, do nothing
          return;
        }
      }
    } else {
      // Cart is empty, add the new item
      box.put(widget.itemImageId, newData);
    }

    // Update the UI
    setState(() {
      _itemCount = quantity;
    });

    // Notify the parent widget to update the cart state
    widget.updateCartState();
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Replace cart item?"),
          content: Text("Your cart contains dishes from different restaurant. Do you want to discard the selection and add dishes from ${widget.restaurantName}?"),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // User canceled
                    },
                    child: Text("No", style: TextStyle(fontSize: 15),),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.updateCartState;
                      Navigator.of(context).pop(true); // User confirmed
                    },
                    child: Text("Yes", style: TextStyle(fontSize: 15)),
                  ),
                ),
              ],
            ),

          ],
        );
      },
    );
  }

  void _incrementItem() {
    if (box.isNotEmpty) {
      final lastRestaurantId = box.values.last['restaurantId'];
      if (lastRestaurantId == widget.restaurantId) {
        // Same restaurant, update the item
        final newQuantity = _itemCount + 1;
        _storeCartData(newQuantity);
      } else {
        // Different restaurant, show confirmation dialog
        _storeCartData(0);
      }
    } else {
      // Cart is empty, add the new item
      final newQuantity = _itemCount + 1;
      _storeCartData(newQuantity);
    }
  }

  void _decrementItem() {
    if (_itemCount > 0) {
      final newQuantity = _itemCount - 1;
      if (newQuantity == 0) {
        // Remove the item from the cart if the quantity is zero
        box.delete(widget.itemImageId);
        setState(() {
          _itemCount = 0; // Reset the item count
        });
      } else {
        // Update the item quantity
        _storeCartData(newQuantity);
      }
      // Notify the parent widget to update the cart state
      widget.updateCartState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 190,
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
                    SizedBox(height: 20),
                    Container(
                      height: 20,
                      width: 20,
                      color: Colors.amber,
                    ),
                    SizedBox(height: 5),
                    Text(
                      widget.itemName,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 4),
                    Text(
                      widget.itemImageId,
                      style: TextStyle(fontSize: 12, color: TColors.darkGrey),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    SizedBox(height: 7),
                    Text(
                      "₹ ${widget.itemPrice}",
                      style: TextStyle(
                        fontSize: 14,
                        color: TColors.darkerGrey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 130,
                height: 150,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        color: TColors.white,
                        child: Image.network(
                          widget.itemImageUrl,
                          width: 130,
                          height: 130,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(color: Colors.grey);
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image_not_supported, size: 130, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 25,
                      child: _itemCount == 0
                          ? GestureDetector(
                        onTap: _incrementItem,
                        child: Container(
                          height: 35,
                          width: 80,
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
                              onTap: _decrementItem,
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
                              onTap: _incrementItem,
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
                    ),
                  ],
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
        ),
      ],
    );
  }
}