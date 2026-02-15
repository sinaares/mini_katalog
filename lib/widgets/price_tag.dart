import 'package:flutter/material.dart';

// This widget is used to display product price nicely.
// It shows the price inside a rounded container.
class PriceTag extends StatelessWidget {
  // Price value to display
  final double price;

  const PriceTag({super.key, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Some space inside the container
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),

      // Rounded pill-style decoration
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),

        // Using theme color for consistency
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),

      // Price text with 2 decimal format
      child: Text('${price.toStringAsFixed(2)} ₺'),
    );
  }
}
