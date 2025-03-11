import 'dart:convert';

import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/add_manually_address/confirmLocation.dart';
import 'package:zesty/screens/home/custom_widget/multi_address_card.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/screens/home/user_profile/add_new_address.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/colors.dart';
import '../home.dart';
import '../searchRestaurant.dart';

class AppBarHome extends StatefulWidget {
   AppBarHome({
    super.key,
    required this.colorAnimation,
    required this.widget,
    required this.colorAnimationAddress,
    required this.searchController,
  });

  final Animation<Color?> colorAnimation;
  final HomeScreen widget;
  final Animation<Color?> colorAnimationAddress;
  final TextEditingController searchController;

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome> {

  final box = Hive.box(HiveOpenBox.storeAddress);

  List addresses = [];
  Future<void> fetchAddress() async {
    Map<String, dynamic> userAllData = {};
    final url = Uri.parse('https://zesty-backend.onrender.com/user/get/${box.get(HiveOpenBox.userId)}');
    try{
      final response = await http.get(url);
      if ( response.statusCode == 200 ) {
        userAllData = jsonDecode(response.body);
        addresses = userAllData['address'];
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  // void showAddressDialog() async {
  //   showModalBottomSheet(context: context,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //       ),
  //       // elevation: 1,
  //       // isScrollControlled: true,
  //       transitionAnimationController: AnimationController(
  //         vsync: Navigator.of(context),
  //         duration: Duration(milliseconds: 500), // Adjust speed
  //       ),
  //       backgroundColor: TColors.bgLight,
  //       builder: (builder) {
  //         return SizedBox(
  //           width: ZMediaQuery(context).width,
  //           child: Padding(
  //             padding: EdgeInsets.all(16.0),
  //             child: Stack(
  //               children: [
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Text("SELECT ADDRESS", style: Theme.of(context).textTheme.titleMedium,),
  //                         IconButton(onPressed: (){
  //                           Navigator.pop(context);
  //                         }, icon: Icon(Icons.close))
  //                       ],
  //                     ),
  //                     SizedBox(height: 20,),
  //                     Expanded(
  //                       child: ListView.builder(
  //                           itemCount: addresses.length,
  //                           itemBuilder: (context, index) {
  //                             return MultiAddressCard(address: addresses[index], box: box, index: index, context: context, onSelect: () {
  //                               setState(() {});
  //                             },);
  //                           }),
  //                     ),
  //                     SizedBox(height: 100,),
  //                   ],
  //                 ),
  //                 Positioned(
  //                   bottom: 0,
  //                     left: 0,
  //                     right: 0,
  //                     child: Container(
  //                       width: ZMediaQuery(context).width,
  //                         padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
  //                         // color: TColors.Green,
  //                         child: Center(child: ZElevatedButton(title: "ADD ADDRESS", onPress: (){}))))
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  // }

  void showAddressDialog() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-screen height expansion
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      backgroundColor: TColors.bgLight,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7, // 80% of screen height
          minChildSize: 0.5, // 50% minimum height
          maxChildSize: 1.0, // Full screen height
          expand: false,
          builder: (context, scrollController) {
            return Container(
              width: ZMediaQuery(context).width,
              padding: EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "SELECT ADDRESS",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.close),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController, // Enables smooth scrolling
                          itemCount: addresses.length,
                          itemBuilder: (context, index) {
                            return MultiAddressCard(
                              address: addresses[index],
                              box: box,
                              index: index,
                              context: context,
                              onSelect: () {
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: ZMediaQuery(context).width,
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: Center(
                        child: ZElevatedButton(
                          title: "ADD ADDRESS",
                          onPress: () {
                            // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Home address sheet")));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ConfirmLocation()));

                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    fetchAddress();
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // pinned: true,
      snap: true,
      collapsedHeight: 120,
      floating: true,
      centerTitle: false,
      expandedHeight: 120,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: widget.colorAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  addresses.isEmpty ? null : showAddressDialog();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: ZMediaQuery(context).width - 200,
                      padding: EdgeInsets.only(right:0, left: 20, top: 10, bottom: 10),
                      child: ValueListenableBuilder(
                        valueListenable: Hive.box(HiveOpenBox.storeAddress).listenable(),
                        builder: (context, Box box, _) {
                          return Text(
                            box.get(HiveOpenBox.storeAddressTitle),
                            // style: Theme.of(context).textTheme.titleMedium,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: widget.colorAnimationAddress.value, overflow: TextOverflow.ellipsis,),
                            maxLines: 2,
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10,),
                    Icon(Icons.keyboard_arrow_down_sharp, color: widget.colorAnimationAddress.value,),
                  ],
                ),
              ),

              /// searchbar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18, vertical: 5),
                child: SearchBarHome(
                    searchController: widget.searchController,
                  readOnly: true,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Searchrestaurant(),));
                  },
                )
              )
            ],
          ),
        ),
      ),
    );
  }
}
