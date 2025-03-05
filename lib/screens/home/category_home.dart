import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';

import '../../utils/constants/api_constants.dart';
import '../restaurants_side/restaurants_home.dart';

class CategoryHome extends StatefulWidget {

  final String categoryImageId, categoryName;
  const CategoryHome({super.key, required this.categoryImageId, required this.categoryName});

  @override
  State<CategoryHome> createState() => _CategoryHomeState();
}

class _CategoryHomeState extends State<CategoryHome> {

  List categoryRestaurantData = [];
  var box = Hive.box(HiveOpenBox.storeAddress);

  Future<void> FatchCategoryData() async {
    final url = Uri.parse("https://zesty-backend.onrender.com/menu/get-category-wise-restaurants/${widget.categoryName}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        categoryRestaurantData = jsonDecode(response.body);
        setState(() {
        });

      } else{
        print("Fail");
      }

    } catch (e){
      print(e.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FatchCategoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: categoryRestaurantData.isEmpty ? Center(child: CircularProgressIndicator(color: TColors.black,),) : CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: TColors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60,vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text(widget.categoryName,style: TextStyle(color: TColors.black,fontWeight: FontWeight.bold,fontSize: 20),),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 10),
              child: Text("Restaurant to explore",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
            ),
          ),

          SliverList.builder(
              itemCount: categoryRestaurantData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantsHome(id: categoryRestaurantData[index]["_id"],),));
                        },
                        child: Container(
                          width: 120,
                          height: 150,
                          decoration: BoxDecoration(
                              color: TColors.lightGrey,
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network('${categoryRestaurantData[index]['logoImg']}',
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(child: CircularProgressIndicator());
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                              },
                            ),
                          ),
                        ),
                      ),
                      
                      SizedBox(width: 14,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            categoryRestaurantData[index]['veg'] == 'veg' ? Row(
                              children: [
                                Icon(
                                  Icons.verified,
                                  color: Colors.green,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Pure Veg",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                              ],
                            ) : SizedBox(height:10,),
                        
                            SizedBox(height: 5,),
                            Text(categoryRestaurantData[index]['restaurantName'], style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            Text("${(ApiConstants.calculateDistance(double.parse(box.get(HiveOpenBox.storeAddressLat)) ?? 21.2049, double.parse(box.get(HiveOpenBox.storeAddressLong)) ?? 21.8411, categoryRestaurantData[index]['latitude'] ?? 21.70, categoryRestaurantData[index]['longitude'] ?? 71.12).toStringAsFixed(2))} km "
                                ,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500,overflow: TextOverflow.ellipsis),maxLines: 2,),
                            Text(
                              "Fast Food, South Indian Ramanagar",
                              style: TextStyle(fontSize: 12, color: TColors.darkGrey),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),
        ],
      )
    );
  }
}
