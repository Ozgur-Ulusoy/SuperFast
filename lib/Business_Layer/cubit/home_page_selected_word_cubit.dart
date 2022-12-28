import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';

part '../state/home_page_selected_word_state.dart';

class HomePageSelectedWordCubit extends Cubit<HomePageSelectedWordState> {
  HomePageSelectedWordCubit()
      : super(HomePageSelectedWordState(
            type: WordSelectedStateEnums.learnedWordState,
            learnedWordsList: MainData.learnedDatas!,
            notLearnedWordsList: []));

  void ChangeState(WordSelectedStateEnums type) {
    if (type == WordSelectedStateEnums.notLearnedWordState &&
        state.type == WordSelectedStateEnums.learnedWordState) {
      emit(HomePageSelectedWordState(
          type: WordSelectedStateEnums.notLearnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList));
    }
    //
    else if (type == WordSelectedStateEnums.learnedWordState &&
        state.type == WordSelectedStateEnums.notLearnedWordState) {
      emit(HomePageSelectedWordState(
          type: WordSelectedStateEnums.learnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList));
    }
  }
}
