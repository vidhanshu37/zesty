import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:http/http.dart' as http;

import '../../../utils/constants/colors.dart';
import '../../restaurants_side/custom_widget/mart_itemCard.dart';
class KidsTab extends StatefulWidget {
  const KidsTab({super.key});

  @override
  State<KidsTab> createState() => _KidsTabState();
}

class _KidsTabState extends State<KidsTab> {
  List kidsMartItem = [];
  int _currentIndex = 0;

  final List<String> imageList = [
    'assets/images/adv1.avif',
    'assets/images/adv2.avif',
    'assets/images/adv3.avif',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchFreshMartItem();
  }
  Future<void> fetchFreshMartItem() async {
    final url = Uri.parse(
        "https://zesty-backend.onrender.com/zestyMart/get-category-wise/Kids");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        kidsMartItem = jsonDecode(response.body);
        //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("success - ${response.statusCode}")));
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Something went wrong - ${response.statusCode}")));
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 180,
                      autoPlay: true,
                      autoPlayInterval: Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                    ),
                    items: imageList.map((imagePath) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: AvifImage.asset(
                          imagePath,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      );
                    }).toList(),
                  ),
                  // Dot Indicator
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: imageList.asMap().entries.map((entry) {
                        return Container(
                          width: _currentIndex == entry.key ? 10 : 8,
                          height: _currentIndex == entry.key ? 10 : 8,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentIndex == entry.key
                                ? Colors.black
                                : TColors.grey,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        ),

        SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 240,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return martItemCard(
                imgId: kidsMartItem[index]['_id'],
                name: kidsMartItem[index]['name'],
                weight: kidsMartItem[index]['weight'],
                price: kidsMartItem[index]['price'],
                images: kidsMartItem[index]['images'],
                id: kidsMartItem[index]['_id'],
              );
            },
            childCount: kidsMartItem.length,
          ),
        )
      ],
    );
  }
}
