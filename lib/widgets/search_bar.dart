import 'package:flutter/material.dart';

// This widget is a simple search input field.
// It is used to search products by name or description.
class SearchBarBox extends StatelessWidget {
  // Current search text
  final String value;

  // Function that runs when user types something
  final ValueChanged<String> onChanged;

  const SearchBarBox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      // Input decoration (UI design)
      decoration: const InputDecoration(
        hintText: 'Ara (ürün adı / açıklama)', // placeholder text
        border: OutlineInputBorder(), // border style
        prefixIcon: Icon(Icons.search), // search icon on the left
      ),

      // When text changes, send new value
      onChanged: onChanged,
    );
  }
}
