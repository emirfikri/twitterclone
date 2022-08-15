import 'package:flutter/material.dart';

class AppColor {
  static const red = Color(0xFFb6270f);
  static const lightred = Color(0xffd95e55);
  static const primary = Color(0xFF4A4B4D);
  static const secondary = Color(0xFF7C7D7E);
  static const placeholder = Color(0xFFB6B7B7);
  static const placeholderBg = Color(0xFFF2F2F2);

  static Color firsttheme = const Color.fromARGB(255, 2, 62, 145);
  static Color secondtheme = const Color(0xff01578c);
  static Color thirdtheme = const Color(0xffe33f66);

  static LinearGradient themegradient = const LinearGradient(
    colors: <Color>[
      Color(0xff01578c),
      Color.fromARGB(255, 1, 61, 98),
      Color(0xff01578c),
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
