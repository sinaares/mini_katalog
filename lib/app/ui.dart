import 'package:flutter/material.dart';

class AppUI {
  static const radius = 18.0;

  static const padding = EdgeInsets.all(16);
  static const cardPadding = EdgeInsets.all(14);

  static BorderRadius borderRadius([double r = radius]) =>
      BorderRadius.circular(r);

  static const gridGap = 12.0;
}
