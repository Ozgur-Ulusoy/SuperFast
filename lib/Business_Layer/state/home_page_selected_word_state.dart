part of '../cubit/home_page_selected_word_cubit.dart';

class HomePageSelectedWordState {
  WordSelectedStateEnums type;
  List<Data> learnedWordsList;
  List<Data> notLearnedWordsList;
  List<Data> favWordsList;
  bool isSearching;
  String searchValue;
  Data? currentData;

  HomePageSelectedWordState({
    required this.type,
    required this.learnedWordsList,
    required this.notLearnedWordsList,
    required this.favWordsList,
    required this.isSearching,
    required this.searchValue,
    required this.currentData,
  });

  // create a copy of the state
  HomePageSelectedWordState copyWith({
    WordSelectedStateEnums? type,
    List<Data>? learnedWordsList,
    List<Data>? notLearnedWordsList,
    List<Data>? favWordsList,
    bool? isSearching,
    String? searchValue,
    Data? currentData,
  }) {
    return HomePageSelectedWordState(
      type: type ?? this.type,
      learnedWordsList: learnedWordsList ?? this.learnedWordsList,
      notLearnedWordsList: notLearnedWordsList ?? this.notLearnedWordsList,
      favWordsList: favWordsList ?? this.favWordsList,
      isSearching: isSearching ?? this.isSearching,
      searchValue: searchValue ?? this.searchValue,
      currentData: currentData ?? this.currentData,
    );
  }
}

// class LearnedWordState extends HomePageSelectedWordState {
//   List<int> learnedWordsList;
//   LearnedWordState(this.learnedWordsList)
//       : super(WordSelectedStateEnums.learnedWordState);
// }

// class NotLearnedState extends HomePageSelectedWordState {
//   NotLearnedState() : super(WordSelectedStateEnums.notLearnedWordState);
// }
