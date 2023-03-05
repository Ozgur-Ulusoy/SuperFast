import 'dart:async';

import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/CheckAnswerButton.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameBackground.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameUpSection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';

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
          const PlayBackground(),
          SafeArea(
            child: Center(
              child: Column(
                children: [
                  PlayGameUpSelection(title: "İngilizce - Türkçe"),
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
                  CheckAnswerButton(
                    callback: () {
                      final int time = BlocProvider.of<TimerCubit>(context)
                          .state
                          .getRemainTime;
                      if (time <= 0) return;
                      if (BlocProvider.of<QuestionCubit>(context)
                          .state
                          .isAnswered) {
                        BlocProvider.of<QuestionCubit>(context)
                            .ChangeQuestion();
                        // startTimer();
                        startTimer();
                      } else if (BlocProvider.of<QuestionCubit>(context)
                                  .state
                                  .isAnswered ==
                              false &&
                          BlocProvider.of<QuestionCubit>(context)
                                  .state
                                  .selectedId !=
                              -1) {
                        BlocProvider.of<QuestionCubit>(context).CheckAnswer();
                        stopTimer();
                      } else {
                        widget.showCustomSnackbar(
                            context, "Lütfen Bir Cevap Seçiniz");
                      }
                    },
                  ),
                  //!
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
