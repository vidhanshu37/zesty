import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class SearchBarHome extends StatefulWidget {
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChange;
  final TextEditingController searchController;

  // ✅ Optional search suggestions
  final List<String>? searchSuggestion;

  const SearchBarHome({
    super.key,
    required this.searchController,
    this.onTap,
    this.readOnly = false,
    this.onChange,
    this.searchSuggestion,
  });

  @override
  State<SearchBarHome> createState() => SearchBarHomeState();
}

class SearchBarHomeState extends State<SearchBarHome> {
  late List<String> searchSuggestion;
  int currentIndex = 0;
  Timer? _timer;
  bool isTyping = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    searchSuggestion = widget.searchSuggestion ?? [
      'search for "pizza"',
      'search for "burger"',
      'search for "sushi"',
      'search for "ice-cream"',
      'search for "milk"'
    ];

    _startSuggestionLoop();

    widget.searchController.addListener(() {
      setState(() {
        if (widget.searchController.text.isEmpty) {
          focusNode.unfocus();
        }
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
        borderRadius: BorderRadius.circular(10),
        color: TColors.white,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              focusNode: focusNode,
              cursorColor: Colors.black,
              readOnly: widget.readOnly,
              onTap: widget.onTap,
              onChanged: widget.onChange,
              controller: widget.searchController,
              decoration: InputDecoration(
                hintText: isTyping ? "" : searchSuggestion[currentIndex],
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: TextStyle(fontSize: 13),
            ),
          ),
          // Uncomment below to show a clear button
          // if (widget.searchController.text.isNotEmpty)
          //   IconButton(
          //     icon: Icon(Icons.clear, size: 20, color: TColors.darkGrey),
          //     onPressed: () {
          //       widget.searchController.clear();
          //       setState(() {
          //         isTyping = false;
          //       });
          //     },
          //   ),
        ],
      ),
    );
  }
}
