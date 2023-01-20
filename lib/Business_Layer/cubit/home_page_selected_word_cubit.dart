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
            favWordsList: MainData.favDatas!,
            isSearching: false,
            searchValue: "",
          ),
        );
  //

  void ResetState() {
    emit(
      HomePageSelectedWordState(
        type: WordSelectedStateEnums.learnedWordState,
        learnedWordsList: [],
        notLearnedWordsList: [],
        favWordsList: [],
        isSearching: false,
        searchValue: "",
      ),
    );
  }

  void StateBuild() {
    emit(
      HomePageSelectedWordState(
        type: WordSelectedStateEnums.learnedWordState,
        learnedWordsList: MainData.learnedDatas!,
        notLearnedWordsList: MainData.notLearnedDatas!,
        favWordsList: MainData.favDatas!,
        isSearching: false,
        searchValue: "",
      ),
    );
  }

  void ChangeIsSearch(bool val) {
    if (val) {
      emit(
        HomePageSelectedWordState(
          type: state.type,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
          favWordsList: state.favWordsList,
          isSearching: true,
          searchValue: state.searchValue,
        ),
      );
    } else {
      emit(
        HomePageSelectedWordState(
          type: state.type,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
          favWordsList: state.favWordsList,
          isSearching: false,
          searchValue: state.searchValue,
        ),
      );
    }
  }

  void ChangeSearchInput(String input) {
    emit(
      HomePageSelectedWordState(
        type: state.type,
        learnedWordsList: state.learnedWordsList,
        notLearnedWordsList: state.notLearnedWordsList,
        favWordsList: state.favWordsList,
        isSearching: state.isSearching,
        searchValue: input,
      ),
    );
  }

  void ChangeState(WordSelectedStateEnums type) {
    if (type == WordSelectedStateEnums.notLearnedWordState &&
        state.type != WordSelectedStateEnums.notLearnedWordState) {
      emit(
        HomePageSelectedWordState(
          type: WordSelectedStateEnums.notLearnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
          favWordsList: state.favWordsList,
          isSearching: state.isSearching,
          searchValue: state.searchValue,
        ),
      );
    }
    //
    else if (type == WordSelectedStateEnums.learnedWordState &&
        state.type != WordSelectedStateEnums.learnedWordState) {
      emit(
        HomePageSelectedWordState(
          type: WordSelectedStateEnums.learnedWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
          favWordsList: state.favWordsList,
          isSearching: state.isSearching,
          searchValue: state.searchValue,
        ),
      );
    } else if (type == WordSelectedStateEnums.favoriteWordState &&
        state.type != WordSelectedStateEnums.favoriteWordState) {
      emit(
        HomePageSelectedWordState(
          type: WordSelectedStateEnums.favoriteWordState,
          learnedWordsList: state.learnedWordsList,
          notLearnedWordsList: state.notLearnedWordsList,
          favWordsList: state.favWordsList,
          isSearching: state.isSearching,
          searchValue: state.searchValue,
        ),
      );
    }
  }

  List<Data> returnDataList() {
    if (state.isSearching) {
      return returnSearchedDataList(state.searchValue);
    } else {
      return returnSelectedDataList();
    }
  }

  List<Data> returnSelectedDataList() {
    switch (state.type) {
      case WordSelectedStateEnums.learnedWordState:
        return state.learnedWordsList;
      case WordSelectedStateEnums.notLearnedWordState:
        return state.notLearnedWordsList;
      case WordSelectedStateEnums.favoriteWordState:
        return state.favWordsList;
      default:
        return [];
    }
  }

  List<Data> returnSearchedDataList(String input) {
    return returnSelectedDataList()
        .where((element) =>
            element.english.toLowerCase().startsWith(input.toLowerCase()))
        .toList();
  }
}
