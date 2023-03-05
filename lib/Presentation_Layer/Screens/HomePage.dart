import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/HomePageDrawer.dart';
import 'package:engame2/Presentation_Layer/Widgets/HomePageWordSelectButton.dart';
import 'package:engame2/Presentation_Layer/Widgets/MainPageGameCard.dart';
import 'package:engame2/Presentation_Layer/Widgets/MyWordsWidget.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refleshData();
    BlocProvider.of<HomePageSelectedWordCubit>(context)
        .ChangeState(WordSelectedStateEnums.learnedWordState);
  }

  Future<void> refleshData() async {
    await Future.delayed(const Duration(seconds: 2));
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
      key: _scaffoldKey,
      drawer: HomePageDrawer(
        callback: () => _scaffoldKey.currentState!.closeDrawer(),
      ),
      backgroundColor: cBackgroundColor,
      resizeToAvoidBottomInset: false,
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
                          callback: () =>
                              _scaffoldKey.currentState!.openDrawer(),
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
                          text: "Test Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(context, '/playEngameMode');
                          },
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/secondplayphoto.svg",
                          text: "Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(context, '/playWordGameMode');
                          },
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
                            Navigator.of(context).pushNamed('/myWordsPage');
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
                          callback: () => scrollController.animateTo(
                            0,
                            duration: const Duration(
                                milliseconds: 400), //duration of scroll
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                        WordCardSelectButton(
                          type: WordSelectedStateEnums.notLearnedWordState,
                          baslik: "Bilmediğim Kelimeler",
                          callback: () => scrollController.animateTo(
                            0,
                            duration: const Duration(
                                milliseconds: 400), //duration of scroll
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.height * 0.025),
                    // CustomPaint(
                    //   painter: DrawDottedhorizontalline(),
                    // ),
                    MyWordsWidget(
                      scrollController: scrollController,
                      audioPlayer: _audioPlayer,
                    )
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
