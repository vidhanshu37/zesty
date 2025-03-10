import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/screens/home/custom_widget/multi_address_card.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/screens/home/user_profile/add_new_address.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../home.dart';
import '../searchRestaurant.dart';

class AppBarHome extends StatelessWidget {
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
  final box = Hive.box(HiveOpenBox.storeAddress);

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
          color: colorAnimation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder) => AddNewAddress()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: ZMediaQuery(context).width - 180,
                      padding: EdgeInsets.only(right:0, left: 20, top: 10, bottom: 10),
                      child: Text(
                        box.get(HiveOpenBox.storeAddressTitle),
                        // style: Theme.of(context).textTheme.titleMedium,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: colorAnimationAddress.value, overflow: TextOverflow.ellipsis,),
                        maxLines: 2,
                      ),
                    ),
                    IconButton(onPressed: (){}, icon:  Icon(Icons.arrow_drop_down, color: Colors.white,))

                  ],
                ),
              ),

              /// searchbar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18, vertical: 5),
                child: SearchBarHome(
                    searchController: searchController,
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
