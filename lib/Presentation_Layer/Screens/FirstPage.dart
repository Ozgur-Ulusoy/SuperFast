import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FirstOpenPage extends StatefulWidget {
  const FirstOpenPage({Key? key}) : super(key: key);

  @override
  State<FirstOpenPage> createState() => _FirstOpenPageState();
}

class _FirstOpenPageState extends State<FirstOpenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: Stack(
        children: [
          Container(
            width: ScreenUtil.width,
            height: MediaQuery.of(context).padding.top,
            alignment: Alignment.topCenter,
            color: cBlueBackground,
          ),
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 14,
                  child: Container(
                    decoration: BoxDecoration(
                        color: cBlueBackground,
                        border: Border.all(
                          width: 0,
                          color: cBlueBackground,
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: ScreenUtil.height * 0.02,
                              right: ScreenUtil.width * 0.03),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: LogoWidget(w: ScreenUtil.height * 0.065),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        color: cBlueBackground,
                        border: Border.all(
                          width: 0,
                          color: cBlueBackground,
                        ),
                        // borderRadius: const BorderRadius.only(
                        //   bottomLeft: Radius.circular(1500),
                        // ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: ScreenUtil.width * 0.4,
                        alignment: Alignment.bottomLeft,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              "assets/images/Group 7.png",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // SafeArea(
          //   child: Padding(
          //     padding: EdgeInsets.only(
          //         top: ScreenUtil.height * 0.02,
          //         right: ScreenUtil.width * 0.03),
          //     child: Align(
          //       alignment: Alignment.topRight,
          //       child: LogoWidget(w: ScreenUtil.height * 0.065),
          //     ),
          //   ),
          // ),

          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //
                const Spacer(),
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: ScreenUtil.width * 0.04,
                        right: ScreenUtil.width * 0.015),
                    child: RichText(
                      text: TextSpan(
                        text: "SUPERFAST",
                        style: GoogleFonts.fredoka(
                          fontSize: ScreenUtil.textScaleFactor * 39,
                          fontWeight: FontWeight.w500,
                          letterSpacing: ScreenUtil.textScaleFactor * 4,
                        ),
                        children: [
                          TextSpan(
                            text:
                                "‘e HOŞGELDİN Eğlenerek öğrenmeye hazır mısın ?",
                            style: GoogleFonts.roboto(
                              fontSize: ScreenUtil.textScaleFactor * 31,
                              letterSpacing: ScreenUtil.textScaleFactor * 4,
                              fontWeight: FontWeight.w300,
                              height: ScreenUtil.textScaleFactor * 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),

          // SafeArea(
          //   child: Container(
          //     width: 150,
          //     decoration: const BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage(
          //           "assets/images/Group 7.png",
          //         ),
          //         fit: BoxFit.contain,
          //       ),
          //     ),
          //   ),
          // ),

          SafeArea(
            child: Align(
              alignment: const Alignment(0.5, 0.67),
              child: GoArrowButton(
                toDo: () {
                  Navigator.pushNamed(
                    context,
                    '/loginPage',
                  );
                },
              ),
            ),
          ),

          // SafeArea(
          //   child: Container(
          //     alignment: Alignment.bottomLeft,
          //     decoration: const BoxDecoration(
          //         image: DecorationImage(
          //             image: AssetImage("assets/images/Group 7.png"))),
          //   ),
          // ),
        ],
      ),
    );
  }
}
