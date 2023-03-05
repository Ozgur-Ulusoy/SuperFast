import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class PlayBackground extends StatelessWidget {
  const PlayBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      SafeArea(
        child: Align(
          alignment: Alignment.topRight,
          child: RotatedBox(
            quarterTurns: 2,
            child: SvgPicture.asset(
              "assets/images/Group 7.svg",
            ),
          ),
        ),
      ),
      Align(
        alignment: const Alignment(-1, -0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset("assets/images/Ellipse 12.png"),
          ],
        ),
      ),
      Align(
        alignment: const Alignment(0, 1.05),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset("assets/images/Ellipse 13.png"),
          ],
        ),
      ),
    ]);
  }
}
