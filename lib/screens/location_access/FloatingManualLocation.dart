import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zesty/custom_widget/textfield_cust.dart';

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
  final String apiKey =
      '2SbwJ2FVBuS_QShPV008-M-njDmBzvXQ2nXEbxDFsjI'; // Replace with your API key

  Future<List<String>> getPlaceSuggestions(String query, String apiKey) async {
    final url = Uri.parse(
        'https://autocomplete.search.hereapi.com/v1/autocomplete?q=$query&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List suggestions = json.decode(response.body)['items'];
      return suggestions.map((item) => item['title'] as String).toList();
    } else {
      throw Exception('Failed to load place suggestions');
    }
  }

  void _getSuggestions(String query) async {
    if (query.isNotEmpty) {
      try {
        final suggestions = await getPlaceSuggestions(query, apiKey);
        setState(() {
          _suggestions = suggestions;
        });
      } catch (e) {
        print('Error fetching suggestions: $e');
      }
    } else {
      setState(() {
        _suggestions = [];
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
              onTap: () {Navigator.pop(context);},
                child: Icon(Icons.arrow_back, size: 25,)
            ),
            SizedBox(height: 14,),
            Text(ZText.searchLocation, style: Theme.of(context).textTheme.headlineMedium,),
            SizedBox(height: 10,),
            ZCustomTextField(
                controller: _controller,

                hintText: "Try citylight, surat, etc.",
                onChanged: (value) => _getSuggestions(value),
                prefixIcon: Icons.search_rounded),
            SizedBox(height: 10,),
            Container(
              height: 65,
              width: ZMediaQuery(context).width,
              child: Row(
                children: [
                  Icon(Icons.location_searching_rounded),
                  SizedBox(width: 10,),
                  Text(ZText.useCurrentLocation, style: Theme.of(context).textTheme.bodyLarge,)
                ],
              ),
            ),
            Divider(
              color: ZMediaQuery(context).isDarkMode ? TColors.darkerGrey : TColors.grey,
              thickness: 1,
              indent: 5,
              endIndent: 5,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _suggestions[index],
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Selected: ${_suggestions[index]}')));
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


