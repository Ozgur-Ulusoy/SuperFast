part of '../cubit/home_page_selected_word_cubit.dart';

class HomePageSelectedWordState {
  WordSelectedStateEnums type;
  List<Data> learnedWordsList;
  List<Data> notLearnedWordsList;
  List<Data> favWordsList;
  bool isSearching;
  String searchValue;

  HomePageSelectedWordState({
    required this.type,
    required this.learnedWordsList,
    required this.notLearnedWordsList,
    required this.favWordsList,
    required this.isSearching,
    required this.searchValue,
  });
}

// class LearnedWordState extends HomePageSelectedWordState {
//   List<int> learnedWordsList;
//   LearnedWordState(this.learnedWordsList)
//       : super(WordSelectedStateEnums.learnedWordState);
// }

// class NotLearnedState extends HomePageSelectedWordState {
//   NotLearnedState() : super(WordSelectedStateEnums.notLearnedWordState);
// }
