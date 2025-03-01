import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/add_manually_address/addAddressDetailsHelper/sliverMapAddress.dart';
import 'package:zesty/screens/add_manually_address/shimmerMap.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

import '../../utils/local_storage/HiveOpenBox.dart';
import '../location_access/showFloatingManualLocation.dart';

class ShowGoogleMap extends StatefulWidget {
  final double latitude;
  final double longitude;

  const ShowGoogleMap(
      {super.key, required this.latitude, required this.longitude});

  @override
  State<ShowGoogleMap> createState() => _ShowGoogleMapState();
}

class _ShowGoogleMapState extends State<ShowGoogleMap> {
  late LatLng _userLocation;
  final Completer<GoogleMapController> _controller = Completer();
  String? address;
  String? subAddress;
  bool _isFetchingLocation = false;

  @override
  void initState() {
    super.initState();
    _userLocation = LatLng(widget.latitude, widget.longitude);
    _fetchAddress(_userLocation.latitude, _userLocation.longitude);
  }

  /// Store address and subAddress
  void storeAddress(title, subTitle) {
    // var box = Hive.box(HiveOpenBox.storeAddress);
    // box.put(HiveOpenBox.storeAddressTitle, title);
    // box.put(HiveOpenBox.storeAddressSubTitle, subTitle);
    var box = Hive.box(HiveOpenBox.storeLatLongTable);
    box.put(HiveOpenBox.address, title);
  }


  // fetching address for location and show street name etc from geolocation
  Future<void> _fetchAddress(double latitude, double longitude) async {
    try {
      setState(() {
        _isFetchingLocation = true;
      });

      await Future.delayed(const Duration(milliseconds: 300)); // for showing shimmer effect

      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude, longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        setState(() {
          address = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}, ${place.postalCode}";
          subAddress = "";
          storeAddress(address, subAddress);
          _isFetchingLocation = false;
        });
      }
    } catch (e) {
      setState(() {
        _isFetchingLocation = false;
        address = "Error fetching address";
        subAddress = "";
      });
    }
  }

  Future<void> _goToCurrentLocation() async {
    // Fetch current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    LatLng currentLatLng = LatLng(position.latitude, position.longitude);

    // Animate camera to current location
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(currentLatLng, 18.0),
    );

    // Update user location and address
    setState(() {
      _userLocation = currentLatLng;
    });
    _fetchAddress(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: ZMediaQuery(context).height * 0.75,
              width: ZMediaQuery(context).width,
              child: GoogleMap(
                myLocationEnabled: true,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: _userLocation,
                  zoom: 18.0,
                ),
                onCameraMove: (position) {
                  setState(() {
                    _userLocation = position.target;
                  });
                },
                onCameraIdle: () {
                  _fetchAddress(_userLocation.latitude, _userLocation.longitude);
                },
                onMapCreated: (controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ),
          // Center marker
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: ZMediaQuery(context).height * 0.72 ,
              width: ZMediaQuery(context).width,
              child: Icon(Icons.location_on_rounded, size: 50, color: Colors.black),
            ),
          ),
          // Address details
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: ZMediaQuery(context).height * 0.26,
              width: ZMediaQuery(context).width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(17),
                  topRight: Radius.circular(17),
                ),
                color: TColors.bgLight,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -4),
                    blurRadius: 10,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ListTile(
                    leading: const Icon(Icons.location_on_rounded, size: 30,),
                    title: _isFetchingLocation
                        ? const ShimmerEffectsLocation()
                        : Text(
                      address ?? "Fetching address...",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    subtitle: _isFetchingLocation ? null
                        : Text(
                      subAddress ?? "",
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        showFloatingSheet(context);
                      },
                      child: Container(
                        width: 70,
                        height: 30,
                        decoration: BoxDecoration(
                            color: TColors.ligthGreen.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text("Change")),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ZElevatedButton(
                      title: "Confirm Location",
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TopMap(
                              lat: _userLocation.latitude,
                              lng: _userLocation.longitude,
                              address: address ?? "",
                              subAddress: subAddress ?? "",
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Current location button
          Positioned(
              top: 530,
              left: ZMediaQuery(context).width / 4,
              child: InkWell(
                onTap: () {
                  _goToCurrentLocation();
                },
                child: Container(
                  height: 40,
                  width: 210,
                  decoration: BoxDecoration(
                      color: TColors.grey.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: TColors.darkGrey, width: 1.5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.my_location_sharp,
                        color: TColors.black,
                      ),
                      // SizedBox(width: 10,),
                      Center(
                          child: Text(
                            "Use current location",
                            style: TextStyle(color: TColors.black),
                          )),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
