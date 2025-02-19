import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';

import '../custom_widget/searchbarHome.dart';

class ZestyMartPage extends StatefulWidget {
  const ZestyMartPage({super.key});

  @override
  State<ZestyMartPage> createState() => _ZestyMartPageState();
}

class _ZestyMartPageState extends State<ZestyMartPage>  with SingleTickerProviderStateMixin{
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;
  late ScrollController _scrollController;


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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 10, vsync: this);
    _scrollController = ScrollController();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging || _tabController.index != _tabController.previousIndex) {
        _scrollToSelectedTab();
      }
    });
  }

  void _scrollToSelectedTab() {
    double screenWidth = MediaQuery.of(context).size.width;
    double tabWidth = 80; // Approximate width of each tab, adjust as needed
    double targetScrollX = (tabWidth * _tabController.index) - (screenWidth / 2) + (tabWidth / 2);

    _scrollController.animateTo(
      targetScrollX.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true ,
            snap: true,
            floating: true,
            backgroundColor: Colors.blue.withOpacity(0.3),
            expandedHeight: 70,
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
                    Text("Surat", style: TextStyle(fontSize: 16)),
                    Text("Katargam-395004", style: TextStyle(fontSize: 12))
                  ],
                ),
              ),
            ),
          ),
          SliverAppBar(
            pinned: true,
            expandedHeight: 130,
            backgroundColor: TColors.bgLight,
            collapsedHeight: 130,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      color: Colors.blue.withOpacity(0.3),
                      child: Center(child: SearchBarHome(searchController: searchController))
                  ),
                  DefaultTabController(length: 10, child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Material(
                        child: Container(
                          // height: 120,
                          color: Colors.blue.withOpacity(0.3),
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
                              unselectedLabelColor: Colors.black.withOpacity(0.5),
                              indicatorSize: TabBarIndicatorSize.label,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.only(topRight: Radius.circular(12), topLeft: Radius.circular(12.0)),
                                  color:  TColors.bgLight
                              ),
                              dividerHeight: 22,
                              dividerColor: Colors.blue.withOpacity(0.2),
                              tabAlignment: TabAlignment.start,
                              labelPadding: EdgeInsets.symmetric(horizontal: 5),
                              tabs: [
                                ...List.generate(7, (index) => categoryTab(iconPath: zestyMartCategoryIcon[index], title: categoryTitle[index]))
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
          SliverToBoxAdapter(
            child: Container(
              height: 300,
              width: double.infinity,
              color: TColors.bgLight,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(7, (index) =>
                      Center(child: Text(categoryTitle[index]))
                    ),
              ),
            ),
          ),
          SliverList.builder(
            itemCount: 100,
              itemBuilder: (context, index) {
              return Text("data");
              })
        ],
      ),
    );
  }

  Widget buildSegment(String text) => Container(
        padding: EdgeInsets.all(12.0),
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
      );
}

class categoryTab extends StatefulWidget {
  final String iconPath, title;
  const categoryTab({
    super.key,
    required this.iconPath, required this.title,
  });

  @override
  State<categoryTab> createState() => _categoryTabState();
}

class _categoryTabState extends State<categoryTab> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      iconMargin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 15.0),
      text: widget.title,
      icon: Image.asset(widget.iconPath, height: 30, width: 30, fit: BoxFit.cover,),
    );
  }
}

