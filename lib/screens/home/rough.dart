import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MartItemImagesScreen extends StatefulWidget {
  final String martItemId;

  const MartItemImagesScreen({super.key, required this.martItemId});

  @override
  _MartItemImagesScreenState createState() => _MartItemImagesScreenState();
}

class _MartItemImagesScreenState extends State<MartItemImagesScreen> {
  List<String> imageUrls = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchMartImages();
  }

  Future<void> fetchMartImages() async {
    try {
      final response = await http.get(
        Uri.parse('https://zesty-backend.onrender.com/zestyMart/get-martItem-images/${widget.martItemId}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> imagesData = jsonDecode(response.body);
        List<String> images = imagesData.map((img) => img['data'] as String).toList();

        setState(() {
          imageUrls = images;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load images";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "Error: ${e.toString()}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mart Item Images")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : imageUrls.isEmpty
          ? const Center(child: Text("No images available"))
          : GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display 2 images per row
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.memory(
              base64Decode(imageUrls[index].split(",")[1]), // Decode Base64
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}