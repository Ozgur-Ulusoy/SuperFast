part of 'word_filter_cubit.dart';

class WordFilterState {
  bool isFiltering;
  bool isA1;
  bool isA2;
  bool isB1;
  bool isB2;
  bool isC1;
  bool isC2;

  bool isNoun;
  bool isVerb;
  bool isAdjective;
  bool isAdverb;
  bool isPreposition;

  WordFilterState({
    this.isFiltering = false,
    this.isA1 = true,
    this.isA2 = true,
    this.isB1 = true,
    this.isB2 = true,
    this.isC1 = true,
    this.isC2 = true,
    this.isNoun = true,
    this.isVerb = true,
    this.isAdjective = true,
    this.isAdverb = true,
    this.isPreposition = true,
  });

  // copy with

  WordFilterState copyWith({
    bool? isFiltering,
    bool? isA1,
    bool? isA2,
    bool? isB1,
    bool? isB2,
    bool? isC1,
    bool? isC2,
    bool? isNoun,
    bool? isVerb,
    bool? isAdjective,
    bool? isAdverb,
    bool? isPreposition,
  }) {
    return WordFilterState(
      isFiltering: isFiltering ?? this.isFiltering,
      isA1: isA1 ?? this.isA1,
      isA2: isA2 ?? this.isA2,
      isB1: isB1 ?? this.isB1,
      isB2: isB2 ?? this.isB2,
      isC1: isC1 ?? this.isC1,
      isC2: isC2 ?? this.isC2,
      isNoun: isNoun ?? this.isNoun,
      isVerb: isVerb ?? this.isVerb,
      isAdjective: isAdjective ?? this.isAdjective,
      isAdverb: isAdverb ?? this.isAdverb,
      isPreposition: isPreposition ?? this.isPreposition,
    );
  }
}
