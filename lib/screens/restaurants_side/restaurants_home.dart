import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;

class RestaurantsHome extends StatefulWidget {
  final String id;
  const RestaurantsHome({super.key,required this.id});

  @override
  State<RestaurantsHome> createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> {
  final TextEditingController searchbarController = TextEditingController();
  final PageController pageController = PageController();
  int _currentIndex = 0;
  String restaurantName = "";
  final List<String> _coupons = [
    "Extra ₹75 off",
    "Flat 10% off above ₹500",
    "Free Delivery on orders ₹199+",
    "Buy 1 Get 1 Free",
    "Save ₹50 on your first order",
  ];

  @override
  void initState() {
    super.initState();
    getRestaurantData(widget.id); //fetch data of restaurant
    Timer.periodic(Duration(seconds: 3), (Timer timer){
      if(_currentIndex < _coupons.length -1){
        _currentIndex++;
      } else{
        _currentIndex = 0;
      }
      pageController.animateToPage(_currentIndex, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Future<void> getRestaurantData(String id) async {
    final url = Uri.parse(ApiConstants.getSingleRestaurantData(id));
    try {
      final response = await http.get(url);
      if (response.statusCode == 200){
        final data = jsonDecode(response.body);
        restaurantName = data['restaurantName'];
        setState(() {

        });
      } else{
        restaurantName = "Fail";
        setState(() {

        });
      }
    } catch(e){
      print(e);
      restaurantName = "Error";
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(22),bottomRight: Radius.circular(22)),
                color: Colors.grey.withOpacity(0.5),
              ),
              child: Padding(padding: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17),
                  ),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(Icons.verified,color: Colors.green,),
                            SizedBox(width: 5,),
                            Text("Pure Veg",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.green),),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Text(restaurantName,style: Theme.of(context).textTheme.headlineLarge,overflow: TextOverflow.ellipsis,maxLines: 2,),
                        SizedBox(height: 5,),
                        Text("15-20 mins • 2.4 km • Katargam",style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,),
                        SizedBox(height: 5,),
                        Text(widget.id,style: TextStyle(color: TColors.darkGrey,fontSize: 12,overflow: TextOverflow.ellipsis,),maxLines: 1,),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 7,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                children: [
                  Container(
                    height: 80,
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: _coupons.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                      return Card(
                        color: TColors.bgLight,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(color: TColors.darkGrey)
                        ),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.local_offer,color: Colors.brown,),
                              SizedBox(width: 5,),
                              Expanded(child: Text(_coupons[index],style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),))
                            ],
                          ),
                        )
                      );
                    },)
                  ),
                  // Positioned(
                  //   right: 5,
                  //     child:Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(5),
                  //         boxShadow: [
                  //           BoxShadow(
                  //             color: Colors.black26,
                  //             blurRadius: 3,
                  //           )
                  //         ]
                  //       ), child: Text("${_currentIndex + 1}/${_coupons.length}",style: TextStyle(fontWeight: FontWeight.bold),),
                  //     ),
                  // ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: SearchBarHome(searchController: searchbarController),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20,width: 20,color: Colors.amber,),
                        SizedBox(height: 5,),
                        Text("Korean paneer Tikka Garlic bread",style: Theme.of(context).textTheme.titleMedium,overflow: TextOverflow.ellipsis,maxLines: 2,),
                        SizedBox(height: 4,),
                        Text("Freshly Baked Stuffed garlic Bread infused with Korean Sweet Chili Sauce,Molten Cheese,Onion and Paneer Tikka Filings.",style: TextStyle(fontSize: 12,color: TColors.darkGrey),overflow: TextOverflow.ellipsis,maxLines: 2,),
                        SizedBox(height: 7,),
                        Text("₹ 200",style: TextStyle(fontSize: 14,color: TColors.darkerGrey,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    width: 130,
                    height: 150,
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network("https://images.immediate.co.uk/production/volatile/sites/30/2020/08/chorizo-mozarella-gnocchi-bake-cropped-9ab73a3.jpg?resize=768,574",width: 130,height: 130,fit: BoxFit.cover,)
                        ),
                        Positioned(
                          bottom: 0,
                          left: 25,
                          child: ElevatedButton(onPressed: (){},
                              style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              elevation: 5,
                              side: BorderSide.none,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),)
                              ),
                              child: Text("ADD",style: TextStyle(color: Colors.black),)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Divider(
                color: TColors.grey.withOpacity(0.5),
              ),
            )
          ],
        ),
      ),
    );
  }
}
