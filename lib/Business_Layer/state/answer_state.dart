part of '../cubit/answer_cubit.dart';

class AnswerState {
  List<AnswerClass> answerList = [];
  String answer;
  AnswerState({required this.answerList, required this.answer});

  AnswerState copyWith({
    List<AnswerClass>? answerList,
    String? answer,
  }) {
    return AnswerState(
      answerList: answerList ?? this.answerList,
      answer: answer ?? this.answer,
    );
  }
}

class AnswerClass {
  String? answer;
  int? id;
  AnswerClass({required this.answer, required this.id});
}
