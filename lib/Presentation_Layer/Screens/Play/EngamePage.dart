import 'dart:async';

import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayAddToWordCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';
import "package:flutter_svg/flutter_svg.dart";

import '../../Widgets/ChoiceCard.dart';

class EngamePage extends StatefulWidget with PopUpMixin {
  const EngamePage({Key? key}) : super(key: key);

  @override
  State<EngamePage> createState() => _EngamePageState();
}

class _EngamePageState extends State<EngamePage> {
  Timer? timer;

  void StartTimer() {
    BlocProvider.of<TimerCubit>(context).ResetTime();
    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<TimerCubit>(context).DecreaseTime();
      if (BlocProvider.of<TimerCubit>(context).state.getRemainTime <= 0) {
        timer.cancel();
        print("end");

        //! puan ekranı
      }
    });
  }

  stopTimer() {
    timer!.cancel();
  }

  @override
  initState() {
    super.initState();
    // BlocProvider.of<AnswerCubit>(context).ResetAnswer();
    BlocProvider.of<QuestionCubit>(context).ResetState();
    BlocProvider.of<QuestionCubit>(
            context) //! tipi kullanıcının seçtiği türden olacak
        .ChangeQuestion(type: QuestionType.english); //* ilk soruyu sordu
    StartTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: ScreenUtil.width * 0.035,
                      top: ScreenUtil.height * 0.035,
                      right: ScreenUtil.width * 0.035,
                    ),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: ScreenUtil.letterSpacing * 40,
                            color: cBlueBackground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.033),
                  Row(
                    children: [
                      SizedBox(width: ScreenUtil.width * 0.05),
                      Text(
                        "Kelimelerle İngilizce",
                        style: GoogleFonts.poppins(
                          fontSize: ScreenUtil.letterSpacing * 22,
                          fontWeight: FontWeight.bold,
                          color: cBlueBackground,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.height * 0.027),
                  BlocBuilder<TimerCubit, TimerState>(
                    builder: (context, state) {
                      int count = 35;
                      double spacerWidth = (ScreenUtil.width / 100);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SizedBox(
                              // padding: EdgeInsets.symmetric(
                              //     horizontal: ScreenUtil.width * 0.015),
                              height: ScreenUtil.height * 0.009,
                              width: ScreenUtil.width,
                              child: ListView.separated(
                                reverse: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                // physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  // print(ScreenUtil.width);
                                  // print(
                                  //     (ScreenUtil.width / 20).floorToDouble());
                                  return Container(
                                    width: (ScreenUtil.width / count) -
                                        spacerWidth,
                                    color: state.getRemainTime * count / 90 <=
                                            index
                                        ? Colors.red
                                        : Colors.blue,
                                  );
                                },
                                separatorBuilder: (context, indes) {
                                  return SizedBox(width: spacerWidth);
                                },
                                itemCount: count,
                              ),
                            ),
                          ),
                          SizedBox(width: spacerWidth / 2),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  Padding(
                    padding: EdgeInsets.only(
                        right: ScreenUtil.width * 0.025,
                        top: ScreenUtil.height * 0.015),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        BlocBuilder<TimerCubit, TimerState>(
                          builder: (context, state) {
                            return Text(
                              state.getRemainTime.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: ScreenUtil.letterSpacing * 26,
                                fontWeight: FontWeight.bold,
                                // color: cBlueBackground,
                                color: const Color(0xff4C51C6),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<QuestionCubit, QuestionState>(
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.width * 0.035),
                        child: FittedBox(
                          child: Text(
                            state.question,
                            style: GoogleFonts.poppins(
                              // fontSize: ScreenUtil.letterSpacing * 30,
                              fontSize: ScreenUtil.letterSpacing * 45,
                              fontWeight: FontWeight.bold,
                              // color: cBlueBackground,
                              color: cBlueBackground,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: ScreenUtil.height * 0.04),
                  Row(
                    children: [
                      const Spacer(),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return AddToWordCard(
                            title: getAddToCardTypeTitle(state.data.favType),
                            color: const Color(0xffFD830D),
                            onPressed: () {
                              BlocProvider.of<HomePageSelectedWordCubit>(
                                      context)
                                  .updateState(
                                      state.data,
                                      getAddToCardTypeFuncType(
                                          state.data.favType),
                                      context);
                              BlocProvider.of<QuestionCubit>(context)
                                  .UpdateState();
                              widget.showCustomSnackbar(
                                  context,
                                  getAddToCardTypeTitle(state.data.favType) +
                                      "ndi",
                                  duration: 1);
                            },
                          );
                        },
                      ),
                      const Spacer(),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return AddToWordCard(
                            title: getAddToCardFavTitle(state.data.isFav),
                            color: const Color(0xffFF725E),
                            onPressed: () {
                              BlocProvider.of<HomePageSelectedWordCubit>(
                                      context)
                                  .updateState(
                                      state.data,
                                      getAddToCardFavFuncType(state.data.isFav),
                                      context);
                              BlocProvider.of<QuestionCubit>(context)
                                  .UpdateState();
                              widget.showCustomSnackbar(
                                  context,
                                  state.data.isFav
                                      ? "Favorilere Eklendi"
                                      : "Favorilerden Çıkarıldı",
                                  duration: 1);
                            },
                          );
                        },
                      ),
                      const Spacer(),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.height * 0.04),
                  GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                        horizontal: ScreenUtil.width * 0.08),
                    crossAxisCount: 2,
                    crossAxisSpacing: ScreenUtil.width * 0.11,
                    mainAxisSpacing: ScreenUtil.height * 0.025,
                    childAspectRatio: 2.65,
                    shrinkWrap: true,
                    children: [
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return ChoiceCard(
                            id: state.choices![0].id,
                            title: state.choices![0].turkish,
                            onPressed: () {
                              BlocProvider.of<QuestionCubit>(context)
                                  .ChangeSelectedId(state.choices![0].id);
                            },
                          );
                        },
                      ),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return ChoiceCard(
                            id: state.choices![1].id,
                            title: state.choices![1].turkish,
                            onPressed: () {
                              BlocProvider.of<QuestionCubit>(context)
                                  .ChangeSelectedId(state.choices![1].id);
                            },
                          );
                        },
                      ),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return ChoiceCard(
                            id: state.choices![2].id,
                            title: state.choices![2].turkish,
                            onPressed: () {
                              BlocProvider.of<QuestionCubit>(context)
                                  .ChangeSelectedId(state.choices![2].id);
                            },
                          );
                        },
                      ),
                      BlocBuilder<QuestionCubit, QuestionState>(
                        builder: (context, state) {
                          return ChoiceCard(
                            id: state.choices![3].id,
                            title: state.choices![3].turkish,
                            onPressed: () {
                              BlocProvider.of<QuestionCubit>(context)
                                  .ChangeSelectedId(state.choices![3].id);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.height * 0.04),
                  const Spacer(),
                  BlocBuilder<QuestionCubit, QuestionState>(
                    builder: (context, state) {
                      final int time =
                          context.watch<TimerCubit>().state.getRemainTime;
                      return MaterialButton(
                        minWidth: ScreenUtil.width * 0.82,
                        height: ScreenUtil.height * 0.085,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: cBlueBackground,
                        // color: const Color(0xff4C51C6),
                        onPressed: () {
                          if (time <= 0) return;
                          if (state.isAnswered) {
                            BlocProvider.of<QuestionCubit>(context)
                                .ChangeQuestion();
                            startTimer();
                          } else if (state.isAnswered == false &&
                              state.selectedId != -1) {
                            BlocProvider.of<QuestionCubit>(context)
                                .CheckAnswer();
                            stopTimer();
                          } else {
                            widget.showCustomSnackbar(
                                context, "Lütfen Bir Cevap Seçiniz");
                          }
                        },
                        child: Text(
                          state.isAnswered ? "Sonraki Soru" : "Kontrol Et",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.letterSpacing * 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                  // SizedBox(height: ScreenUtil.height * 0.1),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String getAddToCardTypeTitle(WordFavType wordFavType) {
  switch (wordFavType) {
    case WordFavType.learned:
      return "Bilmediklerime Ekle";
    case WordFavType.nlearned:
      return "Bildiklerime Ekle";
    default:
      return "";
  }
}

String getAddToCardFavTitle(bool isFav) {
  if (isFav == true) {
    return "Favorilerden Çıkar";
  } else {
    return "Favorilere Ekle";
  }
}

String getAddToCardTypeFuncType(WordFavType wordFavType) {
  switch (wordFavType) {
    case WordFavType.learned:
      return "NotLearned";
    case WordFavType.nlearned:
      return "Learned";
    default:
      return "";
  }
}

String getAddToCardFavFuncType(bool isFav) {
  if (isFav == true) {
    return "UnFav";
  } else {
    return "Fav";
  }
}
