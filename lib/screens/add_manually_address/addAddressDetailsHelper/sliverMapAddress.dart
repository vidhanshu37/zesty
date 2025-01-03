import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../custom_widget/elevatedButton_cust.dart';
import '../../../custom_widget/textfield_cust.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/media_query.dart';
import 'addressTypeButton.dart';

class TopMap extends StatefulWidget {

  final double lat, lng;
  final address, subAddress;
  const TopMap({super.key, required this.lat, required this.lng, required this.address, required this.subAddress});

  @override
  State<TopMap> createState() => _TopMapState();
}

class _TopMapState extends State<TopMap> {

  var houseNumber = TextEditingController();
  var roadName = TextEditingController();
  var directionToReach = TextEditingController();
  var contactNumber = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverToBoxAdapter(
          //   child: Text("Zesty", style: Theme.of(context).textTheme.bodyLarge,),
          // ),

          SliverAppBar(
            elevation: 0,
            pinned: true,
            centerTitle: false,
            expandedHeight: ZMediaQuery(context).height / 4,
            flexibleSpace: FlexibleSpaceBar(
              background: GoogleMap(
                zoomControlsEnabled: false,// Disable zoom controls
                scrollGesturesEnabled: false,// Disable moving/panning of the map
                zoomGesturesEnabled: false,// Disable zoom gestures (pinch to zoom)
                rotateGesturesEnabled: false,// Disable rotation gestures
                tiltGesturesEnabled: false,// Disable tilt gestures
                initialCameraPosition: CameraPosition(
                      target: LatLng(widget.lat, widget.lng),
                    zoom: 18.0,
                  ),
                markers: {
                  Marker(
                    markerId: MarkerId("user_current_location"),
                    position: LatLng(widget.lat, widget.lng),
                  )
                },
              ),
            ),
          ),

          /// Display location
          SliverAppBar(
            automaticallyImplyLeading: false,// Hide the back arrow
            elevation: 0,
            pinned: true,
            bottom: PreferredSize(preferredSize: Size.fromHeight(-15.0), child: SizedBox()),
            flexibleSpace: ListTile(
              title: Text(
                widget.address,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              subtitle: Text(
                widget.subAddress,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              trailing: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: ZMediaQuery(context).isDarkMode
                          ? TColors.bgLight
                          : TColors.darkGrey,
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Change",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// Textfield for getting address
          addressTextFields(houseNumber: houseNumber, roadName: roadName, directionToReach: directionToReach, contactNumber: contactNumber)
        ],
      )
    );
  }
}

class addressTextFields extends StatelessWidget {
  const addressTextFields({
    super.key,
    required this.houseNumber,
    required this.roadName,
    required this.directionToReach,
    required this.contactNumber,
  });

  final TextEditingController houseNumber;
  final TextEditingController roadName;
  final TextEditingController directionToReach;
  final TextEditingController contactNumber;

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              "House / Flat number",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 5),
            ZCustomTextField(
              controller: houseNumber,
              hintText: "HOUSE, FLAT, BLOCK NO.",
            ),
            const SizedBox(height: 25),
            Text(
              "Apartment / road name (optional)",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 5),
            ZCustomTextField(
              controller: roadName,
              hintText: "APARTMENT, ROAD, AREA",
            ),
            const SizedBox(height: 25),
            Text(
              "Direction to reach (optional)",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 5),
            TextFormField(
              maxLines: 4,
              controller: directionToReach,
              maxLength: 200,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                  hintText: "e.g. Ring the bell on the red gate",
                  counterStyle: TextStyle(fontSize: 10)
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Contact number",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 5),
            ZCustomTextField(
              controller: contactNumber,
              hintText: "00000 00000",
              keyboardType: TextInputType.number,
              maxLength: 10,
            ),
            const SizedBox(height: 25),
            Text(
              "Address type",
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 10),
            AddressTypeButton(),
            const SizedBox(height: 50),
            ZElevatedButton(title: "Add Address", onPress: () {}),
            const SizedBox(height: 30),

          ],
        ),
      )
    ]));
  }
}
