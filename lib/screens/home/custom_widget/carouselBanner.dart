import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class carouselBanner extends StatefulWidget {
  @override
  _carouselBannerState createState() => _carouselBannerState();
}

class _carouselBannerState extends State<carouselBanner> {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
        options: CarouselOptions(
          height: 150,
          autoPlay: true,  // Enable auto-play
          autoPlayInterval: Duration(seconds: 5), // Interval between auto-play
          autoPlayAnimationDuration: Duration(milliseconds: 1000), // Animation duration
          autoPlayCurve: Curves.fastOutSlowIn, // Animation curve
          enlargeCenterPage: true, // Enlarge the center page for focus
        ),
        items: List.generate(
          10, // Number of items
              (index) => Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage("https://picsum.photos/200/300?random=$index"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
  }
}
