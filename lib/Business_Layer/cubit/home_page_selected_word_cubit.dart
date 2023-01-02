import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';

part '../state/home_page_selected_word_state.dart';

class HomePageSelectedWordCubit extends Cubit<HomePageSelectedWordState> {
  HomePageSelectedWordCubit()
      : super(
          HomePageSelectedWordState(
            type: WordSelectedStateEnums.learnedWordState,
            learnedWordsList: MainData.learnedDatas!,
            notLearnedWordsList: MainData.notLearnedDatas!,
          ),
        );
  //

  void ResetState() {
    emit(
      HomePageSelectedWordState(
        type: WordSelectedStateEnums.learnedWordState,
        learnedWordsList: [],
        notLearnedWordsList: [],
      ),
    );
  }

  void StateBuild() {
    emit(
      HomePageSelectedWordState(
        type: WordSelectedStateEnums.learnedWordState,
        learnedWordsList: MainData.learnedDatas!,
        notLearnedWordsList: MainData.notLearnedDatas!,
      ),
    );
  }

  void ChangeState(WordSelectedStateEnums type) {
    if (type == WordSelectedStateEnums.notLearnedWordState &&
        state.type == WordSelectedStateEnums.learnedWordState) {
      emit(
        HomePageSelectedWordState(
          type: WordSelectedStateEnums.notLearnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
        ),
      );
    }
    //
    else if (type == WordSelectedStateEnums.learnedWordState &&
        state.type == WordSelectedStateEnums.notLearnedWordState) {
      emit(
        HomePageSelectedWordState(
          type: WordSelectedStateEnums.learnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
        ),
      );
    }
  }

  List<Data> returnSelectedDataList() {
    switch (state.type) {
      case WordSelectedStateEnums.learnedWordState:
        return state.learnedWordsList;
      case WordSelectedStateEnums.notLearnedWordState:
        return state.notLearnedWordsList;

      default:
        return [];
    }
  }
}
