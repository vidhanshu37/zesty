import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zesty/custom_widget/textfield_cust.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:http/http.dart' as http;

class Coupons extends StatefulWidget {

  final VoidCallback updateCartUI;
  final double calculateTotalCartValue;

  const Coupons({super.key, required this.updateCartUI, required this.calculateTotalCartValue});

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  TextEditingController searchCoupon = TextEditingController();

  List couponData = [];
  List filterCouponData = [];

  @override
  void initState() {
    super.initState();
    fetchCouponsData();
  }

  /// Fetch data from API
  Future<void> fetchCouponsData() async {
    final url = Uri.parse(ApiConstants.getCouponData);
    try{
      final response = await http.get(url);
      couponData = jsonDecode(response.body);
      setState(() {});
    } catch(e) {
      print(e);
    }
  }

  void filterSearchResult(String query){
    if (query.isEmpty){
       setState(() {
         filterCouponData = couponData;
       });
    } else {
      setState(() {
        filterCouponData = couponData.where((item) {
          String itemName = item['promoCode'].toString();
          return itemName.contains(query.toUpperCase());
        },).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "APPLY COUPON",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              "Your cart: ${widget.calculateTotalCartValue}",
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
      ),
      body: couponData.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.black,)) : Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Coupon Search-bar
            SizedBox(height: 10,),
            Stack(children: [
              ZCustomTextField(
                controller: searchCoupon,
                prefixIcon: Icons.search,
                prefixIconColor: TColors.darkGrey,
                hintText: "Enter Coupon Code",
                onChanged: filterSearchResult,
              ),
            ]),
            SizedBox(height: 40,),

            Text("Best coupon", style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 20,),

            /// Coupon content
            Expanded(
              child: searchCoupon.text == ""
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: couponData.length,
                      itemBuilder: (context, index) {
                        return CouponCard(
                          promoCode: couponData[index]['promoCode'],
                          discountUpto: couponData[index]['discountUpto'],
                          minAmtReq: couponData[index]['minAmtReq'],
                          discountPercentage: couponData[index]['discountPercentage'],
                          description: couponData[index]['description'],
                          updateCartUI: widget.updateCartUI,
                          calculateTotalCartValue: widget.calculateTotalCartValue,
                        );
                      })
                  :  ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: filterCouponData.length,
                  itemBuilder: (context, index) {
                    final itemList = filterCouponData;
                    return CouponCard(
                        promoCode: itemList[index]['promoCode'],
                        discountUpto: itemList[index]['discountUpto'],
                        minAmtReq: itemList[index]['minAmtReq'],
                        discountPercentage: itemList[index]['discountPercentage'],
                        description: itemList[index]['description'],
                        updateCartUI: widget.updateCartUI,
                        calculateTotalCartValue: widget.calculateTotalCartValue,
                    );
              }),
            ),


            searchCoupon.text.isNotEmpty && filterCouponData.length == 0 ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
                child: Text('No results found for "${searchCoupon.text}"', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),),
              ) : SizedBox.shrink() ,
          ],
        ),
      ),
    );
  }
}

class CouponCard extends StatelessWidget {
  final String promoCode;
  final String discountUpto;
  final String minAmtReq;
  final String discountPercentage;
  final String description;
  final VoidCallback updateCartUI;
  final double calculateTotalCartValue;

  const CouponCard({
    super.key,
    required this.promoCode,
    required this.discountUpto,
  required this.minAmtReq,
  required this.discountPercentage,
    required this.description,
    required this.updateCartUI,
    required this.calculateTotalCartValue,
});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Stack(
        children: [
          /// Content of coupon
          Container(
            height: 210,
            width: double.infinity,
            decoration: BoxDecoration(
              color: TColors.bgLight,
              borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: TColors.grey,
                    blurRadius: 3,
                    spreadRadius: 2,
                    offset: Offset(0, 1)
                  )
                ]
            ),
            child: Padding(
              padding: EdgeInsets.only(left: (ZMediaQuery(context).width * 0.20) + 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(promoCode, style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),),
                      IconButton(onPressed: () {
                        Clipboard.setData(ClipboardData(text: promoCode));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Coupon code copied!"), duration: Duration(seconds: 1),));
                      }, icon: Icon(Icons.copy, size: 18,)),
                    ],
                  ),
                  Text(description, style: TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis), maxLines: 2,),
                  SizedBox(height: 10,),
                  Divider(color: TColors.grey,),
                  SizedBox(height: 10,),
                  Text("You can get $discountPercentage% discount on minimum $minAmtReq spend and claim discount upto $discountUpto.", style: TextStyle(fontSize: 14, color: TColors.darkGrey, fontWeight: FontWeight.normal, overflow: TextOverflow.ellipsis), maxLines: 3,),
                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),

          /// Front green portion
          Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: 210,
                width: ZMediaQuery(context).width * 0.20,
                decoration: BoxDecoration(
                  color: Color(0xffCAE97C),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),

                ),
              )),

          /// APPLY button on each coupon
          Positioned(
            right: 12,
              top: 20,
              child: InkWell(
                onTap: () {
                  if( calculateTotalCartValue > double.parse(minAmtReq) ) {
                    updateCartUI();
                    Navigator.pop(context, {'discountUpto' : discountUpto, 'minAmtReq':minAmtReq, 'discountPercentage':discountPercentage, 'promoCode': promoCode});
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Cart must contain minimum ₹$minAmtReq to apply!")));
                  }
                },
                  child: Text("APPLY", style: TextStyle(fontSize: 15, color: TColors.darkGreen, fontWeight: FontWeight.bold),)))
        ],
      ),
    );
  }
}
