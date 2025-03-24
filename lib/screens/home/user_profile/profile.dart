import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zesty/screens/home/user_profile/add_new_address.dart';
import 'package:zesty/screens/home/user_profile/editProfile.dart';
import 'package:zesty/screens/home/user_profile/money_Gift_Cards.dart';
import 'package:zesty/screens/home/user_profile/zesty1.dart';
import 'package:zesty/screens/home/user_profile/zestyLiteActive.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import 'favouritesResturant.dart';

class profile extends StatefulWidget{
  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {

  var box = Hive.box(HiveOpenBox.storeAddress);

  void showLogoutDialog() {
    showDialog(context: context, builder: (builder) => AlertDialog(
      title: Text("Are you sure want to logout?"),
      content: Text("You will be logged out of your account. You can log in again anytime."),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
          box.clear(); // storeAddress
          Hive.box(HiveOpenBox.zestyFoodCart).clear();
          Hive.box(HiveOpenBox.storeZestyMartItem).clear();
          Hive.box(HiveOpenBox.storeLatLongTable).clear();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => signin()), (_) =>  false);
        }, child: Text("Logout", style: TextStyle(color: TColors.error),)),
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Cancel", style: TextStyle(color: Colors.black),))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("USER PROFILE", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: TColors.grey,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              ValueListenableBuilder(
                  valueListenable: Hive.box(HiveOpenBox.storeAddress).listenable(),
                  builder: (context, Box box, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(box.get(HiveOpenBox.userName, defaultValue: "Zesty"),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                        Text("+91 ${box.get(HiveOpenBox.userMobile)}",style: TextStyle(color: TColors.darkerGrey,fontSize: 12)),
                      ],
                    );
                  },
              ),
              SizedBox(height: 10,),
              InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => EditAccountScreen(),));
              },child: Text("Edit Profile  >",style: TextStyle(color: TColors.darkGreen,fontWeight: FontWeight.bold,fontSize: 15),),),
              Divider(),
              SizedBox(height: 10,),

              /// zesty lite

              box.get(HiveOpenBox.userZestyLite) == "true" ? SizedBox.shrink() : Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12,vertical: 6),
                    decoration: BoxDecoration(
                      color: TColors.darkGreen,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("ZESTY ONE",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 10)),
                  ),
                  SizedBox(width: 6,),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                    decoration: BoxDecoration(
                      //color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text("JOIN NOW",style: TextStyle(color: TColors.darkGreen,fontSize: 12)),
                  ),
                ],
              ),
            box.get(HiveOpenBox.userZestyLite) == "true" ?  ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("ZestyLite",style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text("Tap to see your benefits",style: Theme.of(context).textTheme.labelMedium),
              trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ZestyLiteActive(zestyMartOrder: box.get(HiveOpenBox.zestyMartLiteOrder, defaultValue: 0), zestyOrder: box.get(HiveOpenBox.zestyLiteOrder, defaultValue: 0),),));
              },
            ) : ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text("20 Free Deliveries on Food & Zesty Mart",style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text("join now & unlock exclusive benefits",style: Theme.of(context).textTheme.labelMedium),
              trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => zesty1(),));
              },
            ),

              /// address
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Addresses",style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text("Share,Edit & Add New Addresses",style: Theme.of(context).textTheme.labelMedium),
                trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewAddress(),));
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("My Account",style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text("Favourites Restaurants",style: Theme.of(context).textTheme.labelMedium),
                trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LikedRestaurantsPage(),));
                },
              ),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text("Zesty Money",style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text("Add zesty account balance",style: Theme.of(context).textTheme.labelMedium),
                trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MoneyGift(),));
                },
              ),
              // Divider(),
              // menuItem("Past Order", "Track Your Previous Order"),
              // Text("PAST ORDER",style: TextStyle(fontSize: 16),),
              // SizedBox(height: 10,),
              // Card(
              //   elevation: 1,
              //   color: Colors.white,
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(1),
              //   ),
              //   child: Padding(
              //     padding: const EdgeInsets.all(10),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("Mahalaxmi Juice And Fast Food Corner",style: Theme.of(context).textTheme.titleLarge),
              //         SizedBox(height: 4,),
              //         Text("Adajan Patiya",style: TextStyle(fontSize: 15,color: Colors.grey),),
              //         SizedBox(height: 6,),
              //         Text("Rs. 110",style: TextStyle(fontSize: 14,color: Colors.grey),),
              //         SizedBox(height: 8,),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             ElevatedButton(onPressed: (){}, child: Text("REORDER")),
              //             ElevatedButton(onPressed: (){}, child: Text("RATE ORDER")),
              //           ],
              //         )
              //       ],
              //     ),
              //   ),
              // ),

              SizedBox(height: 130,),
              // ListTile(
              //   title: Text("LOGOUT OPTION",style: Theme.of(context).textTheme.headlineSmall),
              //   trailing: Icon(Icons.arrow_forward_ios,color: Colors.grey,size: 16,),
              //   onTap: (){},
              // )
              Container(
                  height: 55,
                  width: ZMediaQuery(context).width,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: TColors.error,width: 2),
                          foregroundColor: TColors.error,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      ),
                      onPressed: (){
                        showLogoutDialog();
                      }, child: Text("LOGOUT",style: TextStyle(fontSize: 17,color: TColors.error),))),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget menuItem(String title,String subtitle){
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title,style: Theme.of(context).textTheme.titleLarge),
      subtitle: Text(subtitle,style: Theme.of(context).textTheme.labelMedium),
      trailing: Icon(Icons.arrow_forward_ios,color: TColors.darkGrey,size: 16,),
      onTap: (){},
    );
  }
}