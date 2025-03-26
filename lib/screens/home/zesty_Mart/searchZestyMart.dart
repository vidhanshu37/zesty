import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:zesty/screens/home/zesty_Mart/single_Product/singleProduct.dart';

import '../custom_widget/searchbarHome.dart';
import 'package:http/http.dart' as http;

class seachZestyMart extends StatefulWidget {
  const seachZestyMart({super.key});

  @override
  State<seachZestyMart> createState() => _seachZestyMartState();
}

class _seachZestyMartState extends State<seachZestyMart> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allItemDetail = [];
  List<Map<String, dynamic>> filteredItemDetail = [];

  Future<void> FetchItemData() async {
    final url = Uri.parse(
        "https://zesty-backend.onrender.com/zestyMart/get-all-martItem");

    try {
      final response = await http.get(url);
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        allItemDetail = List<Map<String, dynamic>>.from(data);
        // filteredItemDetail = allItemDetail;
      });
      allItemDetail.shuffle(Random());
    } catch (e) {
      print(e.toString());
    }
  }

  void filterSearchResult(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredItemDetail = List.from(allItemDetail);
        setState(() {

        });
      } else {
        setState(() {
          filteredItemDetail = allItemDetail.where(
            (item) {
              String itemName = item['name'].toString().toLowerCase();
              return itemName.contains(query.toLowerCase());
            },
          ).toList();
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FetchItemData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); //  Safely go back
          },
        ),
      ),
      body: allItemDetail.isEmpty ? Center(child: Lottie.asset('assets/lottie/zestyMart_loader.json', height: 200, width: 200),) : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: SearchBarHome(
              searchController: searchController,
              onChange: filterSearchResult,
            ),
          ),

          searchController.text.isEmpty ? Expanded(
              child:  ListView.builder(
                itemCount: allItemDetail.length,
                itemBuilder: (context, index) {
                  var item = allItemDetail[index];

                  // Extract first image from the list
                  List<dynamic> images = item["images"] ?? [];
                  String imageUrl = images.isNotEmpty ? images[0] : "";

                  return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported), // Placeholder for missing image
                      title: Text(item["name"] ?? "No Name"),
                      subtitle: Text("Price: ${item["price"]}"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Singleproduct(id: item["_id"].toString()),));
                      }
                  );
                },)
          ) : searchController.text.isNotEmpty && filteredItemDetail.isEmpty
              ? Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text('No result found for "${searchController.text}"', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600),),
          )
              : Expanded(
              child:  ListView.builder(
                itemCount: filteredItemDetail.length,
                itemBuilder: (context, index) {
                  var item = filteredItemDetail[index];

                  // Extract first image from the list
                  List<dynamic> images = item["images"] ?? [];
                  String imageUrl = images.isNotEmpty ? images[0] : "";

                  return ListTile(
                      leading: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover)
                          : Icon(Icons.image_not_supported), // Placeholder for missing image
                      title: Text(item["name"] ?? "No Name"),
                      subtitle: Text("Price: ${item["price"]}"),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Singleproduct(id: item["_id"].toString()),));
                      }
                  );
                },)
          )

        ],
      ),
    );
  }
}
