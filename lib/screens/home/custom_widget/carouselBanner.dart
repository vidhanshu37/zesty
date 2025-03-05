import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/constants/media_query.dart';

class carouselBanner extends StatefulWidget {
  @override
  _carouselBannerState createState() => _carouselBannerState();
}

class _carouselBannerState extends State<carouselBanner> {

  List imageadv = [];

  @override
  void initState() {
    super.initState();
    fetchAdvData();
  }

  Future<void> fetchAdvData() async {
    final url = Uri.parse("https://zesty-backend.onrender.com/ad/get-all-ads");

    try{
      final response = await http.get(url);
      if (response.statusCode == 200){
       imageadv = jsonDecode(response.body);
        print("Success");
      } else {
        print("Fail");
      }

    } catch (e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

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
      imageadv.length,
          (index) => ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: SizedBox(
              height: 175,
              width: ZMediaQuery(context).width - 50,
              child: Image.network(
                '${imageadv[index]['image']}',
                fit: BoxFit.cover,
              ),
            ),
          ),
    ),
      );
  }
}
