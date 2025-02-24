import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:zesty/screens/add_manually_address/googleMap.dart';
import 'package:zesty/screens/add_manually_address/shimmerMap.dart';

class ConfirmLocation extends StatefulWidget {
  const ConfirmLocation({super.key});

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {

  String _locationMessage = "Fetching location...";
  final Completer<GoogleMapController> _controller = Completer();
  bool _isLocationFetched = false; // Track location fetching status
  late double userLatitude;
  late double userLongitude;

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationMessage = "Location permissions are denied.";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _locationMessage = "Location permissions are permanently denied.";
      });
      _showPermissionDeniedDialog();
      return;
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        userLatitude = position.latitude;
        userLongitude = position.longitude;
        _locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
        _isLocationFetched = true; // Ensure Mark location as fetched
        storeData(position.latitude, position.longitude);
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
      });
    }
  }

  /// store latitude and longitude of user
  void storeData(double latitude,double longitude) {
    var hiveBox = Hive.box("zestyBox");
    hiveBox.put("latitude", latitude);
    hiveBox.put("longitude", longitude);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
            children: [
              _isLocationFetched
                  ? ShowGoogleMap(latitude: userLatitude, longitude: userLongitude)
                  : Text(_locationMessage),
            ],
          )
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Location Permission Needed"),
        content: Text(
            "Location permissions are permanently denied. Please enable them in the app settings."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Cancel", style: TextStyle(color: Color(0xffCAE97C)),),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Geolocator.openAppSettings(); // Opens app settings
            },
            child: Text("Open Settings", style: TextStyle(color: Color(0xffCAE97C)),),
          ),
        ],
      ),
    );
  }

}
