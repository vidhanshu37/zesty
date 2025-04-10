import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/screens/home/item_cart/trackDeliveryOrder.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../../custom_widget/elevatedButton_cust.dart';
import '../../../utils/constants/colors.dart';

class ZestyMartPayment extends StatefulWidget {
  
  final String totalPrice;
  
  const ZestyMartPayment({super.key, required this.totalPrice});

  @override
  State<ZestyMartPayment> createState() => _ZestyMartPaymentState();
}

class _ZestyMartPaymentState extends State<ZestyMartPayment> {
  
  var box = Hive.box(HiveOpenBox.storeAddress);
  var boxZesty = Hive.box(HiveOpenBox.storeZestyMartItem);
  String selectedOption = "COD";
  
  late Razorpay _razorpay;
  
  void openCheckout(int amount) async {
    amount = amount * 100;
    var options = {
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
  
  Future<void> handlePaymentSuccess(PaymentSuccessResponse res) async {
    // ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
    //   content: new Text("Payment Successfull"),
    // ));
    boxZesty.clear();
    int zestyMartLiteOrder = box.get(HiveOpenBox.zestyMartLiteOrder, defaultValue: 0);
    zestyMartLiteOrder++;
    box.put(HiveOpenBox.zestyMartLiteOrder, zestyMartLiteOrder);

    QuickAlert.show(
        barrierDismissible: false,
        context: context,
        type: QuickAlertType.success,
        title: 'Order confirm',
        text: 'You will get your order in 15-20 minutes',
        onConfirmBtnTap: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
      confirmBtnColor: Colors.black,

    );
    // Navigator.popUntil(context, (route) => route.isFirst);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Confirm")));

    // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => TrackDeliveryOrder(ResLongitude: ResLongitude, ResLatitude: ResLatitude, restaurantId: restaurantId, totalCartValue: totalCartValue)), (route) => route.isFirst);
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ZestyMoney.walletAmount.toString())));
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
  
  @override
  void initState() {
    super.initState();
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
                  Card(
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
                                  "Zesty Warehouse",
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
                    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.values as String)));
                    if (selectedOption == "COD") {
                      QuickAlert.show(
                          barrierDismissible: false,
                          context: context,
                          type: QuickAlertType.success,
                          title: 'Order confirm',
                          text: 'You will get your order in 15-20 minutes',
                          onConfirmBtnTap: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          confirmBtnColor: Colors.black,
                      );
                      // storeOrderData();
                      boxZesty.clear();
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Confirm")));
                      int zestyMartLiteOrder = box.get(HiveOpenBox.zestyMartLiteOrder, defaultValue: 0);
                      zestyMartLiteOrder++;
                      box.put(HiveOpenBox.zestyMartLiteOrder, zestyMartLiteOrder);
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order done via cash")));
                      // Navigator.popUntil(context, (route) => route.isFirst);
                    } else if (selectedOption == "ONLINE") {
                      openCheckout(int.parse(widget.totalPrice));
                    } else if (selectedOption == "WALLET") {
                      int zestyWallet =
                      int.parse(box.get(HiveOpenBox.userZestyMoney));
                      int price = int.parse(widget.totalPrice);
                      if (zestyWallet >= price) {
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Order Confirm")));
                        zestyWallet = zestyWallet - price;
                        box.put(HiveOpenBox.userZestyMoney,
                            zestyWallet.toStringAsFixed(0));
                        int zestyMartLiteOrder = box.get(HiveOpenBox.zestyMartLiteOrder, defaultValue: 0);
                        zestyMartLiteOrder++;
                        box.put(HiveOpenBox.zestyMartLiteOrder, zestyMartLiteOrder);
                        boxZesty.clear();
                        QuickAlert.show(
                            barrierDismissible: false,
                            context: context,
                            type: QuickAlertType.success,
                            title: 'Order confirm',
                            text: 'You will get your order in 15-20 minutes',
                            onConfirmBtnTap: () {
                              Navigator.popUntil(context, (route) => route.isFirst);
                            },
                          confirmBtnColor: Colors.black,

                        );
                        // storeOrderData();
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
