import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/item_cart/trackDeliveryOrder.dart';
import 'package:zesty/screens/home/item_cart/trackOrder.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/media_query.dart';

class CartPayment extends StatefulWidget {
  final String restaurantName;
  final String restaurantId;
  final String deliveryTime;
  final String totalPrice;
  final String couponCode;
  final List foodItemId;
  final List foodItemQty;
  final String totalItemValue;
  final double latitude;
  final double longitude;
  final bool deliveryOption;

  const CartPayment(
      {super.key,
      required this.restaurantName,
      required this.restaurantId,
      required this.deliveryTime,
      required this.totalPrice,
      required this.couponCode,
      required this.foodItemQty,
      required this.foodItemId,
      required this.totalItemValue,
      required this.latitude,
      required this.longitude,
        required this.deliveryOption,
      });

  @override
  State<CartPayment> createState() => _CartPaymentState();
}

class _CartPaymentState extends State<CartPayment> {
  var box = Hive.box(HiveOpenBox.storeAddress);

  late Razorpay _razorpay;

  // int price = 0;

  String selectedOption = 'COD';

  void openCheckout(int amount) async {
    amount = amount * 100;
    var options = {
      'image': 'assets/images/zesty-logo-main.jpg',
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'Zesty',
      'prefill': {'contact': '1234567890', 'email': 'test@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  /// create food cart box object (if success empty whole cart)
  var boxCart = Hive.box(HiveOpenBox.zestyFoodCart);

  Future<void> handlePaymentSuccess(PaymentSuccessResponse res) async {
    // ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //   content: new Text("Payment Successfull"),
    // ));
    boxCart.clear();
    storeOrderData();
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ZestyMoney.walletAmount.toString())));
  }

  void handlePaymentFailure(PaymentFailureResponse res) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("Payment Fail, Something went to wrong!"),
    ));
  }

  void handleExternalWallet(ExternalWalletResponse res) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("External Wallet, Something went to wrong!"),
    ));
  }

  List<Map<String, dynamic>> orderList = [];

  Future<void> storeOrderData() async {
    boxCart.clear();
    final url = Uri.parse('https://zesty-backend.onrender.com/order/add-order');
    try {
      final response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "restaurantId": widget.restaurantId,
            "restaurantName": widget.restaurantName,
            "userId": box.get(HiveOpenBox.userId),
            "order": orderList,
            "totalAmountUser": widget.totalPrice,
            "totalAmountRestaurant": widget.totalItemValue,
            "coupon": widget.couponCode,
            "paymentMode": selectedOption,
          }));

      if (response.statusCode == 200) {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(SnackBar(content: Text("DONE ORDER")));
        int zestyLiteOrder = box.get(HiveOpenBox.zestyLiteOrder, defaultValue: 0);
        zestyLiteOrder++;
        box.put(HiveOpenBox.zestyLiteOrder, zestyLiteOrder);
        if (widget.deliveryOption == false) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => TrackOrder(
                    restaurantId: widget.restaurantId,
                    longitude: widget.longitude,
                    latitude: widget.latitude,
                  )),
              (route) => route.isFirst,
          );
        } else {
          Navigator.pushAndRemoveUntil(context,
              MaterialPageRoute(builder: (builder) =>
                  TrackDeliveryOrder(ResLatitude: widget.latitude, ResLongitude: widget.longitude,
                      restaurantId: widget.restaurantId, totalCartValue: widget.totalPrice)
              ), (route) => route.isFirst);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  void initState() {
    super.initState();

    orderList = List.generate(
        widget.foodItemQty.length,
        (index) => {
              "itemId": widget.foodItemId[index],
              "quantity": widget.foodItemQty[index],
            });

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Payment Options",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              "Total: ₹${widget.totalPrice}",
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),

                  /// source to destination card
                  widget.deliveryOption == false ? Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "You will pick (your location)",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider(
                                    color: TColors.grey,
                                  ),
                                ),
                                Text(
                                  widget.restaurantName,
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                      overflow: TextOverflow.ellipsis),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ) : Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.arrow_downward_rounded,
                            size: 20,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.restaurantName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          overflow: TextOverflow.ellipsis),
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Divider(
                                    color: TColors.grey,
                                  ),
                                ),
                                Text(
                                  box.get(HiveOpenBox.storeAddressTitle),
                                  softWrap: true,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                          overflow: TextOverflow.ellipsis),
                                  maxLines: 2,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),

                  /// payment option
                  Text(
                    "\t\t\tPreferred Payment",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: TColors.darkerGrey),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  /// COD, Online
                  Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Pay on Delivery (Cash/UPI)",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                "Pay cash or ask for QR code",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              trailing: Radio(
                                  activeColor: Colors.black,
                                  value: 'COD',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 0.0),
                              child: Divider(
                                color: TColors.grey,
                              ),
                            ),
                            ListTile(
                              title: Text(
                                "Pay online",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              subtitle: Text(
                                "Pay via google pay or card or netbanking",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              trailing: Radio(
                                  activeColor: Colors.black,
                                  value: 'ONLINE',
                                  groupValue: selectedOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedOption = value!;
                                    });
                                  }),
                            ),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "\t\t\tMore Payment Options",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: TColors.darkerGrey),
                  ),
                  SizedBox(
                    height: 8,
                  ),

                  /// Wallet
                  Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Text(
                            "Wallet",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            "Pay via zesty wallet",
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          trailing: Radio(
                              activeColor: Colors.black,
                              value: 'WALLET',
                              groupValue: selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  selectedOption = value!;
                                });
                              }),
                        )),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 0,
              left: 0,
              child: ZElevatedButton(
                  title: "Pay Now",
                  onPress: () {
                    if (selectedOption == "COD") {
                      storeOrderData();
                    } else if (selectedOption == "ONLINE") {
                      openCheckout(int.parse(widget.totalPrice));
                    } else if (selectedOption == "WALLET") {
                      int zestyWallet =
                          int.parse(box.get(HiveOpenBox.userZestyMoney));
                      int price = int.parse(widget.totalPrice);
                      if (zestyWallet >= price) {
                        zestyWallet = zestyWallet - price;
                        box.put(HiveOpenBox.userZestyMoney,
                            zestyWallet.toStringAsFixed(0));
                        storeOrderData();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Not enough balance")));
                      }
                    }
                  }
                  ),
            )
          ],
        ),
      ),
    );
  }
}
