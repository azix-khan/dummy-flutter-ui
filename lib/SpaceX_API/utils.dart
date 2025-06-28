import 'package:flutter/material.dart';

class MyColorsSample {
  static const Color primary = Color(0xFF12376F);
  static const Color primaryDark = Color(0xFF0C44A3);
  static const Color primaryLight = Color(0xFF43A3F3);
  static const Color green = Colors.green;
  static Color black = const Color(0xFF000000);
  static const Color accent = Color(0xFFFF4081);
  static const Color accentDark = Color(0xFFF50057);
  static const Color accentLight = Color(0xFFFF80AB);
  static const Color grey_3 = Color(0xFFf7f7f7);
  static const Color grey_5 = Color(0xFFf2f2f2);
  static const Color grey_10 = Color(0xFFe6e6e6);
  static const Color grey_20 = Color(0xFFcccccc);
  static const Color grey_40 = Color(0xFF999999);
  static const Color grey_60 = Color(0xFF666666);
  static const Color grey_80 = Color(0xFF37474F);
  static const Color grey_90 = Color(0xFF263238);
  static const Color grey_95 = Color(0xFF1a1a1a);
  static const Color grey_100_ = Color(0xFF0d0d0d);
  static const Color transparent = Color(0x00f7f7f7);
}

class MyTextSample {
  static TextStyle? display4(BuildContext context) =>
      Theme.of(context).textTheme.displayLarge;
  static TextStyle? display3(BuildContext context) =>
      Theme.of(context).textTheme.displayMedium;
  static TextStyle? display2(BuildContext context) =>
      Theme.of(context).textTheme.displaySmall;
  static TextStyle? display1(BuildContext context) =>
      Theme.of(context).textTheme.headlineMedium;
  static TextStyle? headline(BuildContext context) =>
      Theme.of(context).textTheme.headlineSmall;
  static TextStyle? title(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge;
  static TextStyle medium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium!;
}
