import 'package:bloc/bloc.dart';

part '../state/answer_state.dart';

//! Amaç Kullanıcının Verdiği Cevabı Tutmak
class AnswerCubit extends Cubit<AnswerState> {
  AnswerCubit() : super(AnswerState(answerList: [], isPressedList: []));

  //* Şıkların basılı olup/olmadığını tutan isPressedList'i verilen değere göre ( yeni sorunun şık sayısı ) tekrar oluşturur ve hepsinin ilk değeri olarak false'ı atar ( çünkü resetlendiği için basılmamış olur )
  void ResetIsPressList(int a) {
    List<bool> list = [];
    for (var i = 0; i < a; i++) {
      list.add(false);
    }
    emit(AnswerState(answerList: state.answerList, isPressedList: list));
  }

  //* Kullanıcının cevabını ve seçtiği şıkkın basılabilir olup/olmamasını değiştirir
  void ChangeAnswer(String answer, {int index = -1}) {
    if (state.answerList!.contains(" ")) {
      state.answerList![state.answerList!.indexOf(" ")] = answer;
    }
    //* seçilen harfi kullanıcının cevaplarını tutan answerList'e ekler
    else {
      state.answerList!.add(answer);
    }
    //* basılı tutma listesini değiştirmek istemiyorsak indexe -1 göndeririz
    //! şuan aktif olarak kullanılmıyor üstteki özellik
    if (index != -1) {
      state.isPressedList![index] = !(state.isPressedList![index]);
    } //* bastığı tuşun bulunduğu indexteki basılabilirliğini değiştirir
    emit(AnswerState(
        answerList: state.answerList, isPressedList: state.isPressedList));
  }

  //* Kullanıcının verdiği cevap içerisinden harf silmesine yarar
  //* Kullanıcının cevabı listesinde kaçıncı elemanı olduğunu ve tuşların basılı olduğu listede kaçıncı indexte olduğunu veririr
  void DeleteAnswer(int index, int ispressedIndex) {
    if (index < state.answerList!.length) {
      //* liste index dışına çıkmasın diye
      state.answerList![index] = " ";
      //* silinen harf'in tuş olarak aşağıda tekrar gözükmesine yarar
      if (ispressedIndex != -1) {
        state.isPressedList![ispressedIndex] = false;
      }
    }
    emit(AnswerState(
        answerList: state.answerList, isPressedList: state.isPressedList));
  }

  //* Kullanıcının cevabını resetler
  void ResetAnswer() {
    emit(AnswerState(answerList: [], isPressedList: state.isPressedList));
  }
}
