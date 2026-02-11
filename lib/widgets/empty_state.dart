import 'package:flutter/material.dart';
import '../app/ui.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const EmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: AppUI.padding,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(icon, color: cs.onPrimaryContainer, size: 28),
                ),
                const SizedBox(height: 14),
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(subtitle, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
