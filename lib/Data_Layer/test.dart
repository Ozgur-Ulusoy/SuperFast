import 'package:firebase_auth/firebase_auth.dart';

import 'data.dart';

void Test() {
  print("Total Words Length = ${questionData.length}");
  print("Wordle Words Text Length = ${wordleWordsText()}");
  try {
    print(
        "User Display Name = ${FirebaseAuth.instance.currentUser!.displayName}");
    print("User Email = ${FirebaseAuth.instance.currentUser!.email}");
    print("User Photo Url = ${FirebaseAuth.instance.currentUser!.photoURL}");
  } catch (e) {
    print("User Null");
  }
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
