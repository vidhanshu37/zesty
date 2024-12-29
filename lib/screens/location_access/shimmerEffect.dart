import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

class ShimmerEffects extends StatelessWidget {
  final int itemCount;

  const ShimmerEffects({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            // Wrap the Shimmer content in Expanded
            child: Shimmer.fromColors(
              baseColor: ZMediaQuery(context).isDarkMode
                  ? TColors.darkerGrey
                  : TColors.grey,
              highlightColor: ZMediaQuery(context).isDarkMode
                  ? TColors.darkGrey
                  : TColors.softGrey,
              child: ListView.builder(
                itemCount: itemCount,
                itemBuilder: (context, index) {
                  return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                      child: Row(
                        children: [
                          // Container(
                          //   height: 35,
                          //   width: 35,
                          //   decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(5),
                          //       color: Colors.white),
                          // ),
                          // SizedBox(
                          //   width: 20,
                          // ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 15,
                                width: ZMediaQuery(context).width,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                height: 10,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5)),
                              ),
                            ],
                          ))
                        ],
                      ));
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
