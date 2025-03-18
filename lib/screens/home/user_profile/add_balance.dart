import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/zesty_money.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import 'money_Gift_Cards.dart';

class AddBalance extends StatefulWidget {


  const AddBalance({super.key});

  @override
  State<AddBalance> createState() => _AddBalanceState();
}

class _AddBalanceState extends State<AddBalance> {
  final TextEditingController _amountController = TextEditingController();
  int? _selectedAmount;
  late Razorpay _razorpay;

  void _updatedAmount(int amount){
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toString();
    });
  }

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

  var box = Hive.box(HiveOpenBox.storeAddress);

  Future<void> handlePaymentSuccess(PaymentSuccessResponse res) async {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text("Payment Successfull"),
    ));
    setState(() {
      var zestyAmt = int.parse((box.get(HiveOpenBox.userZestyMoney)));
      zestyAmt += int.parse(_amountController.text);
      box.put(HiveOpenBox.userZestyMoney, zestyAmt.toString());
      // widget.updateSetState;
      storeMoney();
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


  Future<void> storeMoney() async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/update-zesty-money');

    try {
      final response = await http.post(
          url,
        headers: {
          "Content-Type": "application/json",
        },
          body: jsonEncode({
            "userId": box.get(HiveOpenBox.userId),
            "zestyMoney": box.get(HiveOpenBox.userZestyMoney),
          })
      );

      if(response.statusCode == 200 ) {
        // widget.updateSetState;
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("done")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch(e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedAmount = 250;
    _updatedAmount(250);
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentFailure);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => MoneyGift()));
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Add Balance",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          leading: IconButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => MoneyGift()));
          }, icon: Icon(Icons.arrow_back)),
        ),
        backgroundColor: Colors.grey[200],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [

              /// Top layout(enter amt, notes)
              Positioned(
                top: 10,
                right: 0,
                left: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10,),
                    Text("\t\t\tAvailable balance: ₹${box.get(HiveOpenBox.userZestyMoney)}",style: TextStyle(color: TColors.darkerGrey,fontSize: 14),),
                    SizedBox(height: 13,),
                    Card(
                      color: TColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      elevation: 2,
                      child: Padding(padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Enter Amount :",style: TextStyle(color: TColors.black,fontSize: 14),),
                            SizedBox(height: 8,),
                            TextField(
                              controller: _amountController,
                              decoration: InputDecoration(
                                prefixText: "₹ ",
                                prefixStyle: TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 16,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _amountButton(250),
                                _amountButton(500),
                                _amountButton(2000),
                                _amountButton(5000),
                              ],
                            ),
                            SizedBox(height: 12,),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16,),
                    Card(
                      color: TColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Note:",style: TextStyle(color: TColors.darkGreen,fontWeight: FontWeight.bold),),
                            SizedBox(height: 8,),
                            noteItem(text: "Zesty Money balances are valid for 1 year from credit on Zesty."),
                            noteItem(text: "Zesty Money cannot be transferred to your bank account as per RBI fuidelines."),
                            noteItem(text: "Zesty Money can be used for food deliveries and Zestymart."),
                          ],
                        ),
                      ),
                    ),
                    // SizedBox(height: 170,),
                    // SizedBox(height: 16,),
                  ],
                ),
              ),

              /// Button proceed to pay
              Positioned(
                bottom: 40,
                right: 0,
                left: 0,
                child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(onPressed: (){
                  int amount = int.parse(_amountController.text);
                  openCheckout(amount);
                  // box.put(HiveOpenBox.userZestyMoney, "0");
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("local db: ${int.parse(box.get(HiveOpenBox.userZestyMoney))}")));

                },
                    onLongPress: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("local db: ${double.parse(box.get(HiveOpenBox.userZestyMoney))}")));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: TColors.darkGreen,
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("Proceed to Add Balance",style: TextStyle(fontSize: 16,color: Colors.white),)),
              ),)
            ],
          ),
        ),
      ),
    );
  }

  Widget _amountButton(int amount){
    return GestureDetector(
      onTap: () => _updatedAmount(amount),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _selectedAmount == amount ? TColors.darkGreen : Colors.grey.shade300),
          color: _selectedAmount == amount ? Color(0xffcae97c).withOpacity(0.2) : Colors.white
        ),
        child: Column(
          children: [
            Text("₹$amount",style: TextStyle(fontSize: 13,color: _selectedAmount == amount ? TColors.darkGreen : Colors.black),),
            // if(amount == 500)
            //   Padding(padding: EdgeInsets.only(top: 2),
            //     child: Container(
            //       decoration: BoxDecoration(
            //         color: Colors.red,
            //         borderRadius: BorderRadius.circular(6),
            //       ),
            //       child: Text("Most Popular",style: TextStyle(color: Colors.white,fontSize: 10),),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}

class noteItem extends StatelessWidget {
  const noteItem({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.fontColor = TColors.darkerGrey
  });

  final double fontSize;
  final Color fontColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.circle,size: 8,color: Colors.black,),
          ),
          SizedBox(width: 8,),
          Expanded(child: Text(text,style: TextStyle(fontSize: fontSize,color: fontColor),)),
        ],
      ),
    );
  }
}
