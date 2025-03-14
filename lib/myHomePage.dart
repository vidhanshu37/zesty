import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/colors.dart';

class FloatingMenuScreen extends StatelessWidget {

  FloatingMenuScreen({
    required this.categoryItems,
    required this.bottom,
});

  final List categoryItems;
  final double bottom;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4), // Dim background
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context), // Tap outside to close
          ),
          Positioned(
            bottom: bottom,
            right: 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: EdgeInsets.all(16),
                height: 280,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: SizedBox(
                  height: 280,
                  child: ListView.builder(
                    itemCount: categoryItems.length,
                      itemBuilder: (context, index) {
                        return _menuItem(categoryItems[index], context);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem( String label, BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pop(context, label); // Close menu on selection
        print("$label selected");
      },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25),
          child: Text(label, style: TextStyle(fontSize: 16, color: TColors.bgLight)),
        ));

  }

}
