import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/local_storage/HiveOpenBox.dart';

class MultiAddressCard extends StatefulWidget {
  MultiAddressCard({
    super.key,
    required this.address,
    required this.box,
    required this.index,
    required this.context,
    required this.onSelect,
  });

  final VoidCallback onSelect;
  final BuildContext context;
  final int index;
  final String address;
  final Box box;

  @override
  State<MultiAddressCard> createState() => _MultiAddressCardState();
}

class _MultiAddressCardState extends State<MultiAddressCard> {

  List<String> filterAddress = [];
  var bgColor = TColors.white;

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
            TextButton(onPressed: (){
              selectAddress();
              widget.onSelect;
              Navigator.pop(context, true);
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${widget.box.get(HiveOpenBox.storeAddressLong)}")));
            }, child: Text("SELECT", style: Theme.of(context).textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w600, color: TColors.Green),)),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
