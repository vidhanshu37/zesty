import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:zesty/screens/home/Shimmer_home.dart';
import 'package:zesty/screens/home/zesty_Mart/beauty_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/beautyCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/electronicCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/freshCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/groceryCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/homeCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/category_Item/kidsCategory.dart';
import 'package:zesty/screens/home/zesty_Mart/electronics_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/home_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/kids_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
import 'package:zesty/utils/constants/media_query.dart';
import '../../../utils/constants/colors.dart';
import '../../restaurants_side/custom_widget/mart_itemCard.dart';

class AllTab extends StatefulWidget {
  const AllTab({super.key});

  @override
  State<AllTab> createState() => _AllTabState();
}

class _AllTabState extends State<AllTab> {
  List allMartItem = [];
  int _currentIndex = 0;

  final List<Map<String, String>> items = [
    {"name": "Fruits", "image": "assets/images/fFresh.png"},
    {"name": "Grocery", "image": "assets/images/Grocery.png"},
    {"name": "Skin Care", "image": "assets/images/Beauty.png"},
    {"name": "Electronics", "image": "assets/images/Electronic.png"},
    {"name": "Home", "image": "assets/images/Home.png"},
    {"name": "Kids", "image": "assets/images/Kids.png"},
    {"name": "Vegetable", "image": "assets/images/Fresh.png"},
    {"name": "Biscuits", "image": "assets/images/Grocerry2.png"},
  ];

  final List<String> imageList = [
    'assets/images/adv1.avif',
    'assets/images/adv2.avif',
    'assets/images/adv3.avif',
  ];

  @override
  void initState() {
    super.initState();
    fetchFreshMartItem();
  }

  Future<void> fetchFreshMartItem() async {
    final url = Uri.parse(
        "https://zesty-backend.onrender.com/zestyMart/get-all-martItem");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        allMartItem = jsonDecode(response.body);
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
    return allMartItem.isEmpty ? Center(child: Lottie.asset('assets/lottie/zestyMart_loader.json', height: 200, width: 200),)
        : CustomScrollView(
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

                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 240,
                    child: GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            String selectedCategory = items[index]["name"]!;
                            if (selectedCategory == "Fruits" || selectedCategory == "Vegetable"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Freshcategory()));
                            } else if (selectedCategory == 'Grocery' || selectedCategory == "Biscuits"){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Grocerycategory()));
                            } else if (selectedCategory == 'Skin Care'){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Beautycategory()));
                            } else if (selectedCategory == 'Electronics'){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Electroniccategory()));
                            } else if (selectedCategory == 'Home'){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Homecategory()));
                            } else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Kidscategory()));
                            }
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.0), // Adjust for rounded corners; set to 0 for a perfect square
                                child: Image.asset(
                                  items[index]["image"]!,
                                  width: 65,
                                  height: 65,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                items[index]["name"]!,
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                SizedBox(height: 10,),
              ]
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.all(10.0),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 240,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return martItemCard(
                  imgId: allMartItem[index]['_id'],
                  name: allMartItem[index]['name'],
                  weight: allMartItem[index]['weight'],
                  price: allMartItem[index]['price'],
                  images: allMartItem[index]['images'],
                  id: allMartItem[index]['_id'],
                );
              },
              childCount: allMartItem.length,
            ),
          ),
        ),
      ],
    );
  }
}
