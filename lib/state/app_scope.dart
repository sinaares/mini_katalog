import 'package:flutter/material.dart';
import 'app_state.dart';

// This class is used to provide AppState to the whole app.
// It works with InheritedNotifier so widgets can listen to changes.
class AppScope extends InheritedNotifier<AppState> {
  // notifier = our AppState
  // child = the widget tree that will access the state
  const AppScope({super.key, required AppState notifier, required Widget child})
    : super(notifier: notifier, child: child);

  // This method lets us access AppState anywhere in the app.
  static AppState of(BuildContext context) {
    // We try to find AppScope in the widget tree
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();

    // If it is null, it means AppScope was not wrapped properly
    assert(scope != null, 'AppScope bulunamadı. AppScope ile sarmala.');

    // Return the AppState object
    return scope!.notifier!;
  }
}
