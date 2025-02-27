import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/zesty_Mart/all_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/beauty_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/electronics_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/fresh_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/grocery_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/home_Tab.dart';
import 'package:zesty/screens/home/zesty_Mart/kids_Tab.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import '../../restaurants_side/custom_widget/mart_categoryTabs.dart';
// import '../../restaurants_side/custom_widget/mart_itemCard.dart';
import '../../restaurants_side/custom_widget/mart_itemCard.dart';
import '../custom_widget/searchbarHome.dart';

class ZestyMartPage extends StatefulWidget {
  final String address;
  final String subAddress;

  const ZestyMartPage(
      {super.key, required this.address, required this.subAddress});

  @override
  State<ZestyMartPage> createState() => _ZestyMartPageState();
}

class _ZestyMartPageState extends State<ZestyMartPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  late ScrollController _scrollController;

  List allMartItem = [];

  List<String> zestyMartCategoryIcon = [
    'assets/icons/zestyMartCategory/basket.png',
    'assets/icons/zestyMartCategory/orange.png',
    'assets/icons/zestyMartCategory/shopping-bag.png',
    'assets/icons/zestyMartCategory/headphones.png',
    'assets/icons/zestyMartCategory/perfume-bottle.png',
    'assets/icons/zestyMartCategory/table-lamp.png',
    'assets/icons/zestyMartCategory/teddy-bear.png'
  ];

  List<String> categoryTitle = [
    'All',
    'Fresh',
    'Grocery',
    'Electronics',
    'Beauty',
    'Home',
    'Kids'
  ];

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 7, vsync: this);
    _scrollController = ScrollController();

    _tabController.addListener(() {
      _activeIndex = _tabController.index;
      setState(() {});
      if (_tabController.indexIsChanging ||
          _tabController.index != _tabController.previousIndex) {
        _scrollToSelectedTab();
      }
    });

    /// Call fetch all mart data API
    fetchAllMartItem();
  }

  void _scrollToSelectedTab() {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = 80; // Approximate width of each tab, adjust as needed
    double targetScrollX =
        (tabWidth * _tabController.index) - (screenWidth / 2) + (tabWidth / 2);

    _scrollController.animateTo(
      targetScrollX.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Color appBarColorTab() {
    if (_activeIndex == 4) {
      return Colors.pinkAccent.withOpacity(0.2);
    } else if (_activeIndex == 6) {
      return Colors.brown.withOpacity(0.3);
    } else if (_activeIndex == 1) {
      return Colors.deepOrangeAccent.withOpacity(0.2);
    } else if (_activeIndex == 2) {
      return Colors.green.withOpacity(0.3);
    }
    return Colors.blue.withOpacity(0.3);
  }

  Color appBarDividerTab() {
    if (_activeIndex == 4) {
      return Colors.pinkAccent.withOpacity(0.3);
    } else if (_activeIndex == 6) {
      return Colors.brown.withOpacity(0.4);
    } else if (_activeIndex == 1) {
      return Colors.deepOrangeAccent.withOpacity(0.3);
    } else if (_activeIndex == 2) {
      return Colors.green.withOpacity(0.4);
    }
    return Colors.blue.withOpacity(0.4);
  }

  Future<void> fetchAllMartItem() async {
    final url = Uri.parse(
        "https://zesty-backend.onrender.com/zestyMart/get-all-martItem");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        allMartItem = jsonDecode(response.body);
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("success - ${response.statusCode}")));
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
    return Scaffold(
      backgroundColor: TColors.white,
      body: Stack(
        children: [
          CustomScrollView(
            // physics: const BouncingScrollPhysics(),
            slivers: [
              /// AppBar for Address and Sub-address
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                backgroundColor: appBarColorTab(),
                expandedHeight: 60,
                collapsedHeight: 10,
                toolbarHeight: 10,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(10),
                    // padding: EdgeInsets.all(1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Text(widget.address, style: TextStyle(fontSize: 16)),
                        Text(widget.subAddress, style: TextStyle(fontSize: 12))
                      ],
                    ),
                  ),
                ),
              ),

              /// SearchView and Tabview
              SliverAppBar(
                pinned: true,
                expandedHeight: 130,
                backgroundColor: TColors.bgLight,
                collapsedHeight: 130,
                flexibleSpace: FlexibleSpaceBar(
                  background: Column(
                    children: [
                      Container(
                          padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          color: appBarColorTab(),
                          child: Center(
                              child: SearchBarHome(
                                  searchController: searchController))),
                      DefaultTabController(
                          length: 7,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Material(
                                child: Container(
                                  // height: 120,
                                  color: appBarColorTab(),
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.horizontal,
                                    child: TabBar(
                                      controller: _tabController,
                                      isScrollable: true,
                                      labelColor: Colors.black,
                                      padding: EdgeInsets.only(top: 10),
                                      labelStyle: TextStyle(fontSize: 12),
                                      physics: BouncingScrollPhysics(),
                                      unselectedLabelColor:
                                      Colors.black.withOpacity(0.5),
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicator: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(12),
                                              topLeft: Radius.circular(12.0)),
                                          color: TColors.bgLight),
                                      dividerHeight: 22,
                                      dividerColor: appBarDividerTab(),
                                      tabAlignment: TabAlignment.start,
                                      labelPadding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                      tabs: [
                                        ...List.generate(
                                            7,
                                                (index) => categoryTab(
                                                iconPath:
                                                zestyMartCategoryIcon[index],
                                                title: categoryTitle[index]))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ),

              /// ViewPager of Tabview
              SliverToBoxAdapter(
                child: Column(
                  children:[ IndexedStack(
                    index: _tabController.index,
                      children: [
                        AllTab(),
                        FreshTab(),
                        GroceryTab(),
                        ElectronicsTab(),
                        BeautyTab(),
                        HomeTab(),
                        KidsTab(),
                      ],
                    ),
                  ]
                  ),
                ),

            ],
          ),

        ],
      ),
    );
  }
}