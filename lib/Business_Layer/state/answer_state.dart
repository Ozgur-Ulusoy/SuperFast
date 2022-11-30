part of '../cubit/answer_cubit.dart';

class AnswerState {
  List<String>? answerList =
      []; //? kullanıcının seçtiği harfleri tutan liste => kullanıcı cevabı
  List<bool>? isPressedList = []; //? şıkların basılma durumunu tutan litse

  AnswerState({this.answerList, this.isPressedList});
}
