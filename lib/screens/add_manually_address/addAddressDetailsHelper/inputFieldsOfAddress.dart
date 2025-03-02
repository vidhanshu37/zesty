import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/utils/http/userExistAPI.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import '../../../custom_widget/elevatedButton_cust.dart';
import '../../../custom_widget/textfield_cust.dart';
import 'addressTypeButton.dart';
import 'package:http/http.dart' as http;

class addressTextFields extends StatefulWidget {
  const addressTextFields({
    super.key,
    required this.houseNumber,
    required this.roadName,
    required this.directionToReach,
    required this.contactNumber, required this.address, required this.subAddress,
    required this.formKey,
  });

  final TextEditingController houseNumber;
  final TextEditingController roadName;
  final TextEditingController directionToReach;
  final TextEditingController contactNumber;
  final String address;
  final String subAddress;
  final formKey;

  @override
  State<addressTextFields> createState() => _addressTextFieldsState();
}

class _addressTextFieldsState extends State<addressTextFields> {
  var box = Hive.box(HiveOpenBox.storeLatLongTable);
  Map<String, dynamic>? userData = {};

  void _validation(BuildContext context) async {
    if (widget.formKey.currentState!.validate()) {
      userRegisterAPI(context);
    }
  }

  Future<void> userRegisterAPI(context) async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/register');
    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "mobile": box.get(HiveOpenBox.mobile, defaultValue: "1234567890"),
            "email": box.get(HiveOpenBox.email, defaultValue: "abc"),
            "address": box.get(HiveOpenBox.address, defaultValue: "abc"),
            "latitute": box.get(HiveOpenBox.lat, defaultValue: "21.2049"),
            "longitude": box.get(HiveOpenBox.long, defaultValue: "72.8411")
          }));

      userData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User register")));
        var hiveBox = Hive.box(HiveOpenBox.storeAddress);
        hiveBox.put(HiveOpenBox.storeAddressTitle, userData!['user']['address'] ?? "surat");
        hiveBox.put(HiveOpenBox.storeAddressLat, userData!['user']['latitute'] ?? "21.2049");
        hiveBox.put(HiveOpenBox.storeAddressLong, userData!['user']['longitude'] ?? "72.8411");
        hiveBox.put(HiveOpenBox.userMobile, userData!['user']['mobile'] ?? "1234567890");
        hiveBox.put(HiveOpenBox.userId, userData!['user']['_id'] ?? "00");
        hiveBox.put(HiveOpenBox.userEmail, userData!['user']['email'] ?? "abc");
        hiveBox.put(HiveOpenBox.userZestyLite, userData!['user']['zestyLite'] ?? "false");
        hiveBox.put(HiveOpenBox.userZestyMoney, userData!['user']['zestyMoney'] ?? "0");


        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(address: box.get(HiveOpenBox.address, defaultValue: "abc"), subAddress: ""),), (Route<dynamic> route) => false,);
      } else if (response.statusCode == 405) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User exist")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: widget.formKey,
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
                controller: widget.houseNumber,
                hintText: "HOUSE, FLAT, BLOCK NO.",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "House number is required!";
                  } else if (!RegExp(r'^[a-zA-z0-9]+$').hasMatch(value)){
                    return "Only letters and numbers allowed";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Text(
                "Apartment / road name (optional)",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 5),
              ZCustomTextField(
                controller: widget.roadName,
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
                controller: widget.directionToReach,
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
                controller: widget.contactNumber,
                hintText: "00000 00000",
                keyboardType: TextInputType.number,
                maxLength: 10,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required!";
                  } else if(!RegExp(r"^\d{10}$").hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Text(
                "Address type",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 10),
              AddressTypeButton(),
              const SizedBox(height: 50),
              ZElevatedButton(title: "Add Address", onPress: () {
                _validation(context);
                // Navigator.of(context).pushAndRemoveUntil(
                //     MaterialPageRoute(builder: (context) => HomeScreen(
                //       address: address,
                //       subAddress: subAddress,
                //     )),
                //       (Route<dynamic> route) => false,);
              }),
              const SizedBox(height: 30),

            ],
          ),
        ),
      )
    ]));
  }
}
