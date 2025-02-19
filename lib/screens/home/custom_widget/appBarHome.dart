import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';

import '../home.dart';

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
              ListTile(
                title: Text(
                  widget.address,
                  // style: Theme.of(context).textTheme.titleMedium,
                  style: TextStyle(
                      fontSize: 16,
                      color: colorAnimationAddress.value),
                ),
                subtitle: Text(
                  widget.subAddress,
                  // style: Theme.of(context).textTheme.labelLarge,
                  style: TextStyle(
                      fontSize: 12,
                      color: colorAnimationAddress.value),
                ),
              ),
              SizedBox(
                height: 0,
              ),

              /// searchbar
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 18, vertical: 5),
                child: SearchBarHome(searchController: searchController)
              )
            ],
          ),
        ),
      ),
    );
  }
}
