import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Ad_Helper.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/BannerAdWidget.dart';
import 'package:engame2/Presentation_Layer/Widgets/MyWordsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../Widgets/HomePageWordSelectButton.dart';

class MyWordsPage extends StatefulWidget {
  const MyWordsPage({Key? key}) : super(key: key);

  @override
  State<MyWordsPage> createState() => _MyWordsPageState();
}

class _MyWordsPageState extends State<MyWordsPage> {
  ScrollController scrollController = ScrollController();
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<HomePageSelectedWordCubit>(context)
        .ChangeState(WordSelectedStateEnums.learnedWordState);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _audioPlayer.dispose();
  }

  BannerAdWidget bannerAdWidget = BannerAdWidget(
    adId: AdHelper.wordsPageBannerAdUnitId,
  );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<HomePageSelectedWordCubit>(context)
            .ChangeState(WordSelectedStateEnums.learnedWordState);
        BlocProvider.of<HomePageSelectedWordCubit>(context)
            .ChangeIsSearch(false);
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: cBackgroundColor,
        body: SafeArea(
          child: Stack(
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
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                                BlocProvider.of<HomePageSelectedWordCubit>(
                                        context)
                                    .ChangeState(WordSelectedStateEnums
                                        .learnedWordState);
                                BlocProvider.of<HomePageSelectedWordCubit>(
                                        context)
                                    .ChangeIsSearch(false);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: ScreenUtil.letterSpacing * 40,
                                color: cBlueBackground,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: ScreenUtil.height * 0.1),
                        SizedBox(
                          width: ScreenUtil.width,
                          height: ScreenUtil.height * 0.07,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            // scrollDirection: Axis.horizontal,
                            children: [
                              SizedBox(width: ScreenUtil.width * 0.03),
                              WordCardSelectButton(
                                type: WordSelectedStateEnums.learnedWordState,
                                baslik: "Bildiğim Kelimeler",
                                callback: () => scrollController.animateTo(
                                  0,
                                  duration: const Duration(
                                      milliseconds: 400), //duration of scroll
                                  curve: Curves.fastOutSlowIn,
                                ),
                                isMyWordsPage: true,
                              ),
                              SizedBox(width: ScreenUtil.width * 0.03),
                              WordCardSelectButton(
                                type: WordSelectedStateEnums.favoriteWordState,
                                baslik: "Favori Kelimeler",
                                callback: () => scrollController.animateTo(
                                  0,
                                  duration: const Duration(
                                      milliseconds: 400), //duration of scroll
                                  curve: Curves.fastOutSlowIn,
                                ),
                                isMyWordsPage: true,
                              ),
                              SizedBox(width: ScreenUtil.width * 0.03),
                              WordCardSelectButton(
                                type:
                                    WordSelectedStateEnums.notLearnedWordState,
                                baslik: "Bilmediğim Kelimeler",
                                callback: () => scrollController.animateTo(
                                  0,
                                  duration: const Duration(
                                      milliseconds: 400), //duration of scroll
                                  curve: Curves.fastOutSlowIn,
                                ),
                                isMyWordsPage: true,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.height * 0.025),
                        Container(
                          width: ScreenUtil.width * 0.9,
                          height: ScreenUtil.height * 0.065,
                          color: cBackgroundColor,
                          child: Row(
                            children: [
                              const Spacer(),
                              Expanded(
                                flex: 22,
                                child: Container(
                                  height: ScreenUtil.height * 0.065,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: Center(
                                    child: TextField(
                                      onChanged: (value) {
                                        if (value.isEmpty) {
                                          //
                                          BlocProvider.of<
                                                      HomePageSelectedWordCubit>(
                                                  context)
                                              .ChangeIsSearch(false);
                                          // BlocProvider.of<
                                          //             HomePageSelectedWordCubit>(
                                          //         context)
                                          //     .ChangeSearchInput(value);
                                        } else {
                                          BlocProvider.of<
                                                      HomePageSelectedWordCubit>(
                                                  context)
                                              .ChangeIsSearch(true);
                                          BlocProvider.of<
                                                      HomePageSelectedWordCubit>(
                                                  context)
                                              .ChangeSearchInput(value);
                                        }
                                      },
                                      // textAlign: TextAlign.center
                                      textAlignVertical:
                                          TextAlignVertical.center,
                                      decoration: InputDecoration(
                                        suffixIcon: Padding(
                                          padding: EdgeInsets.all(
                                              ScreenUtil.textScaleFactor * 8),
                                          child: SvgPicture.asset(
                                            "assets/images/SearchIcon.svg",
                                          ),
                                        ),
                                        hintText: "Kelimelerde Ara",
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                        border: InputBorder.none,
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                        errorBorder: InputBorder.none,
                                        disabledBorder: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                flex: 4,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Container(
                                    height: ScreenUtil.height * 0.065,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(15)),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(
                                          ScreenUtil.textScaleFactor * 8),
                                      child: SvgPicture.asset(
                                          "assets/images/FilterIcon.svg"),
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ),
                        SizedBox(height: ScreenUtil.height * 0.025),
                        MyWordsWidget(
                          scrollController: scrollController,
                          audioPlayer: _audioPlayer,
                        ),
                        SizedBox(height: ScreenUtil.height * 0.03),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: bannerAdWidget,
                        ),
                        SizedBox(height: ScreenUtil.height * 0.025),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
