import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConfirmLocation extends StatefulWidget {
  const ConfirmLocation({super.key});

  @override
  State<ConfirmLocation> createState() => _ConfirmLocationState();
}

class _ConfirmLocationState extends State<ConfirmLocation> {

  String _locationMessage = "Fetching location...";
  late LatLng longitude;
  late LatLng latitude;

  getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      LocationPermission ask = await Geolocator.requestPermission(); // if user denied once it ask again for grant permission
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      latitude = currentPosition.latitude as LatLng;
      longitude = currentPosition.longitude as LatLng;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _locationMessage = "Location services are disabled.";
      });
      return;
    }

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
      return;
    }

    // Get the current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _locationMessage =
        "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    } catch (e) {
      setState(() {
        _locationMessage = "Error: $e";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // getCurrentLocation();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(_locationMessage)),
    );
  }
}
