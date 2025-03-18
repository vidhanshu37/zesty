import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/media_query.dart';

import '../../../utils/constants/colors.dart';

class AddressTypeButton extends StatefulWidget {
  const AddressTypeButton({super.key});

  @override
  State<AddressTypeButton> createState() => _AddressTypeButtonState();
}

class _AddressTypeButtonState extends State<AddressTypeButton> {

  int selectedIndex = -1;
  final List<String> titles = ["Home", "Office", "Others"];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: Container(
              width: 70,
              height: 30,
              decoration: BoxDecoration(
                  color: selectedIndex == index ? TColors.ligthGreen.withOpacity(0.4) : TColors.softGrey,
                  borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  titles[index]
                ),
              ),
            ),
          ),
        );
      })
    );
  }
}
