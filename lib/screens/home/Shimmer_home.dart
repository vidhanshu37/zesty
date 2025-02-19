import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zesty/utils/constants/media_query.dart';

import '../../utils/constants/colors.dart';

class ShimmerHome extends StatelessWidget {
  const ShimmerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ZMediaQuery(context).height - 20,
        width: ZMediaQuery(context).width,
        child: Shimmer.fromColors(
            baseColor: ZMediaQuery(context).isDarkMode
                ? TColors.darkerGrey
                : TColors.grey.withValues(alpha: 0.4),
            highlightColor: ZMediaQuery(context).isDarkMode
                ? TColors.darkGrey
                : TColors.shimmerGrey.withValues(alpha: 0.4),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Address and Sub-address
                  SizedBox(
                    height: 25,
                  ),
                  ListTile(
                      title: Container(
                        height: 13,
                        decoration: BoxDecoration(
                            color: TColors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      leading: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: TColors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                      ),
                      subtitle: Container(
                        height: 9,
                        decoration: BoxDecoration(
                            color: TColors.white,
                            borderRadius: BorderRadius.circular(12.0)),
                      )),

                  /// Grid builder - 2 horizontal
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 170,
                    child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 17,
                            mainAxisSpacing: 17,
                            childAspectRatio: 1),
                        scrollDirection: Axis.horizontal,
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                                color: TColors.white,
                                borderRadius: BorderRadius.circular(10.0)),
                          );
                        }),
                  ),

                  /// Vertical Container
                  Expanded(
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 170,
                            decoration: BoxDecoration(
                                color: TColors.white,
                                borderRadius: BorderRadius.circular(12.0)),
                          );
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
