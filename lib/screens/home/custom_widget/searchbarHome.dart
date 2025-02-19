import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class SearchBarHome extends StatefulWidget {
  const SearchBarHome({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  State<SearchBarHome> createState() => SearchBarHomeState();
}

class SearchBarHomeState extends State<SearchBarHome> {
  List<String> searchSuggestion = [
    'search for "pizza"',
    'search for "burger"',
    'search for "sushi"',
    'search for "ice-cream"',
    'search for "milk"'
  ];
  int currentIndex = 0;
  Timer? _timer;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _startSuggestionLoop();
    widget.searchController.addListener(() {
      setState(() {
        isTyping = widget.searchController.text.isNotEmpty;
      });
    });
  }

  void _startSuggestionLoop() {
    _timer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
      if (!isTyping) {
        setState(() {
          currentIndex = (currentIndex + 1) % searchSuggestion.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          // border: Border.all(color: TColors.grey),
          borderRadius: BorderRadius.circular(10),
          color: TColors.white,
        ),
        child: Row(children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: widget.searchController,
              decoration: InputDecoration(
                  hintText: isTyping ? "" : searchSuggestion[currentIndex],
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none
              ),

              style: TextStyle(fontSize: 13),
            ),
          ),
          if (widget.searchController.text.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear, size: 20, color: TColors.darkGrey,),
              onPressed: () {
                widget.searchController.clear();
                setState(() {
                  isTyping = false;
                });
              },
            ),
        ]));
  }
}