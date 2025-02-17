import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:zesty/utils/constants/colors.dart';

import '../../utils/constants/media_query.dart';

class zesty1 extends StatefulWidget{
  @override
  State<zesty1> createState() => _zesty1State();
}

class _zesty1State extends State<zesty1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back,color: ZMediaQuery(context).isDarkMode ? Colors.white : Colors.black,)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Zesty",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
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
              SizedBox(height: 3,),
              Center(child: Text("Heavy Benefits, Lite Price!",style: TextStyle(fontSize: 17,color: Colors.black),)),
              SizedBox(height: 8,),
              Divider(),
              SizedBox(height: 10,),
              Card(
                elevation: 4,
                child: Column(
                  children: [
                    SizedBox(height: 3,),
                    Container(
                      width: double.infinity,
                        color: TColors.darkGreen.withOpacity(0.3),
                        child: Center(child: Text("3 MONTHS PLAN",style: TextStyle(fontSize: 14,color: TColors.darkGreen),))
                    ),
                    SizedBox(height: 7,),
                    SizedBox(
                      height: 70,
                        width: 100,
                        child: AvifImage.asset('assets/icons/food_category/Pizza.avif', fit: BoxFit.cover,)
                    ),
                    SizedBox(height: 13,),
                    Text("Unlock 20 Free Deliveries",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold,color: TColors.orange),),
                    Text("10 on Food + 10 on Zestymart",style: TextStyle(fontSize: 15,color: TColors.darkerGrey),),
                    SizedBox(height: 22,),
                    ElevatedButton(onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          )
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 20),
                          child: Column(
                            children: [
                              Text("Buy One Lite at Rs.15",style: TextStyle(fontSize: 16,color: Colors.white),),
                              Text("for 3 months (GST will apply)",style: TextStyle(fontSize: 16,color: Colors.white),)
                            ],
                          ),
                        ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              SizedBox(height: 20,),
              Text("ONE LITE BENEFITS",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: TColors.darkerGrey),),
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TColors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      spreadRadius: 2
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
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10,),
                    Text("Food",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: TColors.darkGreen),),
                    SizedBox(height: 5,),
                    Text("10 free deliveries",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,color: Colors.black),),
                    SizedBox(height: 3,),
                    Text("on all restauants up to 7 km,",style: TextStyle(fontSize: 10,color: Colors.grey),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
   }
}