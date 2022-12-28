import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/HomePageWordSelectButton.dart';
import 'package:engame2/Presentation_Layer/Widgets/MainPageGameCard.dart';
import 'package:engame2/Presentation_Layer/Widgets/TabButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/data.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refleshData();
  }

  Future<void> refleshData() async {
    await Future.delayed(const Duration(seconds: 2));
    // BlocProvider.of<HomePageSelectedWordCubit>(context).
    setState(() {
      print("refleshed");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: Stack(
        children: [
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
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil.width * 0.035,
                  top: ScreenUtil.height * 0.035,
                  right: ScreenUtil.width * 0.035,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TabButtonWidget(
                          height: ScreenUtil.height * 0.04,
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
                    Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                                text: "Hello ,\n",
                                style: GoogleFonts.fredoka(
                                  color: cBlueBackground,
                                  fontSize: ScreenUtil.textScaleFactor * 35,
                                  fontWeight: FontWeight.w500,
                                ),
                                children: [
                                  TextSpan(
                                    text: MainData.username ??
                                        FirebaseAuth
                                            .instance.currentUser!.displayName,
                                    style: GoogleFonts.fredoka(
                                      color: cBlueBackground,
                                      fontSize: ScreenUtil.textScaleFactor * 35,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  )
                                ]),
                            maxLines: 2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Oyunlar",
                          style: GoogleFonts.poppins(
                            color: cBlueBackground,
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Text(
                            "Tümünü Gör",
                            style: GoogleFonts.roboto(
                              color: cBlueBackground,
                              fontSize: ScreenUtil.textScaleFactor * 18,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(5),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                      children: [
                        PlayGameCard(
                          imagePath: "assets/images/firstplayphoto.svg",
                          text: "Sesli Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(context, '/playClassicMode');
                          },
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/secondplayphoto.svg",
                          text: "Sesli Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {},
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/thirdplayphoto.svg",
                          text: "Sesli Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {},
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/fourthplayphoto.svg",
                          text: "Sesli Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kelimelerim",
                          style: GoogleFonts.poppins(
                            color: cBlueBackground,
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO
                          },
                          child: Text(
                            "Tümünü Gör",
                            style: GoogleFonts.roboto(
                              color: cBlueBackground,
                              fontSize: ScreenUtil.textScaleFactor * 18,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    //

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WordCardSelectButton(
                          type: WordSelectedStateEnums.learnedWordState,
                          baslik: "Bildiğim Kelimeler",
                        ),
                        WordCardSelectButton(
                          type: WordSelectedStateEnums.notLearnedWordState,
                          baslik: "Bilmediğim Kelimeler",
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.height * 0.025),
                    // CustomPaint(
                    //   painter: DrawDottedhorizontalline(),
                    // ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(45),
                            topRight: Radius.circular(45),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            top: ScreenUtil.height * 0.045,
                            left: ScreenUtil.width * 0.02,
                            right: ScreenUtil.width * 0.02,
                          ),
                          child: ClipRRect(
                            child: BlocBuilder<HomePageSelectedWordCubit,
                                HomePageSelectedWordState>(
                              builder: (context, state) {
                                return ListView.separated(
                                  physics: const BouncingScrollPhysics(),
                                  // physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    //
                                    return SizedBox(
                                      height: 50,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const Spacer(),
                                          SizedBox(
                                            width: ScreenUtil.width * 0.18,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    state
                                                        .learnedWordsList[index]
                                                        .english,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: ScreenUtil.width * 0.05,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    state
                                                        .learnedWordsList[index]
                                                        .level
                                                        .name
                                                        .toUpperCase(),
                                                    // "dsaşdsaşdsdadsasd",
                                                    maxLines: 1,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: () async {
                                              //
                                              await _audioPlayer.play(UrlSource(
                                                  state.learnedWordsList[index]
                                                      .mediaLink));
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/playSoundVector.svg",
                                              // fit: BoxFit.contain,
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: ScreenUtil.width * 0.15,
                                            child: Row(
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    state
                                                        .learnedWordsList[index]
                                                        .turkish,
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return CustomPaint(
                                      painter: DrawDottedhorizontalline(),
                                    );
                                  },
                                  itemCount: state.learnedWordsList.length,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    //!
                    // const Expanded(flex: 8, child: Placeholder()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint = Paint();
  DrawDottedhorizontalline() {
    _paint = Paint();
    _paint.color = const Color.fromRGBO(76, 81, 198, 0.46); //dots color
    _paint.strokeWidth = 2; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -ScreenUtil.width; i < ScreenUtil.width; i = i + 15) {
      // 15 is space between dots
      // if (i % 3 == 0) {
      canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
