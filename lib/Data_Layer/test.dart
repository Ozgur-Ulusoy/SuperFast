import 'package:firebase_auth/firebase_auth.dart';

import 'data.dart';

void Test() {
  // print("Total Words Length = ${questionData.length}");
  // print("Wordle Words Text Length = ${wordleWordsText()}");
  // try {
  //   print(
  //       "User Display Name = ${FirebaseAuth.instance.currentUser!.displayName}");
  //   print("User Email = ${FirebaseAuth.instance.currentUser!.email}");
  //   print("User Photo Url = ${FirebaseAuth.instance.currentUser!.photoURL}");
  // } catch (e) {
  //   print("User Null");
  // }
  testDebug();
}

int wordleWordsText() {
  int res = 0;
  for (var element in questionData) {
    if (element.english.length == 5) {
      res++;
    }
    // if (element.favType == WordFavType.learned) print(element.english); //* favori tipi
  }
  return res;
}

void testDebug() {
  int wordleWordCount = 0;

  //* Word Types Counts
  int verbCount = 0;
  int nounCount = 0;
  int adjectiveCount = 0;
  int adverbCount = 0;
  int prepositionCount = 0;

  //* Word Level
  int a1Count = 0;
  int a2Count = 0;
  int b1Count = 0;
  int b2Count = 0;
  int c1Count = 0;
  int c2Count = 0;

  //*
  int learnedCount = 0;
  int favoriteCount = 0;
  int nLearnedCount = 0;

  for (var element in questionData) {
    if (element.english.length == 5) wordleWordCount++;

    //* is Favorite
    if (element.isFav) {
      favoriteCount++;
    }

    //* Word Type
    switch (element.type) {
      case WordType.verb:
        verbCount++;
        break;
      case WordType.noun:
        nounCount++;
        break;
      case WordType.adjective:
        adjectiveCount++;
        break;
      case WordType.adverb:
        adverbCount++;
        break;
      case WordType.preposition:
        prepositionCount++;
        break;
      default:
        break;
    }

    //* Word Level
    switch (element.level) {
      case WordLevel.a1:
        a1Count++;
        break;
      case WordLevel.a2:
        a2Count++;
        break;
      case WordLevel.b1:
        b1Count++;
        break;
      case WordLevel.b2:
        b2Count++;
        break;
      case WordLevel.c1:
        c1Count++;
        break;
      case WordLevel.c2:
        c2Count++;
        break;
      default:
        break;
    }

    switch (element.favType) {
      case WordFavType.learned:
        learnedCount++;
        break;
      // case WordFavType.favorite:
      //   favoriteCount++;
      //   break;
      case WordFavType.nlearned:
        nLearnedCount++;
        break;

      default:
        break;
    }
  }

  print("  ______User Info______");
  try {
    print("""
User Display Name = ${FirebaseAuth.instance.currentUser!.displayName}
User Email = ${FirebaseAuth.instance.currentUser!.email}
User UID = ${FirebaseAuth.instance.currentUser!.uid}
User Photo Url = ${FirebaseAuth.instance.currentUser!.photoURL}
        """);
    // print("User Email = ${FirebaseAuth.instance.currentUser!.email}");
    // print("User Photo Url = ${FirebaseAuth.instance.currentUser!.photoURL}");
  } catch (e) {
    print("  User Null");
  }

  print("""
  _____Local-Database______
  Is First Open = ${MainData.isFirstOpen}
  Fav List = ${MainData.favList}
  Learned List = ${MainData.learnedList}
  Is Fav List Changed = ${MainData.isFavListChanged}
  User UID = ${MainData.userUID}
  Username = ${MainData.username}
  

  ______GameModes Info______
  Total Word Length = ${questionData.length}
  Wordle Word Length = $wordleWordCount

  ______Word Fav Types______
  Learned Words = $learnedCount
  Favorite Words = $favoriteCount
  Not Learned Words = $nLearnedCount

  ______Word Types______
  Noun Length = $nounCount
  Verb Length = $verbCount
  Adjective Length = $adjectiveCount
  Adverb Length = $adverbCount
  Preposition Length = $prepositionCount

  ______Word Levels______
  A1 Length = $a1Count
  A2 Length = $a2Count
  B1 Length = $b1Count
  B2 Length = $b2Count
  C1 Length = $c1Count
  C2 Length = $c2Count""");
}
