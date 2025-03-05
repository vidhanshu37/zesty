import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/utils/constants/media_query.dart';

import '../home.dart';
import '../searchRestaurant.dart';

class AppBarHome extends StatelessWidget {
  const AppBarHome({
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
              Container(
                width: ZMediaQuery(context).width - 200,
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Text(
                  widget.address,
                  // style: Theme.of(context).textTheme.titleMedium,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: colorAnimationAddress.value, overflow: TextOverflow.ellipsis,),
                  maxLines: 2,
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
