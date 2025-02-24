import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/manage_cart_item.dart';

import '../../../utils/constants/colors.dart';

class martItemCard extends StatefulWidget {
  final String imgId;
  final String name;
  final String weight;
  final String price;

  const martItemCard(
      {super.key,
        required this.imgId,
        required this.name,
        required this.weight,
        required this.price});

  @override
  State<martItemCard> createState() => _martItemCardState();
}


class _martItemCardState extends State<martItemCard> {
  int counterItem = 0;


  void showSnackBar(BuildContext context) {
      // Convert Map records to a formatted string
      String mapData = ManageCartItem.manageMartCart.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join('\n');

      // Show Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mapData),
          duration: Duration(seconds: 3), // Duration to display the Snackbar
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        padding: EdgeInsets.all(5.0),
        // height: 270,
        width: 150,
        // color: Colors.amber,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product image
            ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: TColors.grey),
                        borderRadius: BorderRadius.circular(15)),
                    child: Image.network(
                      ApiConstants.getMartImage(widget.imgId),
                      fit: BoxFit.cover,
                      height: 130,
                      width: 150,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.image_not_supported, size: 130, color: Colors.grey);
                      },
                    ))),
            SizedBox(
              height: 12,
            ),

            /// Product name
            SizedBox(
                height: 40,
                child: Text(
                  widget.name,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                )),
            SizedBox(
              height: 12,
            ),

            /// Product weight
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "₹${widget.price}",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: TColors.darkerGrey),
                ),
                Text(
                  widget.weight,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                    color: TColors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: TColors.grey),
                    boxShadow: [
                      BoxShadow(
                          color: TColors.grey,
                          blurRadius: 3,
                          spreadRadius: 0,
                          offset: Offset(1, 1))
                    ]
                ),
                child: counterItem == 0
                    ? InkWell(
                    onTap: () {
                      counterItem++;
                      ManageCartItem.manageMartCart[widget.imgId] = counterItem;
                      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ManageCartItem.manageCartItem[widget.imgId].toString())));
                      showSnackBar(context);
                      setState(() {});
                    },
                    child: Center(
                        child: Text(
                          "ADD",
                          style: TextStyle(
                              color: Colors.green[600],
                              fontWeight: FontWeight.bold),
                        )))
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        counterItem--;
                        ManageCartItem.manageMartCart[widget.imgId] = counterItem;
                        showSnackBar(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.remove),
                      color: Colors.green[600],
                      iconSize: 16,
                    ),
                    Text(counterItem.toString(),
                        style: TextStyle(
                            color: Colors.green[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    IconButton(
                      onPressed: () {
                        counterItem++;
                        ManageCartItem.manageMartCart[widget.imgId] = counterItem;
                        showSnackBar(context);
                        setState(() {});
                      },
                      icon: Icon(Icons.add),
                      color: Colors.green[600],
                      iconSize: 16,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
