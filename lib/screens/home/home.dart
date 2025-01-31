import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rive/rive.dart' as rive;
import 'package:zesty/utils/constants/media_query.dart';
import 'custom_widget/searchbarHome.dart';
import '../../utils/constants/colors.dart';
import 'bottom_navigation/components/animatedBar.dart';
import 'bottom_navigation/models/riveAsstes.dart';
import 'bottom_navigation/rive_utils/rive_utils.dart';
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
  RiveAssets selectBottomNav = bottomNavs.first;
  double currentOffset = 0;
  double previousOffset = 0;
  final double threshold = 20.0;
  final searchController = TextEditingController();
  Color appBarBackgroundColor = TColors.ligthGreen;
  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  CarouselController carouselController = CarouselController(initialItem: 5);

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300), // Animation duration
      vsync: this,
    );

    // Set up the initial color tween
    colorAnimation = ColorTween(
      begin: TColors.grey, // Initial color
      end: TColors.ligthGreen, // Final color
    ).animate(animationController);

    animationController.value =
        1.0; // show green color at initial stage (first loaded)

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
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
        ),
        child: Center(
          child: Wrap(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                ...List.generate(
                  bottomNavs.length,
                  (index) => GestureDetector(
                    onTap: () {
                      if (bottomNavs[index] != selectBottomNav) {
                        setState(() {
                          selectBottomNav = bottomNavs[index];
                        });
                      }
                      bottomNavs[index].input!.change(true);
                      Future.delayed(const Duration(seconds: 1), () {
                        bottomNavs[index].input!.change(false);
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedBar(
                            isActive: bottomNavs[index] == selectBottomNav),
                        SizedBox(
                          height: 36,
                          width: 36,
                          child: Opacity(
                            opacity:
                                bottomNavs[index] == selectBottomNav ? 1 : 0.5,
                            child: rive.RiveAnimation.asset(
                              bottomNavs.first.src,
                              artboard: bottomNavs[index].artboard,
                              onInit: (artboard) {
                                final controller = RiveUtils.getRiveController(
                                  artboard,
                                  stateMachineController:
                                      bottomNavs[index].stateMachineName,
                                );
                                bottomNavs[index].input =
                                    controller.findSMI<rive.SMIBool>("active");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ])
            ],
          ),
        ),
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
                  collapsedHeight: 140,
                  floating: true,
                  centerTitle: false,
                  expandedHeight: 140,
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
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: Text(
                              widget.subAddress,
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            trailing: Icon(
                              Icons.supervised_user_circle_outlined,
                              size: 30,
                            ),
                          ),
                          SizedBox(
                            height: 0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 5),
                            child: searchbarHome(
                                searchController: searchController),

                            /// searchbar
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }),

          // show advertisement
          SliverAppBar(
            expandedHeight: 85,
            title: Text("Zesty"), // title
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                height: 85,
                width: ZMediaQuery(context).width,
                decoration: BoxDecoration(
                    color: TColors.ligthGreen,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
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

