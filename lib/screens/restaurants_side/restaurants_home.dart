import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zesty/screens/home/custom_widget/searchbarHome.dart';
import 'package:zesty/utils/constants/colors.dart';

class RestaurantsHome extends StatefulWidget {
  const RestaurantsHome({super.key});

  @override
  State<RestaurantsHome> createState() => _RestaurantsHomeState();
}

class _RestaurantsHomeState extends State<RestaurantsHome> {
  final TextEditingController searchbarController = TextEditingController();
  final PageController pageController = PageController();
  int _currentIndex = 0;

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
                        Text("Jalaram Locho &  Rasawala khaman",style: Theme.of(context).textTheme.headlineLarge,overflow: TextOverflow.ellipsis,maxLines: 2,),
                        SizedBox(height: 5,),
                        Text("15-20 mins • 2.4 km • Katargam",style: TextStyle(fontSize: 14),overflow: TextOverflow.ellipsis,maxLines: 1,),
                        SizedBox(height: 5,),
                        Text("Gujarati,snacks",style: TextStyle(color: TColors.darkGrey,fontSize: 12,overflow: TextOverflow.ellipsis,),maxLines: 1,),
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
          ],
        ),
      ),
    );
  }
}
