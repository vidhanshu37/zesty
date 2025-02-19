import 'package:flutter/material.dart';
import 'package:zesty/screens/home/user_profile/add_balance.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/zesty_money.dart';

class MoneyGift extends StatefulWidget {
  const MoneyGift({super.key});

  @override
  State<MoneyGift> createState() => _MoneyGiftState();
}

class _MoneyGiftState extends State<MoneyGift> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         // title: Row(
         //   crossAxisAlignment: CrossAxisAlignment.center,
         //   children: [
         //     Text("Zesty",style: Theme.of(context).textTheme.headlineLarge,),
         //     SizedBox(width: 5,),
         //     Text("Money",style: TextStyle(fontSize: 18)),
         //   ],
         // ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Zesty",style: Theme.of(context).textTheme.headlineLarge,),
              SizedBox(width: 5,),
              Text("Money",style: TextStyle(fontSize: 20),),
              SizedBox(width: 150,),
            ],
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
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
                    Text("₹${ZestyMoney.walletAmount}",style: TextStyle(fontSize: 28,color: Colors.white,fontWeight: FontWeight.bold),),
                    Divider(),
                    SizedBox(height: 12,),
                    Text("Zesty money can be used for all your orders across categories ( Food, Zestymart & more )",style: TextStyle(color: Colors.white70,fontSize: 12),),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(15.0),
            //   child: Card(
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12)
            //     ),
            //     child: Padding(
            //       padding: const EdgeInsets.all(15.0),
            //       child: Row(
            //         children: [
            //           Expanded(
            //               child: Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text("Share love through e-gift vouchers!",style: TextStyle(fontWeight: FontWeight.bold),),
            //                   SizedBox(height: 4,),
            //                   Text("Celebrate special occasions with your loved ones"),
            //                   SizedBox(height: 8,),
            //                   Text("Buy a gift voucher",style: TextStyle(color: TColors.orange,fontWeight: FontWeight.bold),),
            //                 ],
            //               ),
            //           ),
            //           // Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Gift_card.svg/512px-Gift_card.svg.png',height: 50,),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            SizedBox(height: 30,),
            Text("Transition History",style: TextStyle(fontSize: 20,color: Colors.grey),),
            SizedBox(height: 330,),
            Container(
              height: 130,
              color: Colors.grey.shade300,
              child: Column(
                children: [
                  SizedBox(height: 20,),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Have a gift voucher?",style: TextStyle(color: TColors.black),),
                      TextButton(onPressed: (){}, child: Text("Redeem Now",style: TextStyle(color: Colors.green,fontSize: 16),)),
                    ],
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
