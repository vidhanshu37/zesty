import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
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
      'assets/icons/temp/kabab_b-removebg-preview.png',
      'assets/icons/temp/momo_b-removebg-preview.png',
      'assets/icons/temp/Pastry_b.png',
      'assets/icons/temp/pizza_b-removebg-preview.png',
      'assets/icons/temp/thali_b-removebg-preview.png',
      'assets/icons/temp/veg_b-removebg-preview.png'
    ];

    List<String> title = [
      'Hot day?', // ice-cream
      'Craving something\nsmoky?',
      'Momos so good,',
      'Indulge in pastries',
      'Hot, fresh, delicious',
      'Bringing the flavors\nof India to your plate!',
      'Something light?',
    ];

    List<String> subTitle = [
      'Zesty’s ice cream is just a\ntap away!',
      'Zesty’s seekh kebabs are here',
      'you’ll Zesty them again\nand again!',
      'because you deserve a treat\nand get offers!',
      'Zesty’s pizzas are a slice of\nheaven!',
      '',
      'Salads are here to refresh\njust tap and order!',
    ];

    List<Color> startingColor = [
      Color(0xffedc4b3),
      Color(0xffedc4b3), // pastry-4
    ];
    
    List<Color> endColor = [
      Color(0xff9d6b53),
      Color(0xff9d6b53) // pastry-4
    ];

    return CarouselSlider(
        options: CarouselOptions(
          height: 125,
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
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    // colors: [Color(0xffc1aaa9), Color(0xffa08679)],
                    colors: [TColors.appbarBanner, TColors.Green],
                      tileMode: TileMode.clamp,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight
                  ),
                ),
                width: ZMediaQuery(context).width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title[index], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: TColors.white), maxLines: 1,
                              overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 2,),
                            Text(subTitle[index], style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: TColors.white.withOpacity(0.5)), maxLines: 2, overflow: TextOverflow.ellipsis,),
                            SizedBox(height: 9,),
                            // order now button
                            Container(
                              height: 22,
                              width: 85,
                              decoration: BoxDecoration(
                                  color: TColors.white,
                                borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Center(child: Text("ORDER NOW", style: TextStyle(color: TColors.black, fontSize: 11, fontWeight: FontWeight.w600),)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          width: 120,
                        child: Image.asset(advertisement[index], fit: BoxFit.cover,),
                      ),
                    ],
                  ))),
    ),
      );
  }
}
