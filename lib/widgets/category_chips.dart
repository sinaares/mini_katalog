import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((c) {
        final isSel = c == selected;
        return ChoiceChip(
          label: Text(c),
          selected: isSel,
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            color: isSel
                ? Theme.of(context).colorScheme.onPrimaryContainer
                : null,
          ),
          selectedColor: Theme.of(context).colorScheme.primaryContainer,
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
          onSelected: (_) => onSelected(c),
        );
        ;
      }).toList(),
    );
  }
}
