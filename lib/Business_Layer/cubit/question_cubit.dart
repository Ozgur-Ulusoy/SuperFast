import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../state/question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionState());

  Random rnd = Random(); //* rastgele yapacağımız işlemler için
  List<String> alfabe = [
    "a",
    "b",
    "c",
    "ç",
    "d",
    "e",
    "f",
    "g",
    "ğ",
    "h",
    "i",
    "ı",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "ö",
    "p",
    "r",
    "s",
    "ş",
    "t",
    "u",
    "ü",
    "v",
    "y",
    "z"
  ];
  List<String> alphabet = [
    "a",
    "b",
    "c",
    "d",
    "e",
    "f",
    "g",
    "h",
    "i",
    "j",
    "k",
    "l",
    "m",
    "n",
    "o",
    "p",
    "q",
    "r",
    "s",
    "t",
    "u",
    "v",
    "w",
    "x",
    "y",
    "z",
  ];
  //* türkçe ve ingilizce alfabe

  //* Türkçe kelimeleri türkçede Büyük harfe çevirir
  String ToUpperTurkish(String a) {
    String res = a;
    for (var i = 0; i < res.length; i++) {
      if (res[i] == "i") {
        res = res.replaceRange(i, i + 1, "İ");
      } else if (res[i] == "ç") {
        res = res.replaceRange(i, i + 1, "Ç");
      } else if (res[i] == "ö") {
        res = res.replaceRange(i, i + 1, "Ö");
      } else if (res[i] == "ş") {
        res = res.replaceRange(i, i + 1, "Ş");
      } else if (res[i] == "ü") {
        res = res.replaceRange(i, i + 1, "Ü");
      } else if (res[i] == "ğ") {
        res = res.replaceRange(i, i + 1, "Ğ");
      } else {
        res = res.replaceRange(i, i + 1, res[i].toUpperCase());
      }
    }
    return res;
  }

  //* Sorulan soruyu değiştirir - oyun başladığında ve doğru cevap verildiğinde çağrılır
  void ChangeQuestion({QuestionType type = QuestionType.turkish}) {
    int random = rnd.nextInt(questionData
        .length); //* Generate random for question - index for QuestionData Map

    String urlPath = questionData.elementAt(random).mediaLink;

    String result = type == QuestionType.english
        ? questionData.elementAt(random).turkish
        : questionData
            .elementAt(random)
            .english; //* result of generated random question
    result = type == QuestionType.english
        ? ToUpperTurkish(result)
        : result.toUpperCase();

    String question = type == QuestionType.english
        ? questionData.elementAt(random).english
        : questionData
            .elementAt(random)
            .turkish; //* question of generated random question
    question = type == QuestionType.english
        ? question.toUpperCase()
        : ToUpperTurkish(question);

    List<String> resultList = <String>[]; //* result list for Question State

    //* get all letters of result to the resultList
    for (var i = 0; i < result.length; i++) {
      resultList.add(result[i]);
    }

    // //* add 3 more random letter from alphabet
    // for (var i = 0; i < 3; i++) {
    //   var res = type == QuestionType.english ? alfabe : alphabet;
    //   int random = rnd.nextInt(res.length);

    //   // if (resultList.contains(alfabe[random])) {
    //   //   continue;
    //   // } else {
    //   resultList.add(res[random]);
    //   // i++;
    //   // }
    // }

    resultList.remove(" ");
    for (var i = 0; i < resultList.length; i++) {
      resultList[i] = type == QuestionType.english
          ? ToUpperTurkish(resultList[i])
          : resultList[i].toUpperCase();
    }

    // result =
    //     result.replaceAll(" ", "").toLowerCase(); //* cevaptan boşlukları çıkar
    // result = result.toLowerCase();
    resultList.shuffle(); //* randomize the list

    //! Test
    print("test : " + result + " " + resultList.length.toString());
    for (var item in resultList) {
      print(item);
    }

    return emit(
      QuestionState(
        question: question,
        answer: result,
        point: state.point + 200,
        trueAnswer: state.trueAnswer + 1,
        letters: resultList,
        urlPath: urlPath,
      ),
    );
  }
  //

}

enum QuestionType {
  turkish,
  english,
}

enum GameType {
  normal,
  sound,
}
