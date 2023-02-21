part of '../cubit/question_cubit.dart';

class QuestionState {
  QuestionType questionType;
  Data data; //? soru verileri
  String question; //? soru
  String answer; //? cevap
  // String urlPath; //? ses

  int point; //? puan
  int trueAnswer; //? dogru cevap sayısı
  int falseAnswer; //? yanlış cevap sayısı
  bool isAnswered = false; //? cevaplandı mı
  int selectedId = 0; //? seçilen şık id

  List<String>? letters; //? şıklar
  List<Data>? choices;

  QuestionState({
    required this.data,
    this.question = " ",
    this.answer = " ",
    this.point = 0,
    this.trueAnswer = 0,
    this.falseAnswer = 0,
    this.isAnswered = false,
    this.selectedId = 0,
    this.letters,
    this.questionType = QuestionType.english,
    // this.urlPath = " ",
    this.choices = const [],
  });

  // create a copy of the state
  QuestionState copyWith({
    Data? data,
    String? question,
    String? answer,
    int? point,
    int? trueAnswer,
    int? falseAnswer,
    bool? isAnswered,
    int? selectedId,
    List<String>? letters,
    List<Data>? choices,
    QuestionType? questionType,
    // String? urlPath,
  }) {
    return QuestionState(
      data: data ?? this.data,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      point: point ?? this.point,
      trueAnswer: trueAnswer ?? this.trueAnswer,
      falseAnswer: falseAnswer ?? this.falseAnswer,
      isAnswered: isAnswered ?? this.isAnswered,
      selectedId: selectedId ?? this.selectedId,
      letters: letters ?? this.letters,
      choices: choices ?? this.choices,
      questionType: questionType ?? this.questionType,
      // urlPath: urlPath ?? this.urlPath,
    );
  }
}
