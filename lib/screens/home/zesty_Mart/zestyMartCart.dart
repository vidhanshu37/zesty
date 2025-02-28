import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class Zestymartcart extends StatefulWidget {
  const Zestymartcart({super.key});

  @override
  State<Zestymartcart> createState() => _ZestymartcartState();
}

class _ZestymartcartState extends State<Zestymartcart> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Ordering from, ", style: Theme.of(context).textTheme.labelMedium,),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: ListTile(
                  leading: Icon(Icons.location_on_rounded),
                  title: Text("Delivery Address", style: Theme.of(context).textTheme.bodyLarge,),
                  // subtitle: Text("${boxAddress.get(HiveOpenBox.storeAddressTitle)}, ${boxAddress.get(HiveOpenBox.storeAddressSubTitle)}", style: Theme.of(context).textTheme.labelMedium, maxLines: 1,),
                  trailing: Icon(Icons.arrow_forward_ios_outlined, size: 16, color: TColors.darkerGrey,),
                ),
              ),
            ),
            Card(
              color: TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigator.push(context, MaterialPageRoute(builder: (context) => ,));
                          },
                          child: Text(
                            "+ Add more items",
                            style: TextStyle(
                                fontSize: 13,
                                color: TColors.darkGreen),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 10,
            ),

            Card(
              color: TColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              // elevation: 2,
              child: Column(
                children: [
                  ExpansionTile(
                    iconColor: TColors.black,
                    collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide.none),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10,),
                        Text(
                          // "$total",
                          // getTotalToPay(),
                          "To Pay ",
                              // + getTotal(),
                          // "To Pay ₹${(double.parse(calculateTotalCartValue().toStringAsFixed(2)) + double.parse(calculateDeliveryCharge().toStringAsFixed(2)) + packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                          //     .fold(0.0, (sum, element) => sum + element) + calculateTotalCartValue() * 0.05).toStringAsFixed(2)}",

                          style:
                          Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text("Incl. all taxes & charges",
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium),
                      ],
                    ),
                    trailing: Icon(isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down),
                    onExpansionChanged: (bool expanded) {
                      setState(() {
                        isExpanded = expanded;
                      });
                    },
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Divider(
                              color: TColors.grey,
                            ),
                          ),


                          /// Item total - price
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Item Total",
                                  style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500),
                                ),
                                Text("",
                                  // "₹${calculateTotalCartValue().toStringAsFixed(2)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                ),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),

                          /// Coupon discount
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "item Discount",
                                    style: TextStyle(fontSize: 14.0, color: Colors.black.withOpacity(0.5), fontWeight: FontWeight.w500, decoration: TextDecoration.underline)
                                ),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 6,
                          ),

                          /// Delivery fees - price
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Fee | "
                                      // "${calculateDistance().toStringAsFixed(1)} "
                                      "kms",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Text(
                                  "₹ ",
                                      // "${calculateDeliveryCharge().toStringAsFixed(2)}"
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              color: TColors.grey,
                            ),
                          ),

                          /// Delivery tips
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Tip",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),

                                InkWell(
                                  onTap: () {},
                                  child: Text(
                                    "Add tip",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          /// Packaging charge - price
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Packaging charge",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Text(
                                  "₹",
                                      // "${packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                                      // .fold(0.0, (sum, element) => sum + element) }", // Sum all elements}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                ),

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),

                          /// GST charge
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "GST & Restaurant Charges",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall,
                                ),
                                Text(
                                  "₹",
                                      // "${(calculateTotalCartValue() * 0.05).toStringAsFixed(2)}", // Sum all elements}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge,
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),
                      // ListTile(
                      //   dense: true,
                      //   //contentPadding: EdgeInsets.zero,
                      //   title: Text(
                      //     "Item Total",
                      //     style: Theme.of(context).textTheme.bodySmall,
                      //   ),
                      //   trailing: Text(
                      //     "₹288",
                      //     style:
                      //     Theme.of(context).textTheme.labelMedium,
                      //   ),
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   //contentPadding: EdgeInsets.zero,
                      //   title: Text(
                      //     "Delivery Fee | 6.0 kms",
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //   ),
                      //   trailing: Text(
                      //     "₹33.00",
                      //     style:
                      //     Theme.of(context).textTheme.labelMedium,
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: Divider(
                      //     color: TColors.grey,
                      //   ),
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   //contentPadding: EdgeInsets.zero,
                      //   title: Text(
                      //     "Platform Fee",
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //   ),
                      //   trailing: Text(
                      //     "₹8.00",
                      //     style:
                      //     Theme.of(context).textTheme.labelMedium,
                      //   ),
                      // ),
                      // ListTile(
                      //   dense: true,
                      //   //contentPadding: EdgeInsets.zero,
                      //   title: Text(
                      //     "GST & Restaurant Charges",
                      //     style: Theme.of(context).textTheme.bodyMedium,
                      //   ),
                      //   trailing: Text(
                      //     "₹15.84",
                      //     style:
                      //     Theme.of(context).textTheme.labelMedium,
                      //   ),
                      // ),

                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Divider(
                          color: TColors.grey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "To Pay",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge,
                            ),
                            Text(
                              "₹",
                                  // "${(double.parse(calculateTotalCartValue().toStringAsFixed(2)) + calculateDeliveryCharge() + packagingCharge.map((e) => double.tryParse(e) ?? 0.0) // Convert each item to double
                                  // .fold(0.0, (sum, element) => sum + element) + calculateTotalCartValue() * 0.05).toStringAsFixed(2)}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge,
                            ),

                          ],
                        ),
                      ),
                      SizedBox(height: 20,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class cartPageItemDisplay extends StatelessWidget {

  final int quantity;
  final int counter;
  final String itemName;
  final String varientOrDescription;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final String price;

  const cartPageItemDisplay({
    super.key,
    required this.quantity,
    required this.counter,
    required this.itemName,
    required this.varientOrDescription,
    required this.onDecrement,
    required this.onIncrement,
    required this.price,
  });


  @override
  Widget build(BuildContext context) {
    return counter != 0 ? Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        height: 70,
        width: double.infinity,
        child: Row(
          // mainAxisAlignment:
          // MainAxisAlignment.spaceBetween,
          children: [
            /// Item name and description
            Expanded(
              flex: 55,
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    itemName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,  overflow: TextOverflow.ellipsis,
                    ), maxLines: 1,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    varientOrDescription,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),

            SizedBox(
              width: 10,
            ),
            /// Add or remove item
            Expanded(
              flex: 28,
              child: Container(
                height: 35,
                width: 80,
                padding: EdgeInsets.symmetric(
                    horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(8),
                  border:
                  Border.all(color: Colors.grey),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    // remove button
                    InkWell(
                      onTap: onDecrement,
                      child: Container(
                        height: 35,
                        width: 25,
                        padding:
                        EdgeInsets.only(right: 4),
                        child: Icon(Icons.remove,
                            size: 16,
                            color: TColors.darkerGrey),
                      ),
                    ),
                    // counter
                    Text(
                      "$counter",
                      style: TextStyle(
                          color: TColors.darkerGrey,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                    // add button
                    InkWell(
                      onTap: onIncrement,
                      child: Container(
                        height: 35,
                        width: 25,
                        padding:
                        EdgeInsets.only(left: 4),
                        child: Icon(Icons.add,
                            size: 16,
                            color: TColors.darkerGrey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),


            /// Item price
            Expanded(
              flex: 20,
              child: Text(
                "₹${(double.parse(price) * counter).toStringAsFixed(1)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge,
              ),
            ),
          ],
        )) : SizedBox.shrink() ;
  }
}
