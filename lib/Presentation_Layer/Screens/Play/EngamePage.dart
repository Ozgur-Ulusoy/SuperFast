import 'dart:async';

import 'package:engame2/Data_Layer/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';

class EngamePage extends StatefulWidget {
  const EngamePage({Key? key}) : super(key: key);

  @override
  State<EngamePage> createState() => _EngamePageState();
}

class _EngamePageState extends State<EngamePage> {
  Timer? timer;

  void StartTimer() {
    BlocProvider.of<TimerCubit>(context).ResetTime();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      BlocProvider.of<TimerCubit>(context).DecreaseTime();
      if (BlocProvider.of<TimerCubit>(context).state.remainTime <= 0) {
        timer.cancel();
        print("end");
        //! puan ekranı
      }
    });
  }

  @override
  initState() {
    super.initState();
    // BlocProvider.of<AnswerCubit>(context).ResetAnswer();
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
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                BlocBuilder<TimerCubit, TimerState>(
                  builder: (context, state) {
                    return Text(state.remainTime.toString());
                  },
                ),
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
                                  width:
                                      (ScreenUtil.width / count) - spacerWidth,
                                  color: state.remainTime * count / 90 <= index
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
              ],
            ),
            // child: BlocBuilder<QuestionCubit, QuestionState>(
            //   builder: (context, state) {
            //     return Text(state.question + " " + state.answer + " "
            //         // +
            //         // state.choices!.iterator.current.turkish,
            //         );
            //   },
          ),
        ));
  }
}
