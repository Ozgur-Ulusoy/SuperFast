part of '../cubit/timer_cubit.dart';

class TimerState {
  int remainTime;

  int get getRemainTime => remainTime;
  set setRemainTime(int val) {
    if (val <= 0) {
      remainTime = 0;
    } else {
      remainTime = val;
    }
  }

  TimerState({this.remainTime = 75});
}
