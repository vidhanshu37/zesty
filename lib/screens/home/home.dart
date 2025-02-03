import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:zesty/utils/constants/media_query.dart';
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
  bool isVisible = true;
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
    'assets/icons/Pizza.avif',
    'assets/icons/Salad.avif',
    'assets/icons/Cake.avif',
    'assets/icons/Dosa.avif',
    'assets/icons/Noodles.avif',
    'assets/icons/Burger.avif',
    'assets/icons/Rolls.avif',
    'assets/icons/Biryani.avif',
    'assets/icons/Paratha.avif',
    'assets/icons/North Indian.avif',
  ];

  List<String> foodCategory2 = [
    'assets/icons/Pasta.avif',
    'assets/icons/Chole Bhature.avif',
    'assets/icons/Shake.avif',
    'assets/icons/Chinese.avif',
    'assets/icons/Pav Bhaji.avif',
    'assets/icons/Idli.avif',
    'assets/icons/Khichdi.avif',
    'assets/icons/South Indian.avif',
    'assets/icons/Shawarma.avif',
    'assets/icons/Pure Veg.avif',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        height: isVisible ? 62.0 : 0.0,
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        decoration: BoxDecoration(
          color: TColors.darkerGrey,
          // borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Center(child: Text("Bottom navigation "),),
      ),
      body: CustomScrollView(
        controller: hideBottomNavController,
        slivers: [
          /// main top appbar(searching, profile)
          AnimatedBuilder(
              animation: colorAnimation,
              builder: (context, child) {
                return SliverAppBar(
                  // pinned: true,
                  snap: true,
                  collapsedHeight: 120,
                  floating: true,
                  centerTitle: false,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      color: colorAnimation.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ListTile(
                            title: Text(
                              widget.address,
                              // style: Theme.of(context).textTheme.titleMedium,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: colorAnimationAddress.value),
                            ),
                            subtitle: Text(
                              widget.subAddress,
                              // style: Theme.of(context).textTheme.labelLarge,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: colorAnimationAddress.value),
                            ),
                            trailing: Icon(
                              Icons.supervised_user_circle_outlined,
                              size: 30,
                              color: colorAnimationAddress.value,
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),

                          /// searchbar
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            child: searchbarHome(
                                searchController: searchController),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),

          /// show advertisement
          SliverAppBar(
            expandedHeight: 160,
            // title: Text("Zesty"), // title
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: 170,
                width: ZMediaQuery(context).width,
                decoration: BoxDecoration(
                  color: TColors.ligthGreen,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        height: 180,
                        width: 100,
                        child: AvifImage.asset('assets/icons/Veggies_new.avif',
                            fit: BoxFit.cover)),
                    Text(
                      "\nBest deals of\n\t\t\t  the day!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Container(
                      height: 180,
                      width: 100,
                      child: AvifImage.asset('assets/icons/Sushi_replace.avif',
                          fit: BoxFit.cover),
                    )
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
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
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: foodCategory1.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Container(
                            height: 120,
                            width: 120,
                            child: AvifImage.asset(
                              foodCategory1[index],
                              height: 80,
                              width: 80,
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 120,
                            width: 120,
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
          ))
        ],
      ),
    );
  }
}
