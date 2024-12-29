import 'package:flutter/material.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/custom_widget/textfield_cust.dart';
import 'package:zesty/screens/location_access/showFloatingManualLocation.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/constants/text_string.dart';

import '../add_manually_address/confirmLocation.dart';

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
                  title: "Use current location",
                  onPress: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConfirmLocation()));
                  }),
            ),

            /// enter manually button
            Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: ZElevatedButton(
                  bgColor: ZMediaQuery(context).isDarkMode
                      ? TColors.darkerGrey
                      : TColors.grey,
                  btnTextColor: ZMediaQuery(context).isDarkMode
                      ? TColors.bgLight
                      : TColors.black,
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
                child: Center(
                    child: Text(ZText.grantLocation,
                        style: Theme.of(context).textTheme.headlineMedium))),

            /// description text
            Positioned(
                bottom: 193,
                right: 0,
                left: 0,
                child: Center(
                    child: Text(
                  ZText.locationAccessDesc,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelMedium,
                )))
          ],
        ),
      )),
    );
  }
}
