part of '../cubit/home_page_selected_word_cubit.dart';

class HomePageSelectedWordState {
  WordSelectedStateEnums type;
  List<Data> learnedWordsList;
  List<Data> notLearnedWordsList;

  HomePageSelectedWordState(
      {required this.type,
      required this.learnedWordsList,
      required this.notLearnedWordsList});
}

// class LearnedWordState extends HomePageSelectedWordState {
//   List<int> learnedWordsList;
//   LearnedWordState(this.learnedWordsList)
//       : super(WordSelectedStateEnums.learnedWordState);
// }

// class NotLearnedState extends HomePageSelectedWordState {
//   NotLearnedState() : super(WordSelectedStateEnums.notLearnedWordState);
// }
