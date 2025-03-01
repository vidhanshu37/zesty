import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../../utils/constants/colors.dart';

class CartPayment extends StatefulWidget {

  final String restaurantName;
  final String deliveryTime;
  final String totalPrice;
  const CartPayment({super.key, required this.restaurantName, required this.deliveryTime, required this.totalPrice});

  @override
  State<CartPayment> createState() => _CartPaymentState();
}

class _CartPaymentState extends State<CartPayment> {

  var box = Hive.box(HiveOpenBox.storeAddress);

  late Razorpay _razorpay;

  String selectedOption = 'COD';

  void openCheckout(amount) async {
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
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("Payment Successfull"),
    ));
    setState(() {
      // ZestyMoney.walletAmount += int.parse(_amountController.text);
    });
    //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ZestyMoney.walletAmount.toString())));
  }

  void handlePaymentFailure(PaymentFailureResponse res) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("Payment Fail, Something went to wrong!" ),
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
            Text("Payment Options", style: Theme.of(context).textTheme.bodyLarge,),
            Text("Total: ₹${widget.totalPrice}", style: Theme.of(context).textTheme.labelMedium,),
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
                  SizedBox(height: 10,),

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
                          Icon(Icons.arrow_downward_rounded, size: 20,),
                          SizedBox(width: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.restaurantName, style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.ellipsis), maxLines: 1,),
                              SizedBox(height: 10,),
                              Text("box.get(HiveOpenBox.storeAddress)", style: Theme.of(context).textTheme.bodyLarge!.copyWith(overflow: TextOverflow.ellipsis), maxLines: 1,)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),


                  /// payment option
                  Text("\t\t\tPreferred Payment", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.darkerGrey),),
                  SizedBox(height: 8,),

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
                            title: Text("Pay on Delivery (Cash/UPI)", style: Theme.of(context).textTheme.bodyLarge,),
                            subtitle: Text("Pay cash or ask for QR code", style: Theme.of(context).textTheme.labelMedium,),
                            trailing: Radio(
                                activeColor: Colors.black,
                                value: 'COD', groupValue: selectedOption, onChanged: (value){
                              setState(() {
                                selectedOption = value!;
                              });
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                            child: Divider(color: TColors.grey,),
                          ),
                          ListTile(
                            title: Text("Pay online", style: Theme.of(context).textTheme.bodyLarge,),
                            subtitle: Text("Pay via google pay or card or netbanking", style: Theme.of(context).textTheme.labelMedium,),
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
                      )
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("\t\t\tMore Payment Options", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: TColors.darkerGrey),),
                  SizedBox(height: 8,),

                  /// Wallet
                  Card(
                    color: TColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: ListTile(
                          title: Text("Wallet", style: Theme.of(context).textTheme.bodyLarge,),
                          subtitle: Text("Pay via zesty wallet", style: Theme.of(context).textTheme.labelMedium,),
                          trailing: Radio(
                              activeColor: Colors.black,
                              value: 'WALLET', groupValue: selectedOption, onChanged: (value){
                            setState(() {
                              selectedOption = value!;
                            });
                          }),
                        )
                    ),
                  ),

                ],
              ),
            ),
            Positioned(
              bottom: 20,
                right: 0,
                left: 0,
                child: ZElevatedButton(title: "Pay Now", onPress: (){
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(selectedOption)));

                  if ( selectedOption == "COD") {

                  } else if ( selectedOption == "ONLINE" ) {
                    openCheckout(200.0);
                  } else if ( selectedOption == "WALLET" ) {

                  }
                }))
          ],
        ),
      ),
    );
  }
}
