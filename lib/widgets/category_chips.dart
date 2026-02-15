import 'package:flutter/material.dart';

// This widget shows category buttons as chips.
// User can select one category at a time.
class CategoryChips extends StatelessWidget {
  // List of all category names
  final List<String> categories;

  // Currently selected category
  final String selected;

  // Function that runs when a category is selected
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Wrap is used so chips go to next line if needed
    return Wrap(
      spacing: 8, // horizontal space between chips
      runSpacing: 8, // vertical space between rows
      // Create a chip for each category
      children: categories.map((c) {
        // Check if this chip is selected
        final isSel = c == selected;

        return ChoiceChip(
          label: Text(c),

          // If selected, chip appears active
          selected: isSel,

          // Change text style when selected
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSel
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),

          // Background color when selected
          selectedColor: Theme.of(context).colorScheme.primaryContainer,

          // Border style
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),

          // When user taps chip, send selected category
          onSelected: (_) => onSelected(c),
        );
      }).toList(),
    );
  }
}
