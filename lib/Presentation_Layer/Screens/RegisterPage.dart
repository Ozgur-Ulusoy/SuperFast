import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(233, 244, 255, 1),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: ScreenUtil.width * 0.25,
                        height: ScreenUtil.width * 0.25,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(76, 81, 198, 1),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil.width * 0.025,
                              top: ScreenUtil.height * 0.02),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: LogoWidget(w: ScreenUtil.width * 0.12),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: ScreenUtil.width * 0.3,
                            height: ScreenUtil.width * 0.3,
                            decoration: const BoxDecoration(
                              // color: Color.fromRGBO(233, 244, 255, 1),
                              color: Color.fromRGBO(76, 81, 198, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: ScreenUtil.width * 0.285,
                              height: ScreenUtil.width * 0.285,
                              decoration: const BoxDecoration(
                                // color: Color.fromRGBO(233, 244, 255, 1),
                                color: Color.fromRGBO(233, 244, 255, 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil.height * 0.02,
                                  left: ScreenUtil.width * 0.02,
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.fredoka(
                                      color:
                                          const Color.fromRGBO(76, 81, 198, 1),
                                      fontSize: ScreenUtil.textScaleFactor * 29,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     width: ScreenUtil.width,
          //     height: MediaQuery.of(context).padding.top,
          //     color: const Color.fromRGBO(233, 244, 255, 1),
          //   ),
          // ),
        ],
      ),
    );
  }
}
