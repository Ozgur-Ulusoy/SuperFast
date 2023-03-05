import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/Extensions/stringExtension.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part '../state/question_state.dart';

class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionState(data: questionData[0]));

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

  void ResetState() {
    emit(
      QuestionState(
        data: questionData[0],
        question: "",
        answer: "",
        point: 0,
        trueAnswer: 0,
        falseAnswer: 0,
        isAnswered: false,
        selectedId: 0,
        letters: [],
        questionType: QuestionType.english,
        choices: [],
      ),
    );
  }

  void UpdateState() {
    emit(state.copyWith());
  }

  //* Sorulan soruyu değiştirir - oyun başladığında ve doğru cevap verildiğinde çağrılır
  void ChangeQuestion({QuestionType type = QuestionType.english}) {
    List<Data> randomDatas = <Data>[]; //* şıklar
    List<Data> datas = MainData.learnedDatas! + MainData.notLearnedDatas!;
    while (randomDatas.length < 4) {
      int random = Random().nextInt(datas.length);
      bool canAdd = true;
      for (var i = 0; i < randomDatas.length; i++) {
        if (randomDatas[i].english == datas[random].english ||
            randomDatas[i].turkish == datas[random].turkish) {
          canAdd = false;
        }
      }
      if (!randomDatas.contains(datas[random]) && canAdd) {
        randomDatas.add(datas[random]);
      }
    }
    for (var element in randomDatas) {
      print(element.turkish);
    }

    int random = rnd.nextInt(
        4); //* Generate random for question - index for QuestionData Map
    print(random);

    Data resultData = randomDatas[random];
    print(resultData.english);
    print(resultData.turkish);
    // String urlPath = questionData.elementAt(resultIndex).mediaLink;

    String result = type == QuestionType.english
        ? resultData.turkish
        : resultData.english; //* result of generated random question

    result = type == QuestionType.english
        ? result.ToUpperTurkish()
        : result.toUpperCase();

    String question = type == QuestionType.english
        ? resultData.english
        : resultData.turkish; //* question of generated random question
    question = type == QuestionType.english
        ? question.toUpperCase()
        : question.ToUpperTurkish();

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
          ? resultList[i].ToUpperTurkish()
          : resultList[i].toUpperCase();
    }

    // result =
    //     result.replaceAll(" ", "").toLowerCase(); //* cevaptan boşlukları çıkar
    // result = result.toLowerCase();
    resultList.shuffle(); //* randomize the list

    //! Test
    // print("test : " + result + " " + resultList.length.toString());
    // for (var item in resultList) {
    //   print(item);
    // }
    return emit(state.copyWith(
      data: resultData,
      question: question,
      answer: result,
      isAnswered: false,
      selectedId: -1,
      letters: resultList,
      choices: randomDatas,
      questionType: type,
    )

        // QuestionState(
        //   data: resultData,
        //   question: question,
        //   answer: result,
        //   point: state.point + 200,
        //   trueAnswer: state.tr,
        //   falseAnswer: state.falseAnswer,
        //   letters: resultList,
        //   choices: randomDatas,
        //   questionType: type,
        // ),
        );
  }

  void ChangeSelectedId(int id) {
    emit(state.copyWith(selectedId: id));
  }

  void CheckAnswer() {
    if (state.data.id == state.selectedId) {
      TrueAnswerEvent(150);
      print(
          "dogru cevaplandırılan soru sayısı = " + state.trueAnswer.toString());
    } else {
      FalseAnswerEvent(125);
      print("yanlış cevaplandırılan soru sayısı = " +
          state.falseAnswer.toString());
    }
    emit(state.copyWith(isAnswered: true));
  }

  void TrueAnswerEvent(int point) {
    emit(state.copyWith(
        trueAnswer: state.trueAnswer + 1, point: state.point + point));
  }

  void FalseAnswerEvent(int point) {
    emit(state.copyWith(
        falseAnswer: state.falseAnswer + 1, point: state.point - point));
  }
}

enum QuestionType {
  turkish,
  english,
}

enum GameType {
  normal,
  engame,
  sound,
}
