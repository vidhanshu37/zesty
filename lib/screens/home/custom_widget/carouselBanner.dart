import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

class carouselBanner extends StatefulWidget {
  @override
  _carouselBannerState createState() => _carouselBannerState();
}

class _carouselBannerState extends State<carouselBanner> {
  @override
  Widget build(BuildContext context) {


    List<String> advertisement = [
      'assets/icons/temp/Ice Cream_b.png',
      'assets/icons/temp/kabab_b.png',
      'assets/icons/temp/momo_b.png',
      'assets/icons/temp/Pastry_b.png',
      'assets/icons/temp/pizza_b.png',
      'assets/icons/temp/thali_b.png',
      'assets/icons/temp/veg_b.png'
    ];


    return CarouselSlider(
        options: CarouselOptions(
          height: 120,
          autoPlay: true,  // Enable auto-play
          autoPlayInterval: Duration(seconds: 5), // Interval between auto-play
          autoPlayAnimationDuration: Duration(milliseconds: 1000), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
          enlargeCenterPage: true, // Enlarge the center page for focus
        ),
        items: List.generate(
      advertisement.length,
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: TColors.white,
                height: double.infinity,
                width: ZMediaQuery(context).width - 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Hidden gems for you!", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
                            SizedBox(height: 2,),
                            Text("Try amazing spots\n& surprise yourself.", style: Theme.of(context).textTheme.labelSmall,),
                            SizedBox(height: 10,),
                            // order now button
                            Container(
                              height: 22,
                              width: 85,
                              decoration: BoxDecoration(
                                  color: TColors.warning,
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Center(child: Text("ORDER NOW", style: TextStyle(color: TColors.white, fontSize: 11, fontWeight: FontWeight.w600),)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 120,
                          // child: AvifImage.asset(advertisementBanner[index], fit: BoxFit.cover,)
                        child: Image.asset(advertisement[index], fit: BoxFit.cover,),
                      ),
                    ],
                  ))),
    ),
      );
  }
}
