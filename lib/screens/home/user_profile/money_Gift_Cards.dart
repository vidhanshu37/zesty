import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/screens/home/user_profile/add_balance.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/zesty_money.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

class MoneyGift extends StatefulWidget {
  const MoneyGift({super.key});

  @override
  State<MoneyGift> createState() => _MoneyGiftState();
}

class _MoneyGiftState extends State<MoneyGift> {

  var box = Hive.box(HiveOpenBox.storeAddress);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: Text("Zesty Money", style: TextStyle(color: Colors.black, fontSize: 18),),
      ),
      body: Stack(
        children: [

          /// Main card - show available balance
          Positioned(
            left: 0,
            top: 10,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.green.shade400,TColors.card],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text("Available Balance",style: TextStyle(fontSize: 16,color: Colors.white),),
                    SizedBox(height: 1,),
                    SizedBox(
                      width: 120,
                        height: 40,
                        child: Text("₹${box.get(HiveOpenBox.userZestyMoney)}",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.bold),)),
                    Divider(),
                    SizedBox(height: 12,),
                    Text("Zesty money can be used for all your orders across categories ( Food, Zestymart & more )",style: TextStyle(color: Colors.white70,fontSize: 12),),
                  ],
                ),
              ),
            ),
          ),

          /// Bottom button (sheet)
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              height: 130,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(16.0), topRight: Radius.circular(16.0))
              ),
              child: Column(
                children: [
                  SizedBox(height: 30,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15,vertical: 2),
                    width: double.infinity,
                    height: 53,
                    child: ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => AddBalance(),));
                    },
                        style: ElevatedButton.styleFrom(
                          side: BorderSide.none,
                          backgroundColor: TColors.card,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text("Add Balance",style: TextStyle(color: Colors.white,fontSize: 16),)
                    ),
                  ),
                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}
