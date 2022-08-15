import 'package:flutter/material.dart';
import '../helper/constants.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    Constants.height = _mediaQueryData.size.height;
    Constants.width = _mediaQueryData.size.width;
    Constants.orientation = _mediaQueryData.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = Constants.height;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = Constants.width;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth;
}
