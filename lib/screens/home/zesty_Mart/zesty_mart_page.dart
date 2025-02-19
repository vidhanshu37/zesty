import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';

import '../custom_widget/searchbarHome.dart';

class ZestyMartPage extends StatefulWidget {
  const ZestyMartPage({super.key});

  @override
  State<ZestyMartPage> createState() => _ZestyMartPageState();
}

class _ZestyMartPageState extends State<ZestyMartPage> {
  TextEditingController searchController = TextEditingController();
  int selectedCategoryIndex = 0;
  double itemWidth = 60.0; // Width of each item
  double itemBetweenSpacing = 10.0; // Spacing between items

  int groupValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: false,
            snap: true,
            floating: true,
            backgroundColor: Colors.blue,
            expandedHeight: 40,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(17.0, 20.0, 20.0, 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
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
            backgroundColor: Colors.blue,
            collapsedHeight: 130,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18),
                    child: SearchBarHome(searchController: searchController),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 70,
                    child: Stack(
                      children: [
                        AnimatedPositioned(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          left: selectedCategoryIndex *
                                  (itemBetweenSpacing + itemWidth) +
                              5,
                          child: Container(
                            height: 70,
                            width: itemWidth,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0))),
                          ),
                        ),
                        ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedCategoryIndex = index;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: itemBetweenSpacing / 2),
                                  width: itemWidth,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    // color: selectedCategoryIndex == index ? Colors.pinkAccent : Colors.transparent
                                  ),
                                  child: Image.asset('assets/icons/avocado.png',
                                      fit: BoxFit.contain),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: Text("data")
            ),
          )
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
