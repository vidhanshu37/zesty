import 'package:flutter/material.dart';
import 'package:zesty/screens/onboarding/onBoardingScreen.dart';
import 'package:zesty/utils/constants/colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => onbording()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 140,),
            ScaleTransition(
              scale: _animation,
              child: Image.asset('assets/images/ZestyLogo.png', width: 250,height: 250,), // Logo
            ),
            SizedBox(height: 200), // Space between logo & text
            Text(
              "Zesty - Food Delivery App",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10), // Space between title & description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                "Delicious Food, Delivered Fast! Order from top restaurants and enjoy fresh, hot meals at your doorstep in no time!",
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
