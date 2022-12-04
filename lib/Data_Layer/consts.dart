import 'package:flutter/material.dart';

Color cBackgroundColor = const Color.fromARGB(255, 230, 221, 221);

class ScreenUtil {
  static double height = 1920;
  static double width = 1080;
  static double textScaleFactor = 1.5;
  static double wordSpacing = 1.5;
  static double letterSpacing = 1;

  static void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // _mediaQueryData = mediaQuery;
    // _pixelRatio = mediaQuery.devicePixelRatio;
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    // _statusBarHeight = mediaQuery.padding.top;
    // bottomBarHeight = mediaQueryData.padding.bottom;
    textScaleFactor = mediaQuery.textScaleFactor;

    // print(height);
    // print(width);
  }
}
