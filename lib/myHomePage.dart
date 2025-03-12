import 'package:flutter/material.dart';

class FloatingHeroMenu extends StatefulWidget {
  @override
  _FloatingHeroMenuState createState() => _FloatingHeroMenuState();
}

class _FloatingHeroMenuState extends State<FloatingHeroMenu> {
  void _showFloatingMenu(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (_, __, ___) => FloatingMenuScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text("Swiggy Floating Menu")),
      body: Center(child: Text("Tap the FAB to open menu")),
      floatingActionButton: Hero(
        tag: "floating_menu",
        child: FloatingActionButton(
          onPressed: () => _showFloatingMenu(context),
          child: Icon(Icons.menu),
        ),
      ),
    );
  }
}

class FloatingMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.4), // Dim background
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context), // Tap outside to close
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Hero(
              tag: "floating_menu",
              child: Material(
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.all(16),
                  width: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _menuItem(Icons.local_pizza, "Pizza", context),
                      _menuItem(Icons.fastfood, "Burger", context),
                      _menuItem(Icons.emoji_food_beverage, "Beverages", context),
                      _menuItem(Icons.icecream, "Desserts", context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String label, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(label, style: TextStyle(fontSize: 16)),
      onTap: () {
        Navigator.pop(context); // Close menu on selection
        print("$label selected");
      },
    );
  }
}
