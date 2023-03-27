import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';

class PlayGameCard extends StatefulWidget {
  String imagePath;
  Color firstColor;
  Color secondColor;
  String text;
  String iconPath;
  VoidCallback func;

  PlayGameCard({
    Key? key,
    required this.imagePath,
    required this.firstColor,
    required this.secondColor,
    required this.text,
    required this.iconPath,
    required this.func,
  }) : super(key: key);

  @override
  State<PlayGameCard> createState() => _PlayGameCardState();
}

class _PlayGameCardState extends State<PlayGameCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.func();
      },
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              child:
                  // SvgPicture.asset(
                  //   widget.imagePath,
                  //   fit: BoxFit.fitWidth,
                  // ),
                  Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    widget.firstColor,
                    widget.secondColor,
                  ],
                )),
              )),
          Center(
            child: FittedBox(
              child: Container(
                child: Text(
                  widget.text,
                  style: GoogleFonts.fredoka(
                    color: cBackgroundColor,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil.textScaleFactor * 18,
                  ),
                  maxLines: 1,
                ),
              ),
              fit: BoxFit.scaleDown,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: ScreenUtil.width * 0.025,
                bottom: ScreenUtil.height * 0.003),
            child: Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(widget.iconPath),
            ),
          )
        ],
      ),
    );
  }
}
