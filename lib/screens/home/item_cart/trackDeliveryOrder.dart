import 'dart:async';
import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:url_launcher/url_launcher.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';

import '../../../utils/constants/api_constants.dart';
import '../../../utils/local_storage/HiveOpenBox.dart'; // For making HTTP requests

class TrackDeliveryOrder extends StatefulWidget {

  final double ResLatitude;
  final double ResLongitude;
  final String restaurantId;
  final String totalCartValue;


  const TrackDeliveryOrder({super.key, required this.ResLongitude, required this.ResLatitude, required this.restaurantId, required this.totalCartValue});

  @override
  State<TrackDeliveryOrder> createState() => _TrackDeliveryOrderState();
}

class _TrackDeliveryOrderState extends State<TrackDeliveryOrder>{

  // @override
  // bool get wantKeepAlive => true;

  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _polylineCoordinates = [];

  var box = Hive.box(HiveOpenBox.storeAddress);


  // Fixed locations
  LatLng _userLocation = LatLng(0.0, 0.0); // User's fixed location
  LatLng _restaurantLocation = LatLng(0.0, 0.0); // Restaurant's fixed location


  // Source marker (restaurant)
  LatLng? _sourceMarkerLocation; // Dynamic location for the source marker
  int _currentPointIndex = 0; // Index of the current point in the polyline coordinates

  Timer? _sourceMarkerMovementTimer; // Timer for animating source marker movement

  late IO.Socket socket;
  String display = "Order received! Waiting for restaurant acceptance.";

  Map<String, dynamic>? restaurantData;

