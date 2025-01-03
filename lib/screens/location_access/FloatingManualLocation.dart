import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/custom_widget/textfield_cust.dart';
import 'package:zesty/screens/add_manually_address/confirmLocation.dart';
import 'package:zesty/screens/location_access/shimmerEffect.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/media_query.dart';
import '../../utils/constants/text_string.dart';

// required here map api key and http dependency

class ManualLocation extends StatefulWidget {
  const ManualLocation({super.key});

  @override
  State<ManualLocation> createState() => _ManualLocationState();
}

class _ManualLocationState extends State<ManualLocation> {
  final TextEditingController _controller = TextEditingController();
  List<String> _suggestions = [];
  List<String> placeLocation = [];
  final String apiKey =
      '2SbwJ2FVBuS_QShPV008-M-njDmBzvXQ2nXEbxDFsjI'; // Replace with your API key
  bool isLoading = false;

  Future<List<Map<String, String>>> getPlaceSuggestions(
      String query, String apiKey) async {
    final url = Uri.parse(
        'https://autocomplete.search.hereapi.com/v1/autocomplete?q=$query&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> suggestions = json.decode(response.body)['items'];

      // Filter suggestions to include only those from India
      final filteredSuggestions = suggestions.where((item) {
        final countryName = item['address']?['countryName'] as String?;
        return countryName != null && countryName == 'India';
      }).map((item) {
        return {
          'label': item['address']?['label']?.toString() ?? 'Unknown',
          // Convert to String
          'district': item['address']?['district']?.toString() ?? 'Surat',
          // Convert to String
        };
      }).toList();
      return filteredSuggestions;
    } else {
      throw Exception('Failed to load place suggestions');
    }
  }

  void _getSuggestions(String query) async {
    setState(() {
      isLoading = true; // start loading
    });
    if (query.isNotEmpty) {
      try {
        final suggestions = await getPlaceSuggestions(query, apiKey);
        await Future.delayed(const Duration(seconds: 1));
        setState(() {
          _suggestions = suggestions.map((item) => item['label']!).toList();
          placeLocation = suggestions.map((item) => item['district']!).toList();
          isLoading = false; // stop loading
        });
      } catch (e) {
        print('Error fetching suggestions: $e');
      }
    } else {
      // If query is empty, stop shimmer and reset suggestions
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _suggestions = [];
        placeLocation = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Place Search')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  size: 25,
                )),
            SizedBox(
              height: 14,
            ),
            Text(
              ZText.searchLocation,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(
              height: 10,
            ),
            ZCustomTextField(
                controller: _controller,
                hintText: "Try citylight, surat, etc.",
                onChanged: (value) => _getSuggestions(value),
                prefixIcon: Icons.search_rounded),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmLocation()));
              },
              child: Container(
                height: 65,
                width: ZMediaQuery(context).width,
                child: Row(
                  children: [
                    Icon(Icons.my_location_rounded),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      ZText.useCurrentLocation,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )
                  ],
                ),
              ),
            ),
            Divider(
              color: ZMediaQuery(context).isDarkMode
                  ? TColors.darkerGrey
                  : TColors.grey,
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
            Expanded(
              child: isLoading
                  ? ShimmerEffects(itemCount: _suggestions.length)
                  : ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.location_on_rounded),
                          subtitle: Text(
                            _suggestions[index],
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          title: Text(
                            placeLocation[index],
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('Selected: ${_suggestions[index]}')));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
