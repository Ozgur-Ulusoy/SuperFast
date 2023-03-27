import 'package:bloc/bloc.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:flutter/material.dart';

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
            currentData: null,
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
        currentData: null,
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
        currentData: MainData.dailyData,
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
          currentData: state.currentData,
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
          currentData: state.currentData,
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
        currentData: state.currentData,
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
          currentData: state.currentData,
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
          currentData: state.currentData,
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
          currentData: state.currentData,
        ),
      );
    }
  }

  void updateState(var data, String type, BuildContext context) async {
    switch (type) {
      case "Learned":
        if (MainData.learnedDatas!.contains(data)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Zaten Bu Kelime Öğrenilen Kelimelerde"),
            ),
          );
          return;
        }
        // 1 5 8 13 46 85 90
        data.favType = WordFavType.learned;
        MainData.learnedDatas!.add(data);
        MainData.notLearnedDatas!.remove(data);
        MainData.learnedList = MainData.learnedList! + "${data.id} ";
        MainData.isLearnedListChanged = true;
        await MainData.localData!.put(
            KeyUtils.isLearnedListChangedKey, MainData.isLearnedListChanged);
        break;
      case "NotLearned":
        if (MainData.notLearnedDatas!.contains(data)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Zaten Bu Kelime Bilmediğim Kelimelerde"),
            ),
          );
          return;
        }
        data.favType = WordFavType.nlearned;
        MainData.notLearnedDatas!.add(data);
        MainData.learnedDatas!.remove(data);
        MainData.learnedList =
            MainData.learnedList!.replaceAll("${data.id} ", "");
        MainData.isLearnedListChanged = true;
        await MainData.localData!.put(
            KeyUtils.isLearnedListChangedKey, MainData.isLearnedListChanged);
        print(MainData.learnedList);
        break;
      case "Fav":
        if (MainData.favDatas!.contains(data)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Zaten Bu Kelime Favori Kelimelerde"),
            ),
          );
          return;
        }
        data.isFav = true;
        MainData.favDatas!.add(data);
        MainData.favList = MainData.favList! + "${data.id} ";
        MainData.isFavListChanged = true;
        await MainData.localData!
            .put(KeyUtils.isFavListChangedKey, MainData.isFavListChanged);
        break;
      case "UnFav":
        data.isFav = false;
        MainData.favDatas!.remove(data);
        MainData.favList = MainData.favList!.replaceAll("${data.id} ", "");
        MainData.isFavListChanged = true;
        await MainData.localData!
            .put(KeyUtils.isFavListChangedKey, MainData.isFavListChanged);
        break;
      default:
        break;
    }
    emit(
      HomePageSelectedWordState(
        type: state.type,
        learnedWordsList: MainData.learnedDatas!,
        notLearnedWordsList: MainData.notLearnedDatas!,
        favWordsList: MainData.favDatas!,
        isSearching: state.isSearching,
        searchValue: state.searchValue,
        currentData: state.currentData,
      ),
    );
  }

  void changeCurrentData(Data data) {
    emit(state.copyWith(currentData: data));
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

  List<Data> returnFilteredDataList(
      bool isA1,
      bool isA2,
      bool isB1,
      bool isB2,
      bool isC1,
      bool isC2,
      bool isNoun,
      bool isVerb,
      bool isAdjective,
      bool isAdverb,
      bool isPreposition) {
    return returnDataList()
        .where(
          (element) =>
              element.level == WordLevel.a1 && isA1 ||
              element.level == WordLevel.a2 && isA2 ||
              element.level == WordLevel.b1 && isB1 ||
              element.level == WordLevel.b2 && isB2 ||
              element.level == WordLevel.c1 && isC1 ||
              element.level == WordLevel.c2 && isC2,
        )
        .toList()
        .where(
          (element) =>
              element.type == WordType.noun && isNoun ||
              element.type == WordType.verb && isVerb ||
              element.type == WordType.adjective && isAdjective ||
              element.type == WordType.adverb && isAdverb ||
              element.type == WordType.preposition && isPreposition,
        )
        .toList();
  }
}
