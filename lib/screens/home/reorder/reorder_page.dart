import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zesty/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/utils/local_storage/HiveOpenBox.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReorderPage extends StatefulWidget {
  const ReorderPage({super.key});

  @override
  State<ReorderPage> createState() => _ReorderPageState();
}

class _ReorderPageState extends State<ReorderPage> {
  List pastOrder = [];
  List filteredOrders = []; // List to store filtered orders
  bool isLoading = true; // Controls loader visibility
  Map<String, String> itemNames = {}; // Store fetched item names
  String selectedFilter = "All"; // Track the selected filter

  var box = Hive.box(HiveOpenBox.storeAddress);

  Future<void> fetchPastOrder(userId) async {
    final url = Uri.parse(
        'https://zesty-backend.onrender.com/order/get-all-orders-for-user/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        pastOrder = jsonDecode(response.body);
        filteredOrders = List.from(pastOrder); // Initialize filteredOrders with all orders
        await fetchAllItemNames(); // Fetch item names before updating UI
      } else {
        print("Error: ${response.statusCode}");
        showErrorMessage("Failed to fetch orders.");
      }
    } catch (e) {
      print("Exception: $e");
      showErrorMessage("Something went wrong.");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showErrorMessage(String message) {
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> fetchAllItemNames() async {
    Set<String> itemIds = {}; // To avoid duplicate API calls

    for (var order in pastOrder) {
      for (var item in order['order']) {
        itemIds.add(item['itemId']);
      }
    }

    // Fetch item names in parallel
    List<Future<void>> futures = itemIds.map((itemId) async {
      itemNames[itemId] = await fetchItemName(itemId);
    }).toList();

    await Future.wait(futures); // Wait for all item names to load
  }

  Future<String> fetchItemName(String itemId) async {
    if (itemNames.containsKey(itemId)) return itemNames[itemId]!; // Return if cached

    final url = Uri.parse('https://zesty-backend.onrender.com/menu/get/$itemId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['name'] ?? "Unknown Item"; // Return item name
      }
    } catch (e) {
      print("Error fetching item: $e");
    }
    return "Unknown Item"; // Default if API fails
  }

  void applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
      switch (filter) {
        case "Price < 149":
          filteredOrders = pastOrder.where((order) {
            double totalAmount = double.tryParse(order['totalAmountUser'].toString()) ?? 0.0;
            return totalAmount <= 149;
          }).toList();
          break;
        case "Price 149 - 300":
          filteredOrders = pastOrder.where((order) {
            double totalAmount = double.tryParse(order['totalAmountUser'].toString()) ?? 0.0;
            return totalAmount >= 149 && totalAmount <= 300;
          }).toList();
          break;
        case "Price > 300":
          filteredOrders = pastOrder.where((order) {
            double totalAmount = double.tryParse(order['totalAmountUser'].toString()) ?? 0.0;
            return totalAmount > 300;
          }).toList();
          break;
        case "Today's Orders":
          filteredOrders = pastOrder.where((order) {
            DateTime apiDate = DateTime.parse(order['updatedAt']);
            DateTime orderDate = apiDate.add(Duration(hours: 5, minutes: 30));
            DateTime now = DateTime.now();
            return orderDate.year == now.year &&
                orderDate.month == now.month &&
                orderDate.day == now.day;
          }).toList();
          break;
        case "Last Week Orders":
          filteredOrders = pastOrder.where((order) {
            DateTime apiDate = DateTime.parse(order['updatedAt']);
            DateTime orderDate = apiDate.add(Duration(hours: 5, minutes: 30));
            DateTime now = DateTime.now();
            DateTime lastWeek = now.subtract(Duration(days: 7));
            return orderDate.isAfter(lastWeek) && orderDate.isBefore(now);
          }).toList();
          break;
        default:
          filteredOrders = List.from(pastOrder); // Show all orders
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPastOrder(box.get(HiveOpenBox.userId));
  }

  Future<void> _onRefresh() async {
    // Show loader while refreshing
    setState(() {
      isLoading = true;
    });
    await fetchPastOrder(box.get(HiveOpenBox.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: Colors.black,
        ),
      )
          : pastOrder.isEmpty
          ? Center(
          child: Text(
            "No past orders found.",
            style: TextStyle(fontSize: 16),
          ))
          : RefreshIndicator(
        color: Colors.black,
        backgroundColor: Colors.white,
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            /// First SliverAppBar: Order History (Floating)
            SliverAppBar(
              snap: true,
              centerTitle: true,
              floating: true,
              backgroundColor: TColors.grey,
              toolbarHeight: 40,
              title: Text("ORDER HISTORY",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold)),
            ),

            /// Second SliverAppBar: Filter Options (Pinned)
            SliverAppBar(
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChip(
                      label: Text("All"),
                      selected: selectedFilter == "All",
                      onSelected: (_) => applyFilter("All"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Price < 149"),
                      selected: selectedFilter == "Price < 149",
                      onSelected: (_) => applyFilter("Price < 149"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Price 149 - 300"),
                      selected: selectedFilter == "Price 149 - 300",
                      onSelected: (_) => applyFilter("Price 149 - 300"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Price > 300"),
                      selected: selectedFilter == "Price > 300",
                      onSelected: (_) => applyFilter("Price > 300"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Today's Orders"),
                      selected: selectedFilter == "Today's Orders",
                      onSelected: (_) => applyFilter("Today's Orders"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                    SizedBox(width: 8),
                    FilterChip(
                      label: Text("Last Week Orders"),
                      selected: selectedFilter == "Last Week Orders",
                      onSelected: (_) =>
                          applyFilter("Last Week Orders"),
                      selectedColor: Colors.grey[400],
                      backgroundColor: TColors.bgLight,
                    ),
                  ],
                ),
              ),
              pinned: true,
              backgroundColor: TColors.grey,
            ),

            /// SliverList: Order List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  int reversedIndex = filteredOrders.length - 1 - index;
                  DateTime apiDate = DateTime.parse(
                      filteredOrders[reversedIndex]['updatedAt']);
                  DateTime orderDate = apiDate.add(Duration(
                      hours: 5, minutes: 30)); // convert API date to IST
                  String formattedDate = DateFormat(
                      'dd MMM yyyy, hh:mm a')
                      .format(orderDate);

                  return Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Restaurant name and order status
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    filteredOrders[reversedIndex]
                                    ['restaurantName'],
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Total spent: ₹${filteredOrders[reversedIndex]['totalAmountUser']}",
                                    style: TextStyle(
                                        color: TColors.darkerGrey,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Ordered on: $formattedDate",
                                    style: TextStyle(
                                        color: TColors.darkerGrey,
                                        fontSize: 12),
                                  ),
                                  SizedBox(height: 5),
                                  if ((filteredOrders[reversedIndex]
                                  ['coupon']
                                      ?.isNotEmpty ??
                                      false))
                                    Row(
                                      children: [
                                        Icon(Icons.local_offer,
                                            size: 16,
                                            color: Colors.red),
                                        SizedBox(width: 5),
                                        Text(
                                          "Applied '${filteredOrders[reversedIndex]['coupon']}' coupon!",
                                          style: TextStyle(
                                              color:
                                              TColors.darkerGrey,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              filteredOrders[reversedIndex]
                              ['orderStatus'] ==
                                  "Delivered"
                                  ? Text(
                                filteredOrders[reversedIndex]
                                ['orderStatus'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: TColors.darkGreen),
                              )
                                  : Text(
                                filteredOrders[reversedIndex]
                                ['orderStatus'],
                                style: TextStyle(
                                    fontSize: 12,
                                    color: TColors.error),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15),
                            child: Divider(color: TColors.grey),
                          ),

                          /// Order Items
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: filteredOrders[reversedIndex]
                            ['order']
                                .map<Widget>((item) {
                              return Text(
                                "${item["quantity"]}x ${itemNames[item["itemId"]] ?? "Loading..."}",
                                style: TextStyle(
                                    color: TColors.darkerGrey,
                                    fontSize: 12),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: filteredOrders.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
