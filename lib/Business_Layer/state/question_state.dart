part of '../cubit/question_cubit.dart';

class QuestionState {
  QuestionType questionType;
  Data data; //? soru verileri
  String question; //? soru
  String answer; //? cevap
  // String urlPath; //? ses

  int point; //? puan
  int trueAnswer; //? dogru cevap sayısı

  List<String>? letters; //? şıklar
  List<Data>? choices;

  QuestionState({
    required this.data,
    this.question = " ",
    this.answer = " ",
    this.point = -200,
    this.trueAnswer = -1,
    this.letters,
    this.questionType = QuestionType.english,
    // this.urlPath = " ",
    this.choices = const [],
  });
}
