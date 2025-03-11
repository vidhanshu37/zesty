import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zesty/screens/home/home.dart';
import 'package:zesty/screens/home/user_profile/add_new_address.dart';
import 'package:zesty/utils/constants/colors.dart';
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
    required this.contactNumber,
    required this.address,
    required this.subAddress,
    required this.userName,
    required this.formKey,
    required this.userLat,
    required this.userLong,
  });

  final double userLat;
  final double userLong;
  final TextEditingController userName;
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
  var checkExist = Hive.box(HiveOpenBox.storeAddress);
  Map<String, dynamic>? userData = {};

  void _validation(BuildContext context) async {
    if (widget.formKey.currentState!.validate()) {
      if(checkExist.isEmpty) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("pella")));
        userRegisterAPI(context);
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("data")));
        updateAddress(context);
      }
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
            "address": "${box.get(HiveOpenBox.address)}*${widget.contactNumber.text}*${box.get(HiveOpenBox.lat, defaultValue: "21.2049")}*${box.get(HiveOpenBox.long, defaultValue: "72.8411")}",
            "latitute": widget.userLat,
            "longitude": widget.userLat,
          }));

      userData = jsonDecode(response.body);

      if(response.statusCode == 200) {
        // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("User register")));
        var hiveBox = Hive.box(HiveOpenBox.storeAddress);
        hiveBox.put(HiveOpenBox.storeAddressTitle, box.get(HiveOpenBox.address) ?? "surat");
        hiveBox.put(HiveOpenBox.storeAddressLat, userData!['user']['latitute'] ?? "21.2049");
        hiveBox.put(HiveOpenBox.storeAddressLong, userData!['user']['longitude'] ?? "72.8411");
        hiveBox.put(HiveOpenBox.userMobile, userData!['user']['mobile'] ?? "1234567890");
        hiveBox.put(HiveOpenBox.userId, userData!['user']['_id'] ?? "00");
        hiveBox.put(HiveOpenBox.userEmail, userData!['user']['email'] ?? "abc");
        hiveBox.put(HiveOpenBox.userZestyLite, userData!['user']['zestyLite'] ?? "false");
        hiveBox.put(HiveOpenBox.userZestyMoney, userData!['user']['zestyMoney'] ?? "0");
        hiveBox.put(HiveOpenBox.userName, widget.userName.text);

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

  Future<void> updateAddress(context) async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/update-user');

    try {
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "address": "${box.get(HiveOpenBox.address)}*${widget.contactNumber.text}*${widget.userLat}*${widget.userLong}",
            "id": checkExist.get(HiveOpenBox.userId),
          }));


      if(response.statusCode == 200) {
        var hiveBox = Hive.box(HiveOpenBox.storeAddress);
        hiveBox.put(HiveOpenBox.storeAddressTitle,  box.get(HiveOpenBox.address));
        // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (builder) => AddNewAddress()), (route) => route.isFirst);
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch(e) {
      print("error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("e.toString()")));
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
                  } else if (!RegExp(r'^[a-zA-z0-9 \-&]+$').hasMatch(value)){
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

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("\t\tPersonal information", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),),
                  Divider(color: TColors.darkerGrey, height: 2)
                ],
              ),
              const SizedBox(height: 20,),


              /// User name
              Text(
                "User name",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 5),
              ZCustomTextField(
                controller: widget.userName,
                hintText: "RECEIVER's NAME",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name is required!";
                  } else if (!RegExp(r'^[a-zA-z ]+$').hasMatch(value)){
                    return "Only letters and space allowed";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),

              /// Contact number
              Text(
                "Contact number",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              SizedBox(height: 5,),
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

              /// Address type
              Text(
                "Address type",
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 10),
              AddressTypeButton(),
              const SizedBox(height: 50),
              ZElevatedButton(title: "Add Address", onPress: () {
                _validation(context);
                // box.get(HiveOpenBox.address);
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(widget.userLat.toString())));
              }),
              const SizedBox(height: 30),

            ],
          ),
        ),
      )
    ]));
  }
}
