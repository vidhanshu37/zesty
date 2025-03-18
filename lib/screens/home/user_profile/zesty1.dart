import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:hive/hive.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:zesty/screens/home/user_profile/zestyLiteActive.dart';
import 'package:zesty/utils/constants/colors.dart';

import '../../../utils/constants/media_query.dart';
import '../../../utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;

class zesty1 extends StatefulWidget{
  @override
  State<zesty1> createState() => _zesty1State();
}

class _zesty1State extends State<zesty1> {

  late Razorpay _razorpay;

  final List<Map<String, String>> faqs = [
    {
      "question": "Is there a limit on the number of devices I can use Swiggy Zesty Lite on?",
      "answer": "Yes. Swiggy One Lite membership can be used only on 2 devices at a time. Swiggy Zesty Lite memberships are priced for individual and personal usage. Having a 2 device limit helps us curb disproportionate usage of benefits and ensures the sustainability of the pricing we offer to all our consumers."
    },
    {
      "question": "Is there a limit on free deliveries or extra discounts on Food delivery or Instamart with Zesty Lite?",
      "answer": "With our 3-month Zesty Lite plan, you can enjoy 10 free deliveries on Food orders and 10 free deliveries on Instamart orders. Additionally, you get inlimited flat discounts on food delivery and Genie, as well as exclusive Dineout pre-book offers and deals, all on top of our regular offers."
    },
    {
      "question": "Is there a minimum bill value to avail Swiggy Zesty Pre-Book offers on Dineout?",
      "answer": "No there is no minimum bill value required to avail Zesty One Pre-Book offers on Dineout pre-book restauants."
    },
    {
      "question": "What will happen once I finish my free deliveries on either Food or Zestymart?",
      "answer": "Once you have enjoyed all your free deliveries on either Food or Zestymart, do not worry! You will get the option to either upgrade to Zesty One or renew Zesty Lite. This way you continue to enjoy free deliveries. Note, that on renewing or upgrading to a new plan, previous plan benefits do not carry forward."
    },
  ];

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

  Future<void> updateAddress(context) async {
    var box = Hive.box(HiveOpenBox.storeAddress);
    final url = Uri.parse('https://zesty-backend.onrender.com/user/update-user');

    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "zestyLite": "true",
            "id": box.get(HiveOpenBox.userId),
          }));


      if(response.statusCode == 200) {
        box.put(HiveOpenBox.userZestyLite, "true");
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(box.get(HiveOpenBox.userZestyLite))));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch(e) {
      print("error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("e.toString()")));
    }
  }
  
  var box = Hive.box(HiveOpenBox.storeAddress);
  Future<void> handlePaymentSuccess(PaymentSuccessResponse res) async {
    updateAddress(context);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => ZestyLiteActive(zestyOrder: 0, zestyMartOrder: 0,)));
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text("Zesty",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                  Text("Zesty",style: Theme.of(context).textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w800, color: TColors.darkGreen),),
                  SizedBox(width: 6,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 2),
                    decoration: BoxDecoration(
                      border: Border.all(color: TColors.darkGreen,width: 2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text("LITE",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                  ),
                ],
              ),
              SizedBox(height: 8,),
              Center(child: Text("Heavy Benefits, Lite Price!",style: TextStyle(fontSize: 17,color: Colors.black),)),
              SizedBox(height: 8,),
              Divider(),
              SizedBox(height: 10,),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    SizedBox(height: 8,),
                    Container(
                        width: double.infinity,
                        color: TColors.Green.withOpacity(0.5),
                        child: Center(child: Text("3 MONTHS PLAN",style: TextStyle(fontSize: 14,color: TColors.darkGreen),))
                    ),
                    SizedBox(height: 7,),
                    Image.asset('assets/images/ZestyLogo.png', fit: BoxFit.cover, height: 100, width: 180,),
                    // SizedBox(height: 10,),
                    Text("Unlock 20 Free Deliveries",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    Text("10 on Food + 10 on Zestymart",style: TextStyle(fontSize: 15,color: TColors.darkerGrey),),
                    SizedBox(height: 22,),
                    SizedBox(
                      height: 50,
                      width: ZMediaQuery(context).width - 80,
                      child: ElevatedButton(onPressed: (){
                        openCheckout(149);
                      },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.darkGreen,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                          child: Text("Buy Zesty Lite at ₹149",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w800,color: Colors.white),),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text("ZESTY LITE BENEFITS",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: TColors.darkerGrey),),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: TColors.Green.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        //blurRadius: 2,
                        //spreadRadius: 1
                      ),
                    ]
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon(Icons.emoji_emotions,color: Colors.orange,),
                    Image.asset("assets/images/cool.png",height: 30,),
                    SizedBox(width: 5,),
                    Expanded(child: Text("Wohoo! You can save ₹600 in 3 months just with Zesty Lite Free deliveries",style: TextStyle(fontSize: 12),)),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade200
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Food",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    SizedBox(height: 13,),
                    Text("10 free deliveries",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("on all restauants up to 7 km,",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 3,),
                    Text("on orders above ₹199",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("Up to 5% extra discounts",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("over & above other offers",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("No surge fee, ever!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("even during rain or peak hours",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 20,),
                    Divider(),
                    SizedBox(height: 13,),
                    Text("Instamart",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    SizedBox(height: 10,),
                    Text("10 free deliveries",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("on all orders above ₹199",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 10,),
                    Text("No surge fee, ever!",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("even during rain or peak hours",style: TextStyle(fontSize: 13,color: Colors.grey),),
                    SizedBox(height: 15,),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: faqs.map((faq) {
                    return ExpansionTile(
                      title: Text(faq["question"]!, style: TextStyle(fontSize: 13,),overflow: TextOverflow.ellipsis,maxLines: 3,),
                      children: [
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(faq["answer"]!,overflow: TextOverflow.ellipsis,maxLines: 8,style: TextStyle(fontSize: 12,color: TColors.darkerGrey),),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 70,)
              // Container(
              //   width: double.infinity,
              //   padding: EdgeInsets.all(16),
              //   child: Column(
              //     children: [
              //       Text("YOU GOT A SPECIAL DISCOUNT",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
              //       SizedBox(height: 10,),
              //       Container(
              //         width: double.infinity,
              //         child: ElevatedButton(
              //             onPressed: (){},
              //             style: ElevatedButton.styleFrom(
              //                 backgroundColor: TColors.darkGreen,
              //                 side: BorderSide.none,
              //                 shape: RoundedRectangleBorder(
              //                   borderRadius: BorderRadius.circular(8),
              //                 )
              //             ),
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(vertical: 12),
              //               child: Column(
              //                 children: [
              //                   Text("Buy Zesty Lite at ₹30",style: TextStyle(fontSize: 16,color: Colors.white),),
              //                   Text("for 3 months (GST will apply",style: TextStyle(fontSize: 11,color: Colors.white),),
              //                 ],
              //               ),
              //             )),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
   }
}