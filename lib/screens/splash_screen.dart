import 'dart:async';
import 'package:flutter/material.dart';
import '../app/routes.dart';

// This is the splash screen that appears when the app starts.
// It shows the app name for a short time and then navigates to home.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // I use a Timer to wait 1 second before going to the home screen.
    Timer(const Duration(seconds: 1), () {
      // mounted check makes sure the widget is still active
      if (mounted) {
        Navigator.pushReplacementNamed(context, Routes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple centered text for splash screen
    return const Scaffold(
      body: Center(
        child: Text(
          'Mini Katalog',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
