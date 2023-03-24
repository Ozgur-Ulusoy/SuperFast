import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../Business_Layer/cubit/question_cubit.dart';
import '../../Business_Layer/cubit/timer_cubit.dart';
import '../../Data_Layer/consts.dart';
import 'PlayAddToWordCard.dart';

class PlayGameUpSelection extends StatefulWidget with PopUpMixin {
  String title;
  bool isLetterPage;
  VoidCallback goBackCaller;
  PlayGameUpSelection(
      {Key? key,
      required this.title,
      this.isLetterPage = false,
      required this.goBackCaller})
      : super(key: key);

  @override
  State<PlayGameUpSelection> createState() => _PlayGameUpSelectionState();
}

class _PlayGameUpSelectionState extends State<PlayGameUpSelection> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                  widget.goBackCaller();
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
        SizedBox(
            height: widget.isLetterPage
                ? ScreenUtil.height * 0.025
                : ScreenUtil.height * 0.033),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: ScreenUtil.width * 0.06),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Kelimelerle İngilizce",
                  style: GoogleFonts.poppins(
                    fontSize: ScreenUtil.letterSpacing * 22,
                    fontWeight: FontWeight.bold,
                    color: cBlueBackground,
                  ),
                  textAlign: TextAlign.start,
                ),
                Text(
                  widget.title,
                  style: GoogleFonts.poppins(
                    fontSize: ScreenUtil.letterSpacing * 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0XFF4C51C6).withOpacity(0.74),
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
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
                          width: (ScreenUtil.width / count) - spacerWidth,
                          color: state.getRemainTime * count / 75 <= index
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
        SizedBox(
            height: widget.isLetterPage
                ? ScreenUtil.height * 0.00
                : ScreenUtil.height * 0.015),
        Padding(
          padding: EdgeInsets.only(
              right: ScreenUtil.width * 0.025, top: ScreenUtil.height * 0.015),
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
                      color: const Color.fromARGB(255, 143, 76, 198),
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
              padding:
                  EdgeInsets.symmetric(horizontal: ScreenUtil.width * 0.035),
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
        SizedBox(
            height: widget.isLetterPage
                ? ScreenUtil.height * 0.025
                : ScreenUtil.height * 0.04),
        Row(
          children: [
            const Spacer(),
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return AddToWordCard(
                  width: ScreenUtil.width * 0.41,
                  title: getAddToCardTypeTitle(state.data.favType),
                  color: const Color(0xffFD830D),
                  onPressed: () {
                    BlocProvider.of<HomePageSelectedWordCubit>(context)
                        .updateState(
                            state.data,
                            getAddToCardTypeFuncType(state.data.favType),
                            context);
                    BlocProvider.of<QuestionCubit>(context).UpdateState();
                    // widget.showCustomSnackbar(context,
                    //     getAddToCardTypeSnackbarTitle(state.data.favType),
                    //     duration: 150);
                  },
                );
              },
            ),
            const Spacer(),
            BlocBuilder<QuestionCubit, QuestionState>(
              builder: (context, state) {
                return AddToWordCard(
                  width: ScreenUtil.width * 0.41,
                  title: getAddToCardFavTitle(state.data.isFav),
                  color: const Color(0xffFF725E),
                  onPressed: () {
                    BlocProvider.of<HomePageSelectedWordCubit>(context)
                        .updateState(state.data,
                            getAddToCardFavFuncType(state.data.isFav), context);
                    BlocProvider.of<QuestionCubit>(context).UpdateState();

                    // widget.showCustomSnackbar(
                    //     context,
                    //     state.data.isFav
                    //         ? "Favorilere Eklendi"
                    //         : "Favorilerden Çıkarıldı",
                    //     duration: 150);
                  },
                );
              },
            ),
            const Spacer(),
          ],
        ),
        SizedBox(
            height: widget.isLetterPage
                ? ScreenUtil.height * 0.025
                : ScreenUtil.height * 0.04),
      ],
    );
  }
}
