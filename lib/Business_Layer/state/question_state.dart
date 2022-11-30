part of '../cubit/question_cubit.dart';

class QuestionState {
  String question; //? soru
  String answer; //? cevap

  int point; //? puan
  int trueAnswer; //? dogru cevap sayısı

  List<String>? letters; //? şıklar

  QuestionState({
    this.question = " ",
    this.answer = " ",
    this.point = -200,
    this.trueAnswer = -1,
    this.letters,
  });
}
