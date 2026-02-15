import 'package:flutter/material.dart';
import '../state/app_scope.dart';

// This screen is used for application settings.
// Currently it only contains dark mode option.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing global state to control dark mode
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),

      body: ListView(
        children: [
          // Switch button to enable or disable dark mode
          SwitchListTile(
            title: const Text('Karanlık Mod'),

            // Current dark mode value
            value: state.darkMode,

            // When user toggles the switch,
            // it updates the state
            onChanged: state.toggleDarkMode,
          ),
        ],
      ),
    );
  }
}
