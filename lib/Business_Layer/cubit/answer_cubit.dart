import 'package:bloc/bloc.dart';

part '../state/answer_state.dart';

//! Amaç Kullanıcının Verdiği Cevabı Tutmak
class AnswerCubit extends Cubit<AnswerState> {
  AnswerCubit() : super(NormalAnswerState(answerList: [], isPressedList: []));

  //* Şıkların basılı olup/olmadığını tutan isPressedList'i verilen değere göre ( yeni sorunun şık sayısı ) tekrar oluşturur ve hepsinin ilk değeri olarak false'ı atar ( çünkü resetlendiği için basılmamış olur )
  void ResetIsPressList(int a) {
    if (state is NormalAnswerState) {
      var st = state as NormalAnswerState;

      List<bool> list = [];
      for (var i = 0; i < a; i++) {
        list.add(false);
      }
      emit(NormalAnswerState(answerList: st.answerList, isPressedList: list));
    }
  }

  //* Kullanıcının cevabını ve seçtiği şıkkın basılabilir olup/olmamasını değiştirir
  void ChangeAnswer(String answer, {int index = -1}) {
    if (state is NormalAnswerState) {
      var st = state as NormalAnswerState;
      if (st.answerList!.contains(" ")) {
        st.answerList![st.answerList!.indexOf(" ")] = answer;
      }
      //* seçilen harfi kullanıcının cevaplarını tutan answerList'e ekler
      else {
        st.answerList!.add(answer);
      }
      //* basılı tutma listesini değiştirmek istemiyorsak indexe -1 göndeririz
      //! şuan aktif olarak kullanılmıyor üstteki özellik
      if (index != -1) {
        st.isPressedList![index] = !(st.isPressedList![index]);
      } //* bastığı tuşun bulunduğu indexteki basılabilirliğini değiştirir
      emit(NormalAnswerState(
          answerList: st.answerList, isPressedList: st.isPressedList));
    }
  }

  //* Kullanıcının verdiği cevap içerisinden harf silmesine yarar
  //* Kullanıcının cevabı listesinde kaçıncı elemanı olduğunu ve tuşların basılı olduğu listede kaçıncı indexte olduğunu veririr
  void DeleteAnswer({int? index, int? ispressedIndex}) {
    if (state is NormalAnswerState) {
      var st = state as NormalAnswerState;
      if (index! < st.answerList!.length) {
        //* liste index dışına çıkmasın diye
        st.answerList![index] = " ";
        //* silinen harf'in tuş olarak aşağıda tekrar gözükmesine yarar
        if (ispressedIndex != -1) {
          st.isPressedList![ispressedIndex!] = false;
        }
      }
      emit(NormalAnswerState(
          answerList: st.answerList, isPressedList: st.isPressedList));
    }
  }

  //* Kullanıcının cevabını resetler
  void ResetAnswer() {
    if (state is NormalAnswerState) {
      var st = state as NormalAnswerState;
      emit(NormalAnswerState(answerList: [], isPressedList: st.isPressedList));
    } else if (state is SoundAnswerState) {
      //! yapilacak
      emit(SoundAnswerState(answer: ""));
    }
  }
}
