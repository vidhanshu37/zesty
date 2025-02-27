import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:zesty/screens/home/zesty_Mart/single_Product/singleProduct.dart';
import 'package:zesty/utils/constants/api_constants.dart';
import 'package:zesty/utils/constants/manage_cart_item.dart';
import 'package:http/http.dart' as http;
import '../../../utils/constants/colors.dart';

class martItemCard extends StatefulWidget {
  final String imgId;
  final String name;
  final String weight;
  final String price;
  final List images;
  final String id;

  const martItemCard(
      {super.key,
        required this.imgId,
        required this.name,
        required this.weight,
        required this.price,
        required this.images,
        required this.id
      });

  @override
  State<martItemCard> createState() => _martItemCardState();
}


class _martItemCardState extends State<martItemCard> {
  int counterItem = 0;
  int _currentIndex = 0;
  // List<String> imageUrls = [];
  // bool isLoading = true;
  String errormessage = '';

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
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Singleproduct(id: widget.id,),));
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          height: 270,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
           boxShadow: [
             BoxShadow(
               color: TColors.grey,
               blurRadius: 2,
               spreadRadius: 0,
               offset: Offset(0, 1)
             )
           ]
          ),
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
                      child:
                           widget.images.isEmpty
                          ? const Center(child: Text("No images available"))
                          : Stack(
                             alignment: Alignment.bottomCenter,
                             children: [
                               CarouselSlider(
                                 options: CarouselOptions(
                                   height: 130,
                                   enlargeCenterPage: true,
                                   viewportFraction: 0.9,
                                   onPageChanged: (index, reason) {
                                     setState(() {
                                       _currentIndex = index;
                                     });
                                   },
                                 ),
                                 items: widget.images.map((imageUrl) {
                                   return ClipRRect(
                                     borderRadius: BorderRadius.circular(10),
                                     child:  Image.network(imageUrl,
                                         fit: BoxFit.cover,
                                         // height: 130,
                                         // width: 150,
                                        errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.image_not_supported, size: 130, color: Colors.grey);
                                        } ),
                                   );
                                 }).toList(),
                               ),
                               // Dot Indicator
                               Positioned(
                                 bottom: 8,
                                 right: 15,
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.end,
                                   children: widget.images.asMap().entries.map((entry) {
                                     return Container(
                                       width: _currentIndex == entry.key ? 7 : 5,
                                       height: _currentIndex == entry.key ? 7 : 5,
                                       margin: EdgeInsets.symmetric(horizontal: 3),
                                       decoration: BoxDecoration(
                                         shape: BoxShape.circle,
                                         color: _currentIndex == entry.key
                                             ? Colors.black
                                             : TColors.grey,
                                       ),
                                     );
                                   }).toList(),
                                 ),
                               ),
                             ],
                           ),
                  )
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
