import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/constants/api_constants.dart';
import '../../utils/constants/colors.dart';
import '../../utils/local_storage/HiveOpenBox.dart';
import '../restaurants_side/restaurants_home.dart';
import 'custom_widget/searchbarHome.dart';

class Searchrestaurant extends StatefulWidget {
  const Searchrestaurant({super.key});

  @override
  State<Searchrestaurant> createState() => _SearchrestaurantState();
}

class _SearchrestaurantState extends State<Searchrestaurant> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allRestaurantData = [];
  List<Map<String, dynamic>> filteredRestaurantDetail = [];
  var box = Hive.box(HiveOpenBox.storeAddress);

  Future<void> FetchRestaurantData() async {
    final url = Uri.parse(ApiConstants.getAllRestuarnat);

    try{
      final response = await http.get(url);
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        allRestaurantData = List<Map<String, dynamic>>.from(data);
      });
    } catch (e){
      print(e.toString());
    }
  }

  void filterSearchResult(String query){
    if (query.isEmpty){

    } else {
      setState(() {
        filteredRestaurantDetail = allRestaurantData.where((item) {
          String itemName = item['restaurantName'].toString().toLowerCase();
          return itemName.contains(query.toLowerCase());
        },).toList();
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchRestaurantData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // ✅ Safely go back
          },
        ),
      ),
      body: allRestaurantData.isEmpty ? Center(child: CircularProgressIndicator(),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchBarHome(
              searchController: searchController,
              onChange: filterSearchResult,
            ),
          ),
          Expanded(
              child:  ListView.builder(
                  itemCount: filteredRestaurantDetail.length,
                  itemBuilder: (context, index) {
                    var item = filteredRestaurantDetail[index];
                    return Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantsHome(id: item["_id"],),));
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
                                child: Image.network('${item['logoImg']}',
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
                                item['veg'] == 'veg' ? Row(
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
                                Text(item['restaurantName'], style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis,),
                                Text("${ApiConstants.calculateDistance(box.get(HiveOpenBox.storeAddressLat) ?? 21.2049, box.get(HiveOpenBox.storeAddressLong) ?? 21.8411, item['latitude'] ?? 21.70, item['longitude'] ?? 71.12)} "
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
          )
        ],
      ),
    );
  }
}
