import 'package:flutter/material.dart';

class AppUI {
  static const double radius = 18;

  static BorderRadius borderRadius([double r = radius]) =>
      BorderRadius.circular(r);

  static const EdgeInsets padding = EdgeInsets.all(16);
  static const EdgeInsets cardPadding = EdgeInsets.all(14);

  static const double gridGap = 12;
}
