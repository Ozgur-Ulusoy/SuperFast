import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FirstOpenPage extends StatefulWidget {
  const FirstOpenPage({Key? key}) : super(key: key);

  @override
  State<FirstOpenPage> createState() => _FirstOpenPageState();
}

class _FirstOpenPageState extends State<FirstOpenPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: ScreenUtil.height,
            width: ScreenUtil.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/splash-2 (1).png"),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  top: ScreenUtil.height * 0.02,
                  right: ScreenUtil.height * 0.02),
              child: Align(
                alignment: Alignment.topRight,
                child: LogoWidget(w: ScreenUtil.height * 0.065),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: const Alignment(0.6, 0.825),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                height: ScreenUtil.height * 0.125,
                width: ScreenUtil.height * 0.125,
                child: Padding(
                  padding: const EdgeInsets.all(3.5),
                  child: GestureDetector(
                    onTap: () {
                      //! Login Page Nagivate
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(76, 81, 198, 1),
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FittedBox(
                          child: Icon(
                            MdiIcons.arrowRight,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
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
                // Container(
                //   decoration: const BoxDecoration(
                //     color: Colors.white,
                //     borderRadius: BorderRadius.all(Radius.circular(100)),
                //   ),
                //   height: 100,
                //   width: 100,
                // ),
                // const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
