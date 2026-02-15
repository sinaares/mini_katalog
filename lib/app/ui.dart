import 'package:flutter/material.dart';

// This class is used to store common UI values in one place.
// I created it to keep the design consistent across the whole app.
class AppUI {
  // Default border radius value used in cards and containers
  static const double radius = 18;

  // This method returns a circular BorderRadius.
  // If no value is given, it uses the default radius.
  static BorderRadius borderRadius([double r = radius]) =>
      BorderRadius.circular(r);

  // Default page padding
  static const EdgeInsets padding = EdgeInsets.all(16);

  // Padding used inside cards
  static const EdgeInsets cardPadding = EdgeInsets.all(14);

  // Spacing value used between grid items
  static const double gridGap = 12;
}
