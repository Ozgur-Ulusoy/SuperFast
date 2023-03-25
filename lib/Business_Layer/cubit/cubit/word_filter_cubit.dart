import 'package:bloc/bloc.dart';

part 'word_filter_state.dart';

class WordFilterCubit extends Cubit<WordFilterState> {
  WordFilterCubit() : super(WordFilterState());

  void ChangeIsFiltering(bool val) {
    emit(
      state.copyWith(
        isFiltering: val,
      ),
    );
  }

  void ChangeIsA1(bool val) {
    emit(
      state.copyWith(
        isA1: val,
      ),
    );
  }

  void ChangeIsA2(bool val) {
    emit(
      state.copyWith(
        isA2: val,
      ),
    );
  }

  void ChangeIsB1(bool val) {
    emit(
      state.copyWith(
        isB1: val,
      ),
    );
  }

  void ChangeIsB2(bool val) {
    emit(
      state.copyWith(
        isB2: val,
      ),
    );
  }

  void ChangeIsC1(bool val) {
    emit(
      state.copyWith(
        isC1: val,
      ),
    );
  }

  void ChangeIsC2(bool val) {
    emit(
      state.copyWith(
        isC2: val,
      ),
    );
  }

  void ChangeIsNoun(bool val) {
    emit(
      state.copyWith(
        isNoun: val,
      ),
    );
  }

  void ChangeIsVerb(bool val) {
    emit(
      state.copyWith(
        isVerb: val,
      ),
    );
  }

  void ChangeIsAdjective(bool val) {
    emit(
      state.copyWith(
        isAdjective: val,
      ),
    );
  }

  void ChangeIsAdverb(bool val) {
    emit(
      state.copyWith(
        isAdverb: val,
      ),
    );
  }

  void ChangeIsPreposition(bool val) {
    emit(
      state.copyWith(
        isPreposition: val,
      ),
    );
  }

  void Reset() {
    emit(
      state.copyWith(
        isFiltering: false,
        isA1: true,
        isA2: true,
        isB1: true,
        isB2: true,
        isC1: true,
        isC2: true,
        isNoun: true,
        isVerb: true,
        isAdjective: true,
        isAdverb: true,
        isPreposition: true,
      ),
    );
  }
}
