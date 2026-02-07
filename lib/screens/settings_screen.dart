import 'package:flutter/material.dart';
import '../state/app_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ayarlar')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Karanlık Mod'),
            value: state.darkMode,
            onChanged: state.toggleDarkMode,
          ),
        ],
      ),
    );
  }
}
