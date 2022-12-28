import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabButtonWidget extends StatefulWidget {
  double height;
  TabButtonWidget({Key? key, required this.height}) : super(key: key);

  @override
  State<TabButtonWidget> createState() => _TabButtonWidgetState();
}

class _TabButtonWidgetState extends State<TabButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //
      },
      child: SizedBox(
        child: SvgPicture.asset(
          "assets/images/Vector.svg",
          height: widget.height,
        ),
      ),
    );
  }
}