  Future<void> fetchRestaurantData() async {
    final url = Uri.parse(ApiConstants.getSingleRestaurantData(widget.restaurantId));
    try {
      final response = await http.get(url);

      if(response.statusCode == 200) {
        setState(() {
          restaurantData = jsonDecode(response.body);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch (e) {
      print(e);

    }
  }


  @override
  void initState() {
    super.initState();

    fetchRestaurantData();
    _calculateETA(widget.ResLatitude, widget.ResLongitude);

    setState(() {
      _userLocation = LatLng(
          double.parse(box.get(HiveOpenBox.storeAddressLat, defaultValue: 21.1702)),
          double.parse(box.get(HiveOpenBox.storeAddressLong, defaultValue: 72.8311))
      );
      _restaurantLocation = LatLng(widget.ResLatitude, widget.ResLongitude);
    });

    _updateMap(); // Initialize map with markers and polyline
    socket = IO.io('https://zesty-backend.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();
    socket.emit("user_join", box.get(HiveOpenBox.userId));

    socket.on("order", (data) {
      print("Order updated: ${data['orderStatus']}");
      setState(() {
        display = data['orderStatus'];

        if(display == "Active") {
          display = "Your food is being prepared.";
        } else if (display == "Prepared") {
          display = "Your food is prepared.";
        }

        if(display == 'Delivered') {
          _startSourceMarkerMovement();
        }

        if(display == "Rejected") {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Sorry, your order is rejected by restaurant!',
            onConfirmBtnTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen(address: box.get(HiveOpenBox.storeAddressTitle, defaultValue: "Surat"), subAddress: "")), (predicate) => false);
            },
            barrierDismissible: false
          );
        }
      });
    });
  }


  /// rejected pop-up

  @override
  void dispose() {
    _sourceMarkerMovementTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }


  // Update the map based on the current stage
  Future<void> _updateMap() async {
    _markers.clear();

    // Add destination marker (user)
    _markers.add(Marker(
      markerId: MarkerId("User"),
      position: _userLocation,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue), // Blue marker for user
      infoWindow: const InfoWindow(title: "User", snippet: "Delivery location"),
    ));

    try {
      // Fetch route from OSRM API between restaurant and user
      final routeCoordinates = await fetchRouteOSRM(_restaurantLocation, _userLocation);

      // Update polyline
      _polylineCoordinates.clear();
      _polylineCoordinates.addAll(routeCoordinates);

      // Initialize source marker's location at the restaurant
      _sourceMarkerLocation = _restaurantLocation;
      _currentPointIndex = 0;

      // Add source marker (restaurant)
      _markers.add(Marker(
        markerId: MarkerId("SourceMarker"),
        position: _sourceMarkerLocation!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen), // Green marker for source
        infoWindow: const InfoWindow(title: "Delivery partner", snippet: "Moving..."),
      ));

      // Update the polyline to show the remaining path
      _updateRemainingPolyline();

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to fetch route: $e")),
      );
    }
  }

  Future<void> dialPhoneNumber(phoneNumber) async {
    final url = Uri.parse("tel:$phoneNumber");
    if(await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw "Could not launch $url";
    }
  }

  // Update the polyline to show the remaining path
  void _updateRemainingPolyline() {
    _polylines.clear();
    _polylines.add(Polyline(
      polylineId: PolylineId("Route"),
      points: _polylineCoordinates.sublist(_currentPointIndex),
      color: Colors.black,
      width: 5,
    ));
  }

  // Start source marker movement along the route
  void _startSourceMarkerMovement() {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("tushar")));
    _sourceMarkerMovementTimer?.cancel(); // Cancel any existing timer

    _sourceMarkerMovementTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (_currentPointIndex < _polylineCoordinates.length - 1) {
        setState(() {
          _currentPointIndex++;
          _sourceMarkerLocation = _polylineCoordinates[_currentPointIndex];

          // Update the polyline to show the remaining path
          _updateRemainingPolyline();

          // Update the source marker
          _markers.removeWhere((marker) => marker.markerId.value == "SourceMarker");
          _markers.add(Marker(
            markerId: MarkerId("SourceMarker"),
            position: _sourceMarkerLocation!,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(title: "Restaurant", snippet: "Moving..."),
          ));
        });
      }
      else {
        timer.cancel(); // Stop the timer when the source marker reaches the user
        // showDeliveredDialog();
        QuickAlert.show(
            barrierDismissible: false,
            context: context,
            type: QuickAlertType.success,
            title: 'Order Delivered',
            text: 'Your order has been successfully delivered!',
            onConfirmBtnTap: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen(address: box.get(HiveOpenBox.storeAddressTitle, defaultValue: "Surat"), subAddress: "")), (predicate) => false);
            },
          confirmBtnColor: Colors.black,
        );
      }
    });
  }

  Future<List<LatLng>> fetchRouteOSRM(LatLng start, LatLng end) async {
    final String url =
        'https://router.project-osrm.org/route/v1/driving/${start.longitude},${start.latitude};${end.longitude},${end.latitude}?overview=full&geometries=geojson';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final route = data['routes'][0]['geometry']['coordinates'] as List;
      return route
          .map((point) => LatLng(point[1], point[0]))
          .toList(); // LatLng expects [latitude, longitude].
    } else {
      throw Exception(
          'Failed to fetch route. Status code: ${response.statusCode}');
    }
  }

  String _eta = "";

  Future<void> _calculateETA(resLatitude, resLongitude) async {
    var box = Hive.box(HiveOpenBox.storeAddress);
    final url = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$resLongitude,$resLatitude;${double.parse(box.get(HiveOpenBox.storeAddressLong))},${double.parse(box.get(HiveOpenBox.storeAddressLat))}?overview=false');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final duration = (data['routes'][0]['duration'] / 60) + 10; // Convert seconds to minutes
      setState(() {
        _eta = "${duration.toStringAsFixed(0)} mins";
      });
    } else {
      setState(() {
        _eta = "Calculating...";
      });
    }
  }


  /// show alert - order is delivered!
  void showDeliveredDialog() {
    showDialog(context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Order Delivered"),
        content: Text("Your order has been successfully delivered!"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => HomeScreen(address: box.get(HiveOpenBox.storeAddressTitle, defaultValue: "Surat"), subAddress: "")), (predicate) => false);
          }, child: Text("OK"))
        ],
      );
    });
  }

  var boxCart = Hive.box(HiveOpenBox.zestyFoodCart);

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.arrow_back, color: Colors.white,)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Your order delivering in", style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w500, color: Colors.white),),
              Text(_eta, style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w600, color: Colors.white))
            ],
          ),
          backgroundColor: TColors.ligthGreen,
          toolbarHeight: 80,
          centerTitle: true,
        ),
        body: restaurantData == null ? Center(child: CircularProgressIndicator(color: Colors.black,),) : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: SizedBox(
                  height: ZMediaQuery(context).height - 450,
                  width: ZMediaQuery(context).width,
                  child: GoogleMap(
                    zoomGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    // liteModeEnabled: true,
                    // trafficEnabled: true,
                    // zoomControlsEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    initialCameraPosition: CameraPosition(
                      target: _restaurantLocation, // Focus on the restaurant initially
                      zoom: 14,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                  ),
                ),
              ),
              // Button to start source marker movement
              SizedBox(height: 30,),

              /// order status and total cart price
              SizedBox(
                width: ZMediaQuery(context).width,
                child: Card(
                  color: TColors.white,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        display == "Rejected"
                            ? Text("Order Status: $display", style: Theme.of(context).textTheme.bodyLarge)
                            : display != "Delivered"
                                ? Text("Order Status: $display", style: Theme.of(context).textTheme.bodyLarge)
                                : Text("Order Status: Rider pick your order!", style: Theme.of(context).textTheme.bodyLarge),

                        SizedBox(height: 5,),
                        Text("Total cart value: ₹${widget.totalCartValue}")
                      ],
                    ),
                  ),
                ),
              ),

              /// restaurant details
              Card(
                color: TColors.white,
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: Icon(Icons.store, color: TColors.primary),
                    title: Text("${restaurantData!['restaurantName']}"),
                    subtitle: Text(
                        "${restaurantData!['shopNumber']}, ${restaurantData!['selectedArea']}, ${restaurantData!['city']}, ${restaurantData!['state']} - ${restaurantData!['pincode']}"),
                    trailing: IconButton(
                      icon: Icon(Icons.call, color: TColors.primary),
                      onPressed: () {
                        dialPhoneNumber(restaurantData!['mobile']);// Implement call functionality
                        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(boxCart.length.toString())));
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}