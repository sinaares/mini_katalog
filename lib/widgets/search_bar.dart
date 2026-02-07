import 'package:flutter/material.dart';

class SearchBarBox extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const SearchBarBox({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        hintText: 'Ara (ürün adı / açıklama)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
