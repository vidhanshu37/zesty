import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/media_query.dart';

class appBarBanner extends StatelessWidget {
  const appBarBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 140,
      // title: Text("Zesty"), // title
      centerTitle: false,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          height: 140,
          width: ZMediaQuery(context).width,
          decoration: BoxDecoration(
            color: TColors.ligthGreen,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  height: 140,
                  width: 80,
                  child: AvifImage.asset('assets/icons/appbar_image/Veggies_new.avif',
                      fit: BoxFit.cover)),
              Text(
                "\nBest deals of\n\t\t\t  the day!",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Container(
                height: 140,
                width: 80,
                child: AvifImage.asset('assets/icons/appbar_image/Sushi_replace.avif',
                    fit: BoxFit.cover),
              )
            ],
          ),
        ),
      ),
    );
  }
}
