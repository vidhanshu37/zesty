import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

class ShimmerEffectsLocation extends StatelessWidget {

  const ShimmerEffectsLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return
     Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor:  TColors.grey,
            highlightColor:  TColors.shimmerGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 15,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 10,
                  width: 200,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5)),
                ),
              ],
            ),
          ),
        ],
    );
  }
}
