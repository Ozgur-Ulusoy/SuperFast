import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';

class ProgressingContainer extends StatefulWidget {
  int dividingCount;
  int totalCount;

  Color color;
  ProgressingContainer(
      {Key? key,
      required this.dividingCount,
      required this.totalCount,
      required this.color})
      : super(key: key);

  @override
  State<ProgressingContainer> createState() => _ProgressingContainerState();
}

class _ProgressingContainerState extends State<ProgressingContainer> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SizedBox(
        width: ScreenUtil.width * 0.85,
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: widget.dividingCount,
                  child: Container(
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: widget.color,
                    ),
                    height: ScreenUtil.height * 0.05,
                  ),
                ),
                Expanded(
                  flex: widget.totalCount - widget.dividingCount,
                  child: Container(
                    decoration: const BoxDecoration(
                      // borderRadius: BorderRadius.circular(10),
                      color: Colors.grey,
                    ),
                    height: ScreenUtil.height * 0.05,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: ScreenUtil.height * 0.05,
              child: Center(
                child: Text(
                  "% " +
                      (((widget.dividingCount) / widget.totalCount) * 100)
                          .toStringAsFixed(2),
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: ScreenUtil.textScaleFactor * 20,
                  ),
                  textAlign: TextAlign.center,
                  // textHeightBehavior: TextAlignVertical.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
