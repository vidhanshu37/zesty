import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:location/location.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import '../../../utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;

class TrackOrder extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String restaurantId;

  const TrackOrder({
    super.key,
    required this.restaurantId,
    required this.longitude,
    required this.latitude,
  });

  @override
  State<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends State<TrackOrder> {
  Map<String, dynamic>? restaurantData;
  bool _isLoading = true;
  String? _eta;
  String _driverName = "John Doe";
  String _vehicleNumber = "AB 1234";
  String _driverContact = "+91 9876543210";
  String _orderStatus = "Preparing";
  List<String> _orderHistory = [];

  final Completer<GoogleMapController> _controller = Completer();
  Location _location = Location();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  var box = Hive.box(HiveOpenBox.storeAddress);

  LatLng? _driverLocation;

  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    fetchRestaurantData();
    _getCurrentLocation();
    socket = IO.io('https://zesty-backend.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.emit("user_join", box.get(HiveOpenBox.userId));

    socket.on("order", (data) {
      print("Order updated: ${data['orderStatus']}");
      setState(() {
        _orderStatus = data['orderStatus'];
        _orderHistory.add("${DateTime.now().toLocal()}: $_orderStatus");
      });
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  Future<void> fetchRestaurantData() async {
    final url = Uri.parse(ApiConstants.getSingleRestaurantData(widget.restaurantId));
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        setState(() {
          restaurantData = jsonDecode(response.body);
          _isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.statusCode.toString())),
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    _location.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        _driverLocation = LatLng(
          currentLocation.latitude ?? 29.1712,
          currentLocation.longitude ?? 71.8111,
        );
        _updateRoute();
        _calculateETA();
      });
    });
  }

  Future<void> _updateRoute() async {
    if (_driverLocation == null) return;

    _markers.clear();
    _markers.add(Marker(
      markerId: MarkerId("Driver"),
      position: _driverLocation!,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      infoWindow: const InfoWindow(title: "Your Location"),
    ));
    _markers.add(Marker(
      markerId: MarkerId("User"),
      position: LatLng(widget.latitude, widget.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: "${restaurantData!['restaurantName']}"),
    ));

    try {
      final routeCoordinates = await fetchRouteOSRM(_driverLocation!, LatLng(widget.latitude, widget.longitude));
      _polylineCoordinates.clear();
      _polylineCoordinates.addAll(routeCoordinates);

      _polylines.clear();
      _polylines.add(Polyline(
        polylineId: PolylineId("Route"),
        points: _polylineCoordinates,
        color: Colors.blue,
        width: 5,
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch route: $e")),
      );
    }

    setState(() {});
  }

  Future<List<LatLng>> fetchRouteOSRM(LatLng start, LatLng end) async {
    final String url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;
      return route.map((point) => LatLng(point[1], point[0])).toList();
    } else {
      throw Exception('Failed to fetch route. Status code: ${response.statusCode}');
    }
  }

  Future<void> _calculateETA() async {
    if (_driverLocation == null) return;

    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/${_driverLocation!.longitude},${_driverLocation!.latitude};${widget.longitude},${widget.latitude}?overview=false');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final duration = data['routes'][0]['duration'] / 60; // Convert seconds to minutes
      setState(() {
        _eta = "${duration.toStringAsFixed(0)} mins";
      });
    } else {
      setState(() {
        _eta = "Calculating...";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("Track Order"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getCurrentLocation();
              _updateRoute();
            },
          ),
        ],
      ),
      body: _isLoading || _driverLocation == null || restaurantData == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Section
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SizedBox(
                  height: ZMediaQuery(context).height - 400,
                  width: ZMediaQuery(context).width,
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      controller.animateCamera(CameraUpdate.newLatLng(_driverLocation!));
                    },
                    initialCameraPosition: CameraPosition(
                      target: _driverLocation!,
                      zoom: 14,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Order Status and ETA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Order Status: ${_orderStatus}", style: Theme.of(context).textTheme.bodyLarge),
                  Text("ETA: $_eta", style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              SizedBox(height: 10),

              // Progress Bar
              LinearProgressIndicator(
                value: _orderStatus == "Preparing"
                    ? 0.3
                    : _orderStatus == "Out for Delivery"
                    ? 0.7
                    : 1.0,
                backgroundColor: Colors.grey[300],
                color: TColors.primary,
              ),
              SizedBox(height: 20),

              // Driver Details
              Text("Driver Details:", style: Theme.of(context).textTheme.bodyLarge),
              ListTile(
                leading: Icon(Icons.person, color: TColors.primary),
                title: Text(_driverName),
                subtitle: Text("Vehicle: $_vehicleNumber"),
                trailing: IconButton(
                  icon: Icon(Icons.call, color: TColors.primary),
                  onPressed: () {
                    // Implement call functionality
                  },
                ),
              ),
              SizedBox(height: 10),

              // Restaurant Details
              Text("Restaurant Details:", style: Theme.of(context).textTheme.bodyLarge),
              ListTile(
                leading: Icon(Icons.store, color: TColors.primary),
                title: Text("${restaurantData!['restaurantName']}"),
                subtitle: Text(
                    "${restaurantData!['shopNumber']}, ${restaurantData!['selectedArea']}, ${restaurantData!['city']}, ${restaurantData!['state']} - ${restaurantData!['pincode']}"),
                trailing: IconButton(
                  icon: Icon(Icons.call, color: TColors.primary),
                  onPressed: () {
                    // Implement call functionality
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}