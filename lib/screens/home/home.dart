import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/Shimmer_home.dart';
import 'package:zesty/screens/home/category_home.dart';
import 'package:zesty/screens/home/custom_widget/appBarHome.dart';
import 'package:zesty/screens/home/item_cart/trackDeliveryOrder.dart';
import 'package:zesty/screens/home/reorder/reorder_page.dart';
import 'package:zesty/screens/home/user_profile/profile.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
import 'package:zesty/screens/restaurants_side/restaurants_home.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'custom_widget/appBarBanner.dart';
import '../../utils/constants/colors.dart';
import 'custom_widget/carouselBanner.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen(
      {super.key, required this.address, required this.subAddress});

  final String address;
  final String subAddress;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  static bool isVisible = true;
  final ScrollController hideBottomNavController = ScrollController();
  double currentOffset = 0;
  double previousOffset = 0;
  final double threshold = 20.0;
  final searchController = TextEditingController();
  Color appBarBackgroundColor = TColors.grey;
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  late Animation<Color?> colorAnimationAddress;
  CarouselController carouselController = CarouselController(initialItem: 5);

  List category = [];
  List restaurantData = [];

  bool isRefreshing = false;
  double lat = 0;
  double long = 0;

  @override
  void initState() {
    super.initState();

    /// Banner color change
    bannerColorChange();

    /// Hide bottom navigation
    hideBottomNav();

    /// API data fetching 
    fetchDataCategory(); // for category
    fetchDataRestaurant(); // for restaurant
  }

  /// get API for category name and image
  Future<void> fetchDataCategory() async {
    final url = Uri.parse(ApiConstants.getAllcategory);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          category = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  /// Fetch restaurant name and image for vertically display.
  Future<void> fetchDataRestaurant() async {
    final url = Uri.parse(ApiConstants.getAllRestuarnat);
    
    try{
      final response = await http.get(url);
      
      if(response.statusCode == 200 ) {
          restaurantData = jsonDecode(response.body);
          setState(() {});
      }
    } catch(e) {
      print(e);
    }
    
  }

  void bannerColorChange() {
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Animation duration
      vsync: this,
    );

    // Set up the initial color tween
    colorAnimation = ColorTween(
      begin: TColors.grey, // Initial color
      end: TColors.ligthGreen, // Final color
    ).animate(animationController);

    // Set address and sub-address color
    colorAnimationAddress = ColorTween(
      begin: TColors.black,
      end: TColors.white,
    ).animate(animationController);

    animationController.value =
        1.0; // show color at initial stage (first loaded)
  }

  void hideBottomNav() {
    hideBottomNavController.addListener(() {
      currentOffset = hideBottomNavController.offset;

      // Check the scroll direction
      final scrollDirection =
          hideBottomNavController.position.userScrollDirection;

      if (hideBottomNavController.position.pixels ==
          hideBottomNavController.position.minScrollExtent) {
        animationController.duration = const Duration(milliseconds: 300);
        animationController.forward();
        setState(() {});
      }

      if (scrollDirection == ScrollDirection.reverse &&
          currentOffset > threshold) {
        // Scrolling down
        if (isVisible) {
          setState(() {
            isVisible = false; // Hide bottom navigation
          });
        }
      } else if (scrollDirection == ScrollDirection.forward) {
        // Scrolling up
        if (!isVisible) {
          setState(() {
            isVisible = true; // Show bottom navigation
            animationController.duration = Duration.zero;
            animationController.reverse();
          });
        }
      }

      // Update previousOffset only if necessary
      previousOffset = currentOffset;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      isRefreshing = true; // Show full-screen loader
    });
    await Future.delayed(const Duration(seconds: 2));
    fetchDataCategory();
    fetchDataRestaurant();
    setState(() {
      isRefreshing = false; // Show UI after delay
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: isVisible ? 65.0 : 0.0,
        // margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: TColors.bgLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color
              blurRadius: 10, // Spread of the shadow
              spreadRadius: 2, // How much the shadow spreads
              offset: Offset(5, 5), // Shadow position (X, Y)
            ),
          ],
          // borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
          child: GNav(
            backgroundColor:
                 TColors.bgLight,
            color:
                 TColors.bgDark,
            activeColor:
                 TColors.bgDark,
            tabBackgroundColor:
                 TColors.grey,
            padding: EdgeInsets.all(15),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              // _pageController.jumpToPage(index);
            },
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home_filled,
                text: "Home",
                iconSize: 20,
              ),
              GButton(
                icon: Icons.card_travel,
                text: "ZestyMart",
              ),
              GButton(icon: Icons.shopping_basket_rounded, text: "Reorder"),
              GButton(icon: Icons.person, text: "Profile", iconSize: 20,),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          category.isEmpty && restaurantData.isEmpty ? ShimmerHome() : isRefreshing ? ShimmerHome() : CustomScrollView(
            controller: hideBottomNavController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              /// main top appbar(searching, profile)
              AnimatedBuilder(
                  animation: colorAnimation,
                  builder: (context, child) {
                    // main App-bar (address, sub-add, search)
                    return AppBarHome(
                        colorAnimation: colorAnimation,
                        widget: widget,
                        colorAnimationAddress: colorAnimationAddress,
                        searchController: searchController);
                  }),

              /// Show Banner
              appBarBanner(),


              /// Pull to refresh
              CupertinoSliverRefreshControl(
                onRefresh: _onRefresh,
                refreshIndicatorExtent: 60.0,
                refreshTriggerPullDistance: 60.0,
              ),

              /// carousel
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 150,
                    child: carouselBanner(),
                  ),
                ),
              ),

              /// title - what's in your mind
              SliverToBoxAdapter(
                child: Container(
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Center(
                        child: Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: TColors.grey, // Customize the color
                                thickness: 1, // Customize the thickness
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text("WHAT'S  ON YOUR MIND?",
                                  style: Theme.of(context).textTheme.labelMedium),
                              // child: Text("latitude - $lat and longitude - $long"),
                            ),
                            Expanded(
                              child: Divider(
                                color: TColors.grey,
                                thickness: 1,
                              ),
                            ),
                          ],
                        ))),
              ),

              /// Food category
              SliverToBoxAdapter(
                child: Container(
                    height: 240,
                    child: GridView.builder(
                        scrollDirection: Axis.horizontal,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          childAspectRatio: 1,
                        ),
                        itemCount: category.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryHome(categoryImageId: category[index]['_id'], categoryName: category[index]['name'])));
                            },
                            child: Column(
                              children: [
                                Image.network(
                                  '${category[index]['image']}',
                                  // 'https://zesty-backend.onrender.com/category/get-category-image/${category[index]['_id']}',
                                  fit: BoxFit.cover,
                                  height: 90,
                                  width: 90,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      height: 90,
                                      width: 90,
                                      color: TColors.grey,
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                                  },
                                ),
                                Text(
                                  category[index]['name'],
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          );
                        })),
              ),

              // SliverToBoxAdapter(
              //   child: Padding(
              //     padding: const EdgeInsets.all(20.0),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "Top Rated Restaurants",
              //           style: Theme.of(context).textTheme.titleLarge,
              //         ),
              //         SizedBox(
              //           height: 5,
              //         ),
              //         Card(
              //           elevation: 3,
              //           child: Container(
              //             height: 150,
              //             width: 140,
              //             decoration: BoxDecoration(
              //                 color: Colors.amber,
              //                 borderRadius: BorderRadius.circular(10)),
              //           ),
              //         ),
              //         Text(
              //           "    Radhe Dhokla",
              //           style: Theme.of(context).textTheme.bodyLarge,
              //         ),
              //         SizedBox(height: 30,),
              //       ],
              //     ),
              //   ),
              // ),

              SliverToBoxAdapter(
                child: Padding(padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    Text(
                              "\t\tRestaurants just for you",
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                  ],
                ),
                ),
              ),

              /// main home page vertical restaurant
              SliverList.builder(
                  itemCount: restaurantData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Card(
                        elevation: 1,
                        color: TColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantsHome(id: restaurantData[index]["_id"],),));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12)),
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: TColors.lightGrey,
                                      borderRadius: BorderRadius.circular(12.0)
                                  ),
                                  child: Image.network('${restaurantData[index]['logoImg']}',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: CircularProgressIndicator(color: Colors.black,));
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2),
                              child: Text(restaurantData[index]['restaurantName'], style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Text(restaurantData[index]['cuisines'] ?? "(Burger, Pizza, Fast Food)", style: Theme.of(context).textTheme.labelMedium, maxLines: 1, overflow: TextOverflow.ellipsis,),
                            ),
                            SizedBox(height: 15,),
                          ],
                        ),
                      ),
                    );
                  }),
            ],
          ),
          ZestyMartPage(address: widget.address, subAddress: widget.subAddress,),
          ReorderPage(),
          profile(),
        ],
      ),
    );
  }
}
