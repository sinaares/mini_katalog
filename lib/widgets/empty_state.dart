import 'package:flutter/material.dart';
import '../app/ui.dart';

// This widget is used when there is no data to show.
// For example: empty cart or no favorites.
class EmptyState extends StatelessWidget {
  // Main title text
  final String title;

  // Small description text
  final String subtitle;

  // Icon that represents the situation
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Getting current color scheme from theme
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        // Using common padding from AppUI
        padding: AppUI.padding,

        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min, // take minimum space
              children: [
                // Circle icon at the top
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primaryContainer,

                  child: Icon(icon, color: cs.onPrimaryContainer, size: 28),
                ),

                const SizedBox(height: 14),

                // Title text
                Text(title, style: Theme.of(context).textTheme.titleLarge),

                const SizedBox(height: 8),

                // Subtitle text
                Text(subtitle, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
