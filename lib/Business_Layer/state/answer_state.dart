part of '../cubit/answer_cubit.dart';

abstract class AnswerState {}

class NormalAnswerState extends AnswerState {
  List<String>? answerList =
      []; //? kullanıcının seçtiği harfleri tutan liste => kullanıcı cevabı
  List<bool>? isPressedList = []; //? şıkların basılma durumunu tutan litse

  NormalAnswerState({this.answerList, this.isPressedList});
}

class SoundAnswerState extends AnswerState {
  String? answer;
  SoundAnswerState({this.answer});
}
