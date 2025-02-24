import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/screens/home/home.dart';
import '../../../custom_widget/elevatedButton_cust.dart';
import '../../../custom_widget/textfield_cust.dart';
import 'addressTypeButton.dart';

class addressTextFields extends StatelessWidget {
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

  void _validation(BuildContext context) async {
    if (formKey.currentState!.validate()) {

       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen(address: address, subAddress: subAddress),), (Route<dynamic> route) => false,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
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
