import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:zesty/screens/home/custom_widget/appBarHome.dart';
import 'package:zesty/screens/home/reorder/reorder_page.dart';
import 'package:zesty/screens/home/user_profile/profile.dart';
import 'package:zesty/screens/home/zesty_Mart/zesty_mart_page.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'custom_widget/appBarBanner.dart';
import 'custom_widget/searchbarHome.dart';
import '../../utils/constants/colors.dart';
import 'custom_widget/carouselBanner.dart';

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
  PageController _pageController = PageController();

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
  List<String> foodCategory1 = [
    'assets/icons/food_category/Pizza.avif',
    'assets/icons/food_category/Salad.avif',
    'assets/icons/food_category/Cake.avif',
    'assets/icons/food_category/Dosa.avif',
    'assets/icons/food_category/Noodles.avif',
    'assets/icons/food_category/Burger.avif',
    'assets/icons/food_category/Rolls.avif',
    'assets/icons/food_category/Biryani.avif',
    'assets/icons/food_category/Paratha.avif',
    'assets/icons/food_category/North Indian.avif',
  ];

  List<String> foodCategory2 = [
    'assets/icons/food_category/Pasta.avif',
    'assets/icons/food_category/Chole Bhature.avif',
    'assets/icons/food_category/Shake.avif',
    'assets/icons/food_category/Chinese.avif',
    'assets/icons/food_category/Pav Bhaji.avif',
    'assets/icons/food_category/Idli.avif',
    'assets/icons/food_category/Khichdi.avif',
    'assets/icons/food_category/South Indian.avif',
    'assets/icons/food_category/Shawarma.avif',
    'assets/icons/food_category/Pure Veg.avif',
  ];

  @override
  void initState() {
    super.initState();

    /// Banner color change
    bannerColorChange();

    /// Hide bottom navigation
    hideBottomNav();
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

  final List<Widget> _screen = [
    Container(),
    ZestyMartPage(),
    ReorderPage(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: isVisible ? 62.0 : 0.0,
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: ZMediaQuery(context).isDarkMode ? TColors.white : TColors.black,
          // borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child:  Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
          child: GNav(
            backgroundColor: ZMediaQuery(context).isDarkMode ? TColors.white : TColors.black,
            color: ZMediaQuery(context).isDarkMode ? TColors.black : TColors.white,
            activeColor: ZMediaQuery(context).isDarkMode ? TColors.black : TColors.white,
            tabBackgroundColor: ZMediaQuery(context).isDarkMode ? TColors.grey : TColors.darkGrey,
            padding: EdgeInsets.all(16),
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
              // _pageController.jumpToPage(index);
            },
            gap: 8,
            tabs: [GButton(icon: Icons.home_filled,text: "Home",),
              GButton(icon: Icons.card_travel,text: "ZestyMart",),
              GButton(icon: Icons.shopping_basket_rounded, text: "Reorder"),
              GButton(icon: Icons.person, text: "Profile"),
            ],
          ),
        ),
      ),

      body: IndexedStack(
        index: _selectedIndex,
        children: [
          CustomScrollView(
          controller: hideBottomNavController,
          slivers: [
            /// main top appbar(searching, profile)
            AnimatedBuilder(
                animation: colorAnimation,
                builder: (context, child) {
                  // main App-bar (address, sub-add, search)
                  return AppBarHome(colorAnimation: colorAnimation, widget: widget, colorAnimationAddress: colorAnimationAddress, searchController: searchController);
                }),

            /// Show Banner
            appBarBanner(),

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
                              thickness: 1,       // Customize the thickness
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text("WHAT'S  ON YOUR MIND?",
                                style: Theme.of(context).textTheme.labelMedium),
                          ),
                          Expanded(
                            child: Divider(
                              color: TColors.grey,
                              thickness: 1,
                            ),
                          ),
                        ],
                      )
                  )
              ),
            ),

            /// Food category
            SliverToBoxAdapter(
              child: Container(
                height: 260,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: foodCategory1.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                              height: 110,
                              width: 110,
                              child: AvifImage.asset(
                                foodCategory1[index],
                                height: 80,
                                width: 80,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              height: 110,
                              width: 110,
                              child: AvifImage.asset(
                                foodCategory2[index],
                                height: 80,
                                width: 80,
                              )),
                        ],
                      );
                    }),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Top Rated Restaurants", style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 5,),
                    Card(
                      elevation: 3,
                      child: Container(
                        height: 150,
                        width: 140,
                        decoration: BoxDecoration(
                            color: Colors.amber,
                          borderRadius: BorderRadius.circular(10)
                        ),
                      ),
                    ),
                    Text("    Radhe Dhokla", style: Theme.of(context).textTheme.bodyLarge,)
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [],
                ),
              ),
            ),

            /// main home page content
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("data"),
                );
              },
              childCount: 100,
            )),

          ],
        ),
          ZestyMartPage(),
          ReorderPage(),
          profile(),
        ],
      ),
    );
  }
}


