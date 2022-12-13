import 'package:flutter/material.dart';

Color cBackgroundColor = const Color.fromRGBO(233, 244, 255, 1);
Color cBlueBackground = const Color.fromRGBO(76, 81, 198, 1);

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
