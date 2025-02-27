import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/textfield_cust.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

class Coupons extends StatefulWidget {
  const Coupons({super.key});

  @override
  State<Coupons> createState() => _CouponsState();
}

class _CouponsState extends State<Coupons> {
  TextEditingController searchCoupon = TextEditingController();

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
              "Your cart: 240",
              style: Theme.of(context).textTheme.labelMedium,
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Coupon Search-bar
            SizedBox(height: 10,),
            Stack(children: [
              ZCustomTextField(
                controller: searchCoupon,
                hintText: "Enter Coupon Code",
              ),
              Positioned(
                  right: 0,
                  child: Container(
                    height: 55,
                    width: ZMediaQuery(context).width * 0.27,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
                    ),
                    child: Center(child: Text("Apply", style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),)),
                  ))
            ]),
            SizedBox(height: 40,),

            Text("Best coupon", style: Theme.of(context).textTheme.titleMedium,),
            SizedBox(height: 20,),

            /// Coupon content
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: TColors.bgLight,
                    borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: TColors.grey,
                          blurRadius: 3,
                          spreadRadius: 2,
                          offset: Offset(5, 6)
                        )
                      ]
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      height: 200,
                      width: ZMediaQuery(context).width * 0.20,
                      decoration: BoxDecoration(
                        color: Color(0xffCAE97C),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),

                      ),
                    )),
              ],
            )


          ],
        ),
      ),
    );
  }
}
