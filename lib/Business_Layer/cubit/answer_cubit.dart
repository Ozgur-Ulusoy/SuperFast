import 'package:bloc/bloc.dart';

part '../state/answer_state.dart';

//! Amaç Kullanıcının Verdiği Cevabı Tutmak
class AnswerCubit extends Cubit<AnswerState> {
  AnswerCubit() : super(
            // AnswerState(answerList: [], isPressedList: [], answer: "")
            AnswerState(answerList: [], answer: ""));

  // //* Şıkların basılı olup/olmadığını tutan isPressedList'i verilen değere göre ( yeni sorunun şık sayısı ) tekrar oluşturur ve hepsinin ilk değeri olarak false'ı atar ( çünkü resetlendiği için basılmamış olur )
  // void ResetIsPressList() {
  //   for (var i = 0; i < state.answerList.length; i++) {
  //     state.answerList[i].isPressed = false;
  //   }
  //   emit(state.copyWith());
  //   // List<bool> list = [];
  //   // for (var i = 0; i < a; i++) {
  //   //   list.add(false);
  //   // }
  //   // emit(state.copyWith(isPressedList: list));
  // }

  //* Kullanıcının cevabını ve seçtiği şıkkın basılabilir olup/olmamasını değiştirir
  void ChangeAnswer(String answer, int id) {
    if (state.answerList.where((element) => element.id == id).isEmpty) {
      //* eğer kullanıcının cevabı içerisinde seçilen şık yoksa
      state.answerList.add(AnswerClass(answer: answer, id: id));
    }
    // else {
    //   //* eğer kullanıcının cevabı içerisinde seçilen şık varsa
    //   state.answerList[state.answerList.indexOf(
    //           state.answerList.where((element) => element.id == id).first)] =
    //       AnswerClass(answer: answer, id: id);
    // }
    String answerGlobal = "";
    for (var i = 0; i < state.answerList.length; i++) {
      answerGlobal += state.answerList[i].answer!;
    }

    // if (state.answerList!.contains(" ")) {
    //   state.answerList![state.answerList!.indexOf(" ")] = answer;
    // }

    // //* seçilen harfi kullanıcının cevaplarını tutan answerList'e ekler
    // else {
    //   state.answerList!.add(answer);
    // }
    // //* basılı tutma listesini değiştirmek istemiyorsak indexe -1 göndeririz
    // //! şuan aktif olarak kullanılmıyor üstteki özellik
    // if (index != -1) {
    //   state.isPressedList![index] = !(state.isPressedList![index]);
    // } //* bastığı tuşun bulunduğu indexteki basılabilirliğini değiştirir
    emit(state.copyWith(answer: answerGlobal));
  }

  //* Kullanıcının verdiği cevap içerisinden harf silmesine yarar
  //* Kullanıcının cevabı listesinde kaçıncı elemanı olduğunu ve tuşların basılı olduğu listede kaçıncı indexte olduğunu veririr
  void DeleteAnswer() {
    if (state.answerList.isEmpty) return;
    state.answerList.removeLast();
    String answerGlobal = "";
    for (var i = 0; i < state.answerList.length; i++) {
      answerGlobal += state.answerList[i].answer!;
    }
    emit(state.copyWith(answer: answerGlobal));
    // if (index! < state.answerList!.length) {
    //   //* liste index dışına çıkmasın diye
    //   state.answerList![index] = " ";
    //   //* silinen harf'in tuş olarak aşağıda tekrar gözükmesine yarar
    //   if (ispressedIndex != -1) {
    //     state.isPressedList![ispressedIndex!] = false;
    //   }
    // }
    // emit(state.copyWith(answer: state.answerList!.join()));
  }

  //* Kullanıcının cevabını resetler
  void ResetAnswer() {
    // emit(state.copyWith(answer: "", answerList: [], isPressedList: []));
    emit(state.copyWith(answer: "", answerList: []));
  }
}
