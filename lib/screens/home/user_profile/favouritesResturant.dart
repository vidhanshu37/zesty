import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/screens/restaurants_side/restaurants_home.dart';
import '../../../utils/constants/api_constants.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/local_storage/HiveOpenBox.dart';

class LikedRestaurantsPage extends StatefulWidget {
  const LikedRestaurantsPage({super.key});

  @override
  State<LikedRestaurantsPage> createState() => _LikedRestaurantsPageState();
}

class _LikedRestaurantsPageState extends State<LikedRestaurantsPage> {
  late Box likedBox;
  List<String> likedRestaurantIds = [];
  List restaurantData = [];
  bool isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    likedBox = Hive.box(HiveOpenBox.storeAddress);
    likedRestaurantIds = List<String>.from(
      likedBox.get(HiveOpenBox.likedResturants, defaultValue: []),
    );

    fetchDataRestaurant(); // ✅ Fetch data when screen loads
  }

  /// Fetch all restaurants from API
  Future<void> fetchDataRestaurant() async {
    final url = Uri.parse(ApiConstants.getAllRestuarnat);

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        restaurantData = jsonDecode(response.body);
      }
    } catch (e) {
      print("Error fetching restaurants: $e");
    }

    setState(() {
      isLoading = false; // ✅ Data fetched, stop loading
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Liked Restaurants")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black,)) // ✅ Show loader while fetching
          : likedRestaurantIds.isEmpty
          ? const Center(child: Text("No liked restaurants yet!"))
          : ListView.separated(
        itemCount: likedRestaurantIds.length,
        itemBuilder: (context, index) {
          String restaurantId = likedRestaurantIds[index];

          // Find the restaurant in API response
          var restaurant = restaurantData.firstWhere(
                (r) => r["_id"] == restaurantId,
            orElse: () => null, // Handle missing restaurants
          );

          if (restaurant == null) return const SizedBox.shrink();

          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantsHome(id: restaurant['_id']),));
            },
            child: ListTile(
              leading: Image.network(
                restaurant['logoImg'],
                width: 80,
                height: 180,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),
              ),
              title: Text(restaurant['restaurantName'],maxLines: 2,overflow: TextOverflow.ellipsis,),
              subtitle: Text(restaurant['cuisines'] ?? "Fast Food",maxLines: 2,overflow: TextOverflow.ellipsis,),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.black),
                onPressed: () {
                  setState(() {
                    likedRestaurantIds.remove(restaurantId);
                    likedBox.put(HiveOpenBox.likedResturants, likedRestaurantIds);
                  });
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Divider(
              color: TColors.grey, // Divider color
            ),
          );
        },
      ),
    );
  }
}
