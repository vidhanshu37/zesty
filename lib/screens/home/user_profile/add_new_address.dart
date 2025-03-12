import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/custom_widget/elevatedButton_cust.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:zesty/utils/constants/media_query.dart';
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:http/http.dart' as http;

import '../../add_manually_address/confirmLocation.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({super.key});

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  
  var box = Hive.box(HiveOpenBox.storeAddress);
  Map<String, dynamic> userAllData = {};
  List addresses = [];

  Future<void> fetchAddress() async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/get/${box.get(HiveOpenBox.userId)}');
    // final url = Uri.parse('https://zesty-backend.onrender.com/user/get/');
    try{
      final response = await http.get(url);
      if ( response.statusCode == 200 ) {
        userAllData = jsonDecode(response.body);
        addresses = userAllData['address'];
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void updateUI() {
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    fetchAddress();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADDRESSES"),
        backgroundColor: TColors.grey,
      ),
      body: userAllData.isEmpty ? Center(child: CircularProgressIndicator(color: Colors.black,),) : Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("SAVED ADDRESS", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500),),
            SizedBox(height: 15,),
            Expanded(
              child: SizedBox(
                width: ZMediaQuery(context).width - 10,
                child: ListView.builder(
                  itemCount: addresses.length,
                    itemBuilder: (context, index) {
                      return addressCard(address: addresses[index], box: box, index: index, context: context,);
                }),
              ),
            ),
            Container(
              height: 80,
              width: double.infinity,
              color: TColors.bgLight,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
              child: ZElevatedButton(title: "ADD ADDRESS", onPress: (){
                // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(addresses.length.toString())));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConfirmLocation()));

              }),
            )
          ],
        ),
      ),
    );
  }
}

class addressCard extends StatefulWidget {
  addressCard({
    super.key,
    required this.address,
    required this.box,
    required this.index,
    required this.context,
  });

  final BuildContext context;
  final int index;
  final String address;
  final Box box;

  @override
  State<addressCard> createState() => _addressCardState();
}

class _addressCardState extends State<addressCard> {
  
  List<String> filterAddress = [];
  var bgColor = TColors.white;
  
  Future<void> deleteAddress() async {
    final url = Uri.parse('https://zesty-backend.onrender.com/user/delete-address');
    try{
      final response = await http.post(
          url,
          headers: {
            "Content-Type": "application/json"
          },
          body: jsonEncode({
            "address": widget.address,
            "id": widget.box.get(HiveOpenBox.userId),
          })
      );

      if(response.statusCode == 200) {
        // ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(content: Text("Deleted!")));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) => AddNewAddress()));
      } else {
        ScaffoldMessenger.of(widget.context).showSnackBar(SnackBar(content: Text(response.statusCode.toString())));
      }
    } catch (e) {
      print(e);
    }
  }

  void selectAddress() {
    var box = Hive.box(HiveOpenBox.storeAddress);
    box.put(HiveOpenBox.storeAddressTitle, filterAddress[0]);
    box.put(HiveOpenBox.storeAddressLat, filterAddress[2]);
    box.put(HiveOpenBox.storeAddressLong, filterAddress[3]);
  }
  
  @override
  void initState() {
    super.initState();
    filterAddress = widget.address.split("*");
  }

  // filterAddress = 0-address, 1-phone, 2-latitude, 3-longitude

  @override
  Widget build(BuildContext context) {
    return Card(
      color: bgColor,
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20,),
            Text(filterAddress[0], style: Theme.of(context).textTheme.bodyLarge,),
            SizedBox(height: 5,),
            Text(
              "Phone number: ${filterAddress[1]}", style: Theme.of(context).textTheme.labelLarge,),
            SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton(onPressed: (){
                  selectAddress();
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.box.get(HiveOpenBox.storeAddressLong)}")));
                }, child: Text("SELECT", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600, color: TColors.Green),)),
                // SizedBox(width: 5,),
                TextButton(onPressed: (){
                  deleteAddress();
                }, child: Text("DELETE", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600, color: TColors.Green),)),
              ],
            ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
