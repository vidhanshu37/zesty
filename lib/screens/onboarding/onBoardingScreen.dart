import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/login_process/signin.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';

class onbording extends StatefulWidget{
  @override
  State<onbording> createState() => _onbordingState();
}

class _onbordingState extends State<onbording> {

  PageController pageController = PageController();
  int currentIndex = 0;

  void nextpage(){
    if(currentIndex < 3){
      pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeIn);
    } else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => signin(),));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            buildIndicator(),
            Expanded(
              child: PageView(
                controller: pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                children: [
                  buildOnboardingPage(
                    imagePath: "assets/images/pic1.jpg",
                    title: ZText.title1,
                    subtitle: ZText.subTitle,
                  ),
                  buildOnboardingPage(
                    imagePath: "assets/images/pic1.jpg",
                    title: ZText.title2,
                    subtitle: ZText.subTitle,
                  ),
                  buildOnboardingPage(
                    imagePath: "assets/images/pic1.jpg",
                    title: ZText.title3,
                    subtitle: ZText.subTitle,
                  ),
                  buildOnboardingPage(
                    imagePath: "assets/images/pic1.jpg",
                    title: ZText.title4,
                    subtitle: ZText.subTitle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  buildOnboardingPage(
      {required String imagePath, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Positioned(
            top: 50,
              left: 5,
              right: 5,
              child: Image.asset(imagePath, height: ZMediaQuery(context).height * 0.30,)
          ),
          //SizedBox(height: 40,),
          Positioned(
            bottom: 200,
              left: 5,
              right: 5,
              child: Text(title, style: Theme.of(context).textTheme.headlineLarge,textAlign: TextAlign.center,)
          ),
          //SizedBox(height: 10,),
          Positioned(
              bottom: 160,
              left: 5,
              right: 5,
              child: Text(subtitle,style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center, )),

          Positioned(
            bottom: 55,
            left: 5,
            right: 5,
            child: ZElevatedButton(title: currentIndex < 3 ? 'Next' : 'Get Started', onPress: (){
              nextpage();
              // if(currentIndex == 1){
              //
              // } else{
              //   pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
              // }

            }),
          ),
          Positioned(
            bottom: 15,
            left: 5,
            right: 5,
            child: InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => signin(),));
            }, child: Text("Skip",style: Theme.of(context).textTheme.titleMedium,textAlign: TextAlign.center,) ,),
          ),
          ],
      ),
    );
  }

  buildIndicator(){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: List.generate(4, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                height: 3,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(11),
                  color: currentIndex == index ? Colors.black : Colors.grey ,)),),
                ),

        ),
      ),
    );
  }
}