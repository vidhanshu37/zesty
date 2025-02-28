import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';

TableRow tableRow(String title,String value) {
  return TableRow(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          color: Colors.grey.shade200,
          child: Text(title, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 14,
              color: TColors.black),),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Text(value, style: TextStyle(color: TColors.black),),
        ),
      ]
  );
}