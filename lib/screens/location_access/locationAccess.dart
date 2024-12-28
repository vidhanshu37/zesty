import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/custom_widget/textfield_cust.dart';
import 'package:zesty/screens/location_access/showFloatingManualLocation.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';

class LocationAccess extends StatefulWidget {
  const LocationAccess({super.key});

  @override
  State<LocationAccess> createState() => _LocationAccessState();
}

class _LocationAccessState extends State<LocationAccess> {

  var controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [

            /// current location button
            Positioned(
              bottom: 85,
              right: 0,
              left: 0,
              child: ZElevatedButton(
                  title: "Use current location", onPress: () {
              }),
            ),

            /// enter manually button
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: ZElevatedButton(
                  bgColor: ZMediaQuery(context).isDarkMode ? TColors.darkerGrey : TColors.grey,
                  btnTextColor: ZMediaQuery(context).isDarkMode ? TColors.bgLight : TColors.black,
                  title: "Enter manually",
                  onPress: () {
                    showFloatingSheet(context);
                  },
                )),

            /// title text
            Positioned(
              bottom: 230,
                right: 0,
                left: 0,
                child: Center(child: Text(ZText.grantLocation, style: Theme.of(context).textTheme.headlineMedium))
            ),

            /// description text
            Positioned(
                bottom: 193,
                right: 0,
                left: 0,
                child: Center(child: Text(ZText.locationAccessDesc, textAlign: TextAlign.center, style: Theme.of(context).textTheme.labelMedium,)))

          ],
        ),
      )),
    );
  }


  // Method to show the floating bottom sheet
  void _showFloatingSheet(BuildContext context, TextEditingController controller, ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Makes the sheet floating
      backgroundColor: Colors.transparent, // Make background transparent for styling
      builder: (BuildContext context) {
        return Container(
          height: ZMediaQuery(context).height - 60,
          width: ZMediaQuery(context).width,
          decoration: BoxDecoration(
            color: ZMediaQuery(context).isDarkMode ? TColors.bgDark : TColors.bgLight,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(onTap: () {
                  Navigator.pop(context);
                } ,child: Icon(Icons.arrow_back, size: 25,)),
                SizedBox(height: 10,),
                Text(ZText.searchLocation, style: Theme.of(context).textTheme.headlineMedium,),
                SizedBox(height: 10,),
                ZCustomTextField(controller: controller, hintText: "hintText")
              ],
            ),
          ),
        );
      },
    );
  }


}
