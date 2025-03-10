import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../custom_widget/elevatedButton_cust.dart';
import '../../../custom_widget/textfield_cust.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/media_query.dart';
import 'addressTypeButton.dart';
import 'inputFieldsOfAddress.dart';

class TopMap extends StatefulWidget {
  final double lat, lng;
  final address, subAddress;

  const TopMap(
      {super.key,
      required this.lat,
      required this.lng,
      required this.address,
      required this.subAddress});

  @override
  State<TopMap> createState() => _TopMapState();
}

class _TopMapState extends State<TopMap> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var houseNumber = TextEditingController();
  var roadName = TextEditingController();
  var directionToReach = TextEditingController();
  var contactNumber = TextEditingController();
  var userName = TextEditingController();

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
          backgroundColor: TColors.bgLight,
          expandedHeight: ZMediaQuery(context).height / 4,
          collapsedHeight: 30,
          toolbarHeight: 30,
          flexibleSpace: FlexibleSpaceBar(
            background: GoogleMap(
              zoomControlsEnabled: false,
              // Disable zoom controls
              scrollGesturesEnabled: false,
              // Disable moving/panning of the map
              zoomGesturesEnabled: false,
              // Disable zoom gestures (pinch to zoom)
              rotateGesturesEnabled: false,
              // Disable rotation gestures
              tiltGesturesEnabled: false,
              // Disable tilt gestures
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
          automaticallyImplyLeading: false,
          // Hide the back arrow
          elevation: 0,
          pinned: true,
          backgroundColor: TColors.bgLight,
          bottom: PreferredSize(
              preferredSize: Size.fromHeight(-15.0), child: SizedBox()),
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
                    color: TColors.darkGrey,
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
        addressTextFields(
            houseNumber: houseNumber,
            roadName: roadName,
            directionToReach: directionToReach,
            contactNumber: contactNumber,
            address: widget.address,
          subAddress: widget.subAddress,
          formKey: _formKey,
          userName: userName,
          userLat: widget.lat,
          userLong: widget.lng,
        )
      ],
    ));
  }
}
