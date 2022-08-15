import 'package:flutter/material.dart';

class Helper {
  static String getAssetName(String fileName) {
    return "assets/$fileName";
  }

  static TextTheme getTheme(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}
