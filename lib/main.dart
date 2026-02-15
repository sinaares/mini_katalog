import 'package:flutter/material.dart';
import 'app/app.dart';
import 'state/app_state.dart';

// This is the starting point of the application.
void main() {
  // runApp starts the Flutter app.
  // We create AppState here and pass it to the main app widget.
  runApp(MiniKatalogApp(state: AppState()));
}
