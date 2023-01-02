import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Data {
  String english; //? ingilizce hali
  String turkish; //? turkce hali
  WordType type; //? tip'i ( isim zamir fiil vb. )
  WordLevel level; //? ingilizce level seviyesi
  String mediaLink; //? ses dosyasi linki
  WordFavType favType;
  int id;

  Data({
    required this.english,
    required this.turkish,
    required this.level,
    required this.type,
    required this.mediaLink,
    required this.id,
    this.favType = WordFavType.nlearned,
  });
}

Future<void> fLoadData({bool isInitial = false, BuildContext? context}) async {
  await Hive.initFlutter();
  MainData.localData = await Hive.openBox("SuperFastBox");

  MainData.isFavListChanged =
      MainData.localData!.get("isFavListChanged", defaultValue: true);

  MainData.isLearnedListChanged =
      MainData.localData!.get("isLearnedListChanged", defaultValue: true);

  if (FirebaseAuth.instance.currentUser != null) {
    if (MainData.isFavListChanged || MainData.isLearnedListChanged) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (MainData.isFavListChanged) {
          MainData.favList = value['favList'];
          MainData.localData!.put('favList', MainData.favList);
        }
        if (MainData.isLearnedListChanged) {
          MainData.learnedList = value["learnedList"];
          MainData.localData!.put("learnedList", MainData.learnedList);
        }
      });

      if (MainData.isFavListChanged) {
        MainData.isFavListChanged = false;
        MainData.localData!.put("isFavListChanged", MainData.isFavListChanged);
      }

      if (MainData.isLearnedListChanged) {
        MainData.isLearnedListChanged = false;
        MainData.localData!
            .put("isLearnedListChanged", MainData.isLearnedListChanged);
      }
    }

    // if (MainData.isLearnedListChanged) {

    // }
  }

  MainData.learnedList =
      MainData.localData!.get("learnedList", defaultValue: "");

  // if (MainData.localData!.get("UserUID") !=
  //     FirebaseAuth.instance.currentUser!.uid) {
  //   MainData.localData!.put("UserUID", FirebaseAuth.instance.currentUser!.uid);
  // }
  MainData.userUID = MainData.localData!.get("UserUID", defaultValue: "");

  // if (MainData.localData!.get("isFirstOpen") == null) {
  //   MainData.localData!.put("isFirstOpen", true);
  // }
  MainData.isFirstOpen =
      MainData.localData!.get("isFirstOpen", defaultValue: true);

  // if (MainData.localData!.get("isFavListChanged") == null) {
  //   MainData.localData!.put("isFavListChanged", true);
  // }

  MainData.username = MainData.localData!.get("username", defaultValue: null);

  MainData.favList = MainData.localData!.get('favList', defaultValue: "");

  print(MainData.learnedList! +
      " AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");

  //
  if (isInitial == false) {}

  if (MainData.learnedList != "") {
    // MainData.notLearnedDatas = questionData;
    MainData.learnedList!.split(" ").forEach((e) {
      questionData.elementAt(int.tryParse(e)! - 1).favType =
          WordFavType.learned;
      // MainData.notLearnedDatas!.removeAt(int.tryParse(e)! - 1);
      MainData.learnedDatas!.add(questionData.elementAt(int.tryParse(e)! - 1));
    });
    MainData.notLearnedDatas = questionData
        .where((element) => element.favType == WordFavType.nlearned)
        .toList();
  }
  if (isInitial == false) {
    BlocProvider.of<HomePageSelectedWordCubit>(context!).StateBuild();
  }
  //
}

Future<void> fResetData({required BuildContext context}) async {
  await Hive.initFlutter();
  MainData.localData = await Hive.openBox("SuperFastBox");
  //
  MainData.isFavListChanged = true;
  MainData.localData!.put("isFavListChanged", MainData.isFavListChanged);
  //
  MainData.isLearnedListChanged = true;
  MainData.localData!
      .put("isLearnedListChanged", MainData.isLearnedListChanged);
  //
  MainData.favList = "";
  MainData.localData!.put("favList", MainData.favList);
  //
  MainData.learnedList = "";
  MainData.localData!.put("learnedList", MainData.learnedList);
  //
  MainData.userUID = "";
  MainData.localData!.put("userUID", MainData.userUID);
  //
  MainData.username = "";
  MainData.localData!.put("username", MainData.username);
  //

  MainData.learnedDatas = [];
  MainData.notLearnedDatas = [];

  print(MainData.learnedList);
  BlocProvider.of<HomePageSelectedWordCubit>(context).ResetState();
}
// Future<void> a() async {

//   MainData.learnedList!.split(" ").forEach((e) {
//     questionData.elementAt(int.tryParse(e)!).favType = WordFavType.learned;
//     MainData.learnedDatas!.add(questionData.elementAt(int.tryParse(e)!));
//   });
// }

Future<void> saveSkipFirstOpen(
    {bool haveUsername = false,
    String username = "",
    required BuildContext context}) async {
  MainData.localData!.put("isFirstOpen", false);
  MainData.localData!.put("UserUID", FirebaseAuth.instance.currentUser!.uid);
  MainData.isFirstOpen = false;
  MainData.userUID = FirebaseAuth.instance.currentUser!.uid;

  if (haveUsername) {
    MainData.username = username;
    MainData.localData!.put('username', MainData.username);
  }

  await fLoadData(context: context);
  BlocProvider.of<HomePageSelectedWordCubit>(context).StateBuild();
}

class MainData {
  static Box? localData; //!
  static bool? isFirstOpen = true; //!
  static String? favList = ""; //!
  static String? learnedList = ""; //!
  static bool isFavListChanged = false; //!
  static bool isLearnedListChanged = false; //!
  static String? userUID; //!
  static String? username; //!
  static List<Data>? learnedDatas = [];
  static List<Data>? notLearnedDatas = [];
}

enum WordLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2,
}

enum WordType {
  verb, //* fiil
  noun, //* isim
  adjective, //* sıfat
  adverb, //* zarf
  preposition //* edat
}

enum WordFavType {
  learned,
  favorite,
  nlearned,
}

//! Eklenecekler
//? kelimenin index id - alfabetik olarak sıralanınca karışmasın diye ve bu index id firebaseye gönderilecek
//? kelimenin türkçe telafuz indirme linki - drive
//? kelimenin cambridge sayfasının linki
//? kelimenin kullanıldığı bir adet örnek cümle
List<Data> questionData = [
  Data(
    english: "Abolish",
    turkish: "Son Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1X7KSD2WwdBUIkLxrGzgq_zjYtKr2Ur86",
    // favType: WordFavType.learned,
    id: 1,
  ),
  Data(
    english: "Abortion",
    turkish: "Kürtaj",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CHxmAMSOcJsjAuHBm-40gi4pG8Ui5KK9",
    id: 2,
  ),
  Data(
    english: "Absence",
    turkish: "Olmayış",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1wwsuFtGZnI2KXD3DOJA0pu_NDF3v_4Sp",
    id: 3,
  ),
  Data(
    english: "Absent",
    turkish: "Yok",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GNutnkX1g8cD5WUDyJFR0XhjO1lJhM-Y",
    id: 4,
  ),

  Data(
    english: "Absorb",
    turkish: "Emmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1o5k-rnTmoSNUsZTmY5OK7Lu885vk3O70",
    id: 5,
  ),
  Data(
    english: "Abstract",
    turkish: "Soyut",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Q4Gchr5afLUDmsbV2XzVbgKC0oslM_nW",
    id: 6,
  ),
  Data(
    english: "Absurd",
    turkish: "Saçma",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YDYkuxd_8y94TU_RrSoQbPFrCqT9Hp7r",
    id: 7,
  ),
  Data(
    english: "Abuse",
    turkish: "İstismar",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
    id: 8,
  ),
  Data(
    english: "Abuse",
    turkish: "Kötüye Kullanma",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
    id: 9,
  ),
  Data(
    english: "Academy",
    turkish: "Akademi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hIvdev2HHiakazWoS6UA65hmREsrXMr0",
    id: 10,
  ),
  Data(
    english: "Accelerate",
    turkish: "Hızlanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ra16GiSp9n3rrttHJobtWR-WpJCsnElI",
    id: 11,
  ),
  Data(
    english: "Accent",
    turkish: "Aksan",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1m5wqpGWRhLCXn7O66Bl33Hv9yBIgJkGP",
    id: 12,
  ),
  Data(
    english: "Acceptance",
    turkish: "Kabul",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Bmq_8d3kvFMFpmIKJsDVxdshBWPKDJxA",
    id: 13,
  ),
  Data(
    english: "Accessible",
    turkish: "Ulaşılabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-72_Pu_AUPMV5h4siys4A3l-09IH7mrH",
    id: 14,
  ),
  Data(
    english: "Accidentally",
    turkish: "Tesadüfen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xrrGiLDkdsoDgCp4ijQy6WVNLaffU38n",
    id: 15,
  ),
  Data(
    english: "Accommodate",
    turkish: "Tedarik Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ypwijSBPabhOmn-8ALNegNOkaX5XNxox",
    id: 16,
  ),
  Data(
    english: "Accommodation",
    turkish: "İkametgah",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hfijJd1ApLg1TMiumodpVrEdoE-DQRis",
    id: 17,
  ),
  Data(
    english: "Accomplish",
    turkish: "Başarmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GzezRpMPo0Iwyj8SFRrmmnfv8K53ido9",
    id: 18,
  ),
  Data(
    english: "Accomplishment",
    turkish: "Başarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Bc_K94nj0I1IIxnxufS7GjBr_sRtWjF0",
    id: 19,
  ),
  Data(
    english: "Accordingly",
    turkish: "Buna Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1C3DyZth-MhYDGWRySDuliSvDGIfzqfUo",
    id: 20,
  ),
  Data(
    english: "Accountability",
    turkish: "Sorumluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15G27ZqvSUEtuSItNl4q-7XVek-Iem5E_",
    id: 21,
  ),
  Data(
    english: "Accountable",
    turkish: "Sorumlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eSDIPzkxJSVMalfwo3Gskd-eor2UyGQR",
    id: 22,
  ),
  Data(
    english: "Accountant",
    turkish: "Muhasebeci",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eAkmvWcHtNP9xqpFtfWlx0umOd-OCnCk",
    id: 23,
  ),
  Data(
    english: "Accumulate",
    turkish: "Biriktirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LpFhq0HI1wdSwCmYAWTBa2mI9KrMTzZE",
    id: 24,
  ),
  Data(
    english: "Accumulation",
    turkish: "Birikme",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VgbjS_XKhsZsLCBfX49ZPyKzgo1RhGSl",
    id: 25,
  ),
  Data(
    english: "Accuracy",
    turkish: "Doğruluk",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FBiO3RDQFmw1tRqJcq5I94SitQbpEHNX",
    id: 26,
  ),
  Data(
    english: "Accurately",
    turkish: "Tam Olarak",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qbXNoaWCYyrOlnIZdK0_f9l6OlZcqtNP",
    id: 27,
  ),
  Data(
    english: "Accusation",
    turkish: "Suçlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1iAc5RkzrduuKu_s_XTW1bM5AFL20V8Wr",
    id: 28,
  ),
  Data(
    english: "Accused",
    turkish: "Sanık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=1SlZXy2Mu-_QgdLGSui4F7JjEbcElm1Y-",
    id: 29,
  ),
  Data(
    english: "Acid",
    turkish: "Asit",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
    id: 30,
  ),
  Data(
    english: "Acid",
    turkish: "Asitli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
    id: 31,
  ),
  Data(
    english: "Acquisition",
    turkish: "Edinim",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1prYxOsYe-XNeIT1OPg-gqG86HKCmnzG_",
    id: 32,
  ),
  Data(
    english: "Acre",
    turkish: "Hektar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LhMM1VMEBL3YyC0AIz0sK9v1H5KMwbtM",
    id: 33,
  ),
  Data(
    english: "Activate",
    turkish: "Çalıştırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1H75OoLMtU-5upOBjtTtaa95hqetJzz3T",
    id: 34,
  ),
  Data(
    english: "Activation",
    turkish: "Aktifleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mn2sxnJLpEPDmVjqwLpHOoHHBRWC23mW",
    id: 35,
  ),
  Data(
    english: "Activist",
    turkish: "Savunucu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ohSi-FEdObYcuY49nkyUpYyLTwXQ5Otx",
    id: 36,
  ),
  Data(
    english: "Acute",
    turkish: "Şiddetli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=168F98_OljdKFjbDtKh2I2cutZx1pfGAD",
    id: 37,
  ),
  Data(
    english: "Adaptation",
    turkish: "Uyarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tZbzbHhXvk0mamiVTEjLN_pLoLUhBHCW",
    id: 38,
  ),
  Data(
    english: "Addiction",
    turkish: "Bağımlılık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xHozXnoUsjdJWYE4hXQj_14uWHl9zgN8",
    id: 39,
  ),
  Data(
    english: "Additionally",
    turkish: "İlaveten",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13Y7NwMnvDdrUMui1T2z8UydujTtj0tdL",
    id: 40,
  ),
  Data(
    english: "Adequate",
    turkish: "Yeterli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1V6oAqPDm5RPAFPaKbszffdyDcPiEUV3y",
    id: 41,
  ),
  Data(
    english: "Adequately",
    turkish: "Yeterince",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1D04jd4kM9LTrQg1KFRI4Hug9RG6-QDr1",
    id: 42,
  ),
  Data(
    english: "Adhere",
    turkish: "Yapışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=1f1DBUI-SxdqtGqbYXN4mxizkMgZL7Csc",
    id: 43,
  ),
  Data(
    english: "Adjacent",
    turkish: "Bitişik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PMipKnVa3Y_FXvc8DQIckNHe-jD7eg-R",
    id: 44,
  ),
  Data(
    english: "Adjust",
    turkish: "Ayarlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1rhwwdcigtutgbNWRCfi2JeWOHC0EGdT8",
    id: 45,
  ),
  Data(
    english: "Adjustment",
    turkish: "Ayarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1gB5EPbCnsX74H3YtfMsfBJPotMS9tyG5",
    id: 46,
  ),
  Data(
    english: "Administer",
    turkish: "İdare Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XcWpvDY7CQsqfyMLE9-w7Ed2WczIzGD2",
    id: 47,
  ),
  Data(
    english: "Administrative",
    turkish: "İdari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Sox3D78HFO0H77epmq7A0lEDSXlLeBnV",
    id: 48,
  ),
  Data(
    english: "Administrator",
    turkish: "Yönetici",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BL1X1vrqO8CR4kthwE42CmtSpdnJc06f",
    id: 49,
  ),
  Data(
    english: "Admission",
    turkish: "İtiraf",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k9ya9G5pDWS4j_f3IPTyOsjUz3vCZncp",
    id: 50,
  ),
  Data(
    english: "Adolescent",
    turkish: "Ergen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1UUp7XeVJEnjhummmy7eMa6Xdfru-V0h6",
    id: 51,
  ),
  Data(
    english: "Adoption",
    turkish: "Benimseme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13cdOhE8QuBr_pJQ_frlfFqajXQ5BFmEO",
    id: 52,
  ),
  Data(
    english: "Adverse",
    turkish: "Karşıt",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16ZNzFiIiyFxHYyErutkt--FH_Nbm75WJ",
    id: 53,
  ),
  Data(
    english: "Advocate",
    turkish: "Desteklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
    id: 54,
  ),
  Data(
    english: "Advocate",
    turkish: "Destekleyen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
    id: 55,
  ),
  Data(
    english: "Aesthetic",
    turkish: "Estetik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1DC4pM41-90ox15wAKGdzUYIXihQU6-7N",
    id: 56,
  ),
  Data(
    english: "Affection",
    turkish: "Sevgi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1f8YaqvHRZDg7m26yzgUYBcDGIvtvSAlN",
    id: 57,
  ),
  Data(
    english: "Affordable",
    turkish: "Alınabilir",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1V2wABU3iARv7GyLbSs_DZpNPWYQxmpE2",
    id: 58,
  ),
  Data(
    english: "Aftermath",
    turkish: "Sonrası",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1OKXTDV-xF4_4jsMqVo4tSHhHzc4GPZ1T",
    id: 59,
  ),
  Data(
    english: "Aged",
    turkish: "Yaşlanmış",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=182lMlz4Vyom8jEL1PzsudHeZz4DwBT5M",
    id: 60,
  ),
  Data(
    english: "Aggression",
    turkish: "Saldırganlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1h5L8fvCdHnx4YGCfq42omdZhjE0KM26W",
    id: 61,
  ),
  Data(
    english: "Agricultural",
    turkish: "Tarımsal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ROVqgV8WRKQmwn4VEsGyaGvoNy8cJ3fy",
    id: 62,
  ),
  Data(
    english: "Agriculture",
    turkish: "Ziraat",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZnvEe3iYgzFYZh7TCsSvjkdzNlHLfr76",
    id: 63,
  ),
  Data(
    english: "Aide",
    turkish: "Yardımcı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15qvk9g--wN3QXQVylRf4V9ZE7DcfmTsu",
    id: 64,
  ),
  //!
  Data(
    english: "Alert",
    turkish: "Uyarmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
    id: 65,
  ),
  Data(
    english: "Alert",
    turkish: "Uyarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
    id: 66,
  ),
  Data(
    english: "Alert",
    turkish: "Dikkatli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
    id: 67,
  ),
  Data(
    english: "Alien",
    turkish: "Uzaylı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
    id: 68,
  ),
  Data(
    english: "Alien",
    turkish: "Acayip",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
    id: 69,
  ),
  Data(
    english: "Align",
    turkish: "Hizalamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zpK5ui7GZLOxpFcANQKE8swLW8neEP4B",
    id: 70,
  ),
  Data(
    english: "Alignment",
    turkish: "Aynı Hizaya Getirmek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fOuPeaY5sWJmXoBcABL4cpZlQW_K_POr",
    id: 71,
  ),
  Data(
    english: "Alike",
    turkish: "Aynı Şekilde",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
    id: 72,
  ),
  Data(
    english: "Alike",
    turkish: "Benzer",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
    id: 73,
  ),
  Data(
    english: "Allegation",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LTG1M64j9ALtGklxnGMg8T5Uh-I0Fvzd",
    id: 74,
  ),
  Data(
    english: "Allege",
    turkish: "İddia Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dxfYHqVfsbE0XkcrHp1yFPMeFWfUonP9",
    id: 75,
  ),
  Data(
    english: "Allegedly",
    turkish: "İddiaya Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1rntCt1x7f5OcCPcvuVUQiBJgBE_xzSZA",
    id: 76,
  ),
  Data(
    english: "Alliance",
    turkish: "İttifak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T9Kp-Js7mtMVXZMDxXcF0gXN9fMuMdQg",
    id: 77,
  ),
  Data(
    english: "Allocate",
    turkish: "Ayırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_3kU1xneTzG50yEiCZbnnKOZ3Dn6t_nB",
    id: 78,
  ),
  Data(
    english: "Allocation",
    turkish: "Tahsisat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13lo2tqgcOjOJsP7b4WnhvmJ97nSDZuDl",
    id: 79,
  ),
  Data(
    english: "Allowance",
    turkish: "Ödenek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dLZbvPVfwDvp9yLDySVrmzy8BG_XyUUR",
    id: 80,
  ),
  Data(
    english: "Ally",
    turkish: "Müttefik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1A_YqDbxN7L8AfPcz6ZvW_GUdpbeuzrQo",
    id: 81,
  ),
  Data(
    english: "Alongside",
    turkish: "Yanıbaşında",
    level: WordLevel.b2,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YMuOiThlK4Kf-vn7QLSRvz_VxfuXkBxX",
    id: 82,
  ),
  Data(
    english: "Altogether",
    turkish: "Tamamen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AjCqR-hgZ7-sMvGg3LGwZ4L4rIQEidjG",
    id: 83,
  ),
  Data(
    english: "Aluminium",
    turkish: "Aliminyum",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fycLOL_C_AzK7bPYMQGUV_kqHqb3VFBv",
    id: 84,
  ),
  Data(
    english: "Amateur",
    turkish: "Amatörce",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
    id: 85,
  ),
  Data(
    english: "Amateur",
    turkish: "Acemi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
    id: 86,
  ),
  Data(
    english: "Ambassador",
    turkish: "Büyükelçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xozLYMpGOGv2Wa4I-EhOOg7nexTPKpIz",
    id: 87,
  ),
  Data(
    english: "Ambitious",
    turkish: "Hırslı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1pHYdjJjNDpVMBtQ9sJLHPDyfV4xlVqvB",
    id: 88,
  ),
  Data(
    english: "Amend",
    turkish: "Değiştirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1n16wyhtAGvuIZLmvBW8veIyIRRsO6Yak",
    id: 89,
  ),
  Data(
    english: "Amendment",
    turkish: "Değişiklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YOvEeZ0RGgrLjiflJdsOwHcZzj0VTPCK",
    id: 90,
  ),
  Data(
    english: "Amid",
    turkish: "Ortasında",
    level: WordLevel.c1,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QFssgpduG_0qwNL0ADASEH_tnx6jhs1y",
    id: 91,
  ),
  Data(
    english: "Amusing",
    turkish: "Eğlendirici",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k7wrMxxH48E5m9j84nu5zs6vfmlJpPn_",
    id: 92,
  ),
  Data(
    english: "Analogy",
    turkish: "Benzeşme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1uGfT5U92x4PfrglX0c00IUNweuhsphLX",
    id: 93,
  ),
  Data(
    english: "Analyst",
    turkish: "Analist",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_FQJZGmHmZHe-dAOcAp-SLHdDopX-Pd1",
    id: 94,
  ),
  Data(
    english: "Ancestor",
    turkish: "Ata",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12-FsuaH4vqncRlEsmuqahVfus1Em7t5f",
    id: 95,
  ),
  Data(
    english: "Anchor",
    turkish: "Çapa",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1peTLfu16JGq3Y9hF9JhgKhI-8XkyJnCb",
    id: 96,
  ),
  Data(
    english: "Angel",
    turkish: "Melek",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1o_On2Clok7-BDKVAcnxKVLnUr2MEUvwF",
    id: 97,
  ),
  Data(
    english: "Animation",
    turkish: "Canlandırma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZSdgENrjyH98VsjNoiX-OLWZ-KCIu7bE",
    id: 98,
  ),
  Data(
    english: "Annually",
    turkish: "Her Sene",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1EKUV_be5EcpFhsyv9bwo0HxbOXwA0xxm",
    id: 99,
  ),
  Data(
    english: "Anonymous",
    turkish: "Anonim",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Hljw6RhLCtz1S1nJ4QCB7Plh5caquDa-",
    id: 100,
  ),
  Data(
    english: "Anticipate",
    turkish: "Ummak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ACDE4mpbzVOCmHCxLyrAu2zMwp0HrgFi",
    id: 101,
  ),
  Data(
    english: "Anxiety",
    turkish: "Endişe",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1phLgaKB3dHEw8TDBPFH5fMqfM30S8Qoa",
    id: 102,
  ),
  //! ingilizce level düzeyine cambridge'in kendi sitesinden bakmaya başladım
  Data(
    english: "Apology",
    turkish: "Özür",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HuJ9WcnSuebEabzWoAMSXoJ7nqthukSq",
    id: 103,
  ),
  Data(
    english: "Apparatus",
    turkish: "Aygıt",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1aND-uPcx1raQoE8DJF0x-XpHLO-yp0ia",
    id: 104,
  ),
  Data(
    english: "Apparel",
    turkish: "Kıyafet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hFVXuVJY7raQtV_SM54Eqsd8cUqqmMll",
    id: 105,
  ),
  Data(
    english: "Appealing",
    turkish: "Çekici",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1n6HJ7SF7H1B-ziNWBLLxwcgFrGPiXu71",
    id: 106,
  ),
  Data(
    english: "Appetite",
    turkish: "İştah",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1WO2bDldAFTgOn645WCvzSXbwvL4oiY-6",
    id: 107,
  ),
  Data(
    english: "Applaud",
    turkish: "Alkışlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BBnzqOiUANESwnykryoi0VZCuTxyu8yn",
    id: 108,
  ),
  Data(
    english: "Applicable",
    turkish: "Uygulanabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Spv5bi8hHPtwaq1zv-2C8kWWramiSEsQ",
    id: 109,
  ),
  Data(
    english: "Applicant",
    turkish: "Başvuran",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=19hQ7Sbvbe11BxccGrVWb4ibrMLOYfhzc",
    id: 110,
  ),
  Data(
    english: "Appoint",
    turkish: "Atamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PCqWAzZt-KBgLL6my_hbVEv_vgDwOcIn",
    id: 111,
  ),
  Data(
    english: "Appreciation",
    turkish: "Takdir",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HhHktkmzHC9eRYAmQ6llSvODuXUJ84Nv",
    id: 112,
  ),
  Data(
    english: "Appropriately",
    turkish: "Uygun Şekilde",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-hp-FZ9bi30BVaN1hDZfCIf77CgrMkZ2",
    id: 113,
  ),
  Data(
    english: "Arbitrary",
    turkish: "Keyfi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hsCjBqiVMPBaZbxcINYc1REn0YTfqp5n",
    id: 114,
  ),
  Data(
    english: "Architectural",
    turkish: "Mimari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13r9EUlQWtFkZ68B0GzEvixHAzI-klS5V",
    id: 115,
  ),
  Data(
    english: "Archive",
    turkish: "Arşiv",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dtZ6j4_TVLa_UNjbclXy-hql2YC0m7Ld",
    id: 116,
  ),
  Data(
    english: "Arm",
    turkish: "Silahlandırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1cq0pDz5zr-oo5XEy5ViPvBlcg_CYkcVg",
    id: 117,
  ),
  Data(
    english: "Array",
    turkish: "Dizi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VAvDm46kcoUjQ6eyEkQRxci6fg4q8J5R",
    id: 118,
  ),
  Data(
    english: "Arrow",
    turkish: "Ok",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TEuieWo5C8zZRDGikpKQWH8wmsdiZw_g",
    id: 119,
  ),
  Data(
    english: "Articulate",
    turkish: "Açıklamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ezW-Vw5jsfte3PBjfJgxGjx8_IhNP6fF",
    id: 120,
  ),
  Data(
    english: "Artwork",
    turkish: "Sanat Eseri",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14FlMtv-T7Tt0lsxAXy4qmZK6Df_NlUXo",
    id: 121,
  ),
  Data(
    english: "Ash",
    turkish: "Kül",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Am7f_8h-f_3HpaUn0UrZ5T4RvKr0SQqo",
    id: 122,
  ),
  Data(
    english: "Aspiration",
    turkish: "Özlem",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XN5qB-SgN4kWtZpLpU-bQ4e9K0Iz62r-",
    id: 123,
  ),
  Data(
    english: "Aspire",
    turkish: "Çok İstemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15Q8yhkxuBSuKe95daTsVtINoKzWZhueQ",
    id: 124,
  ),
  Data(
    english: "Assassination",
    turkish: "Suikast",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1J4IzZUSPdpXBCmjRGGbuMGr2Q6-G__cn",
    id: 125,
  ),
  Data(
    english: "Assault",
    turkish: "Saldırı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
    id: 126,
  ),
  Data(
    english: "Assault",
    turkish: "Saldırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
    id: 127,
  ),
  Data(
    english: "Assemble",
    turkish: "Toplanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TjFaY1LJPWbCTwh6zhwtPVdrixTGSRPJ",
    id: 128,
  ),
  Data(
    english: "Assembly",
    turkish: "Toplantı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1C85ELyCBaAKGtDl6xfSJwGE98vhDH_f7",
    id: 129,
  ),
  Data(
    english: "Assert",
    turkish: "Beyan Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1a47KOAJA70ew7Fv9HvQd7b7GX8AVjIdj",
    id: 130,
  ),
  Data(
    english: "Assertion",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k7KdPEJlEIVoTwSee2HApW-A4kURVPOb",
    id: 131,
  ),
  Data(
    english: "Asset",
    turkish: "Servet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MbrZgHLiEnHe0QP00zHljf4N-2IsPso2",
    id: 132,
  ),
  Data(
    english: "Assign",
    turkish: "Görevlendirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1WgOKt7npiqZt8VS8UKYiNql2zTJGeO5Y",
    id: 133,
  ),
  Data(
    english: "Assistance",
    turkish: "Yardım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zug94ZYx1Kc9CgNbGVO0Ijtf87M6yNPn",
    id: 134,
  ),
  Data(
    english: "Assumption",
    turkish: "Varsayım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VoWsL86obLAUZTkfKPFd56gPD56o95L1",
    id: 135,
  ),
  Data(
    english: "Assurance",
    turkish: "Teminat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1w9A_ikkFG5NMlDvXGS8MoaZ8wiVICyWn",
    id: 136,
  ),
  Data(
    english: "Assure",
    turkish: "Garanti Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zv_Ji4vSnXCerkuNOyYlft_fa2Keze1m",
    id: 137,
  ),
  Data(
    english: "Astonishing",
    turkish: "Şaşırtıcı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zaks5mQ1spJloAcZ0DFfEOe_qmF6_pyw",
    id: 138,
  ),
  Data(
    english: "Asylum",
    turkish: "Akıl Hastanesi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1v34CSyrDtRE6ZMu1Ubw4NZmjjrjNGzzb",
    id: 139,
  ),
  Data(
    english: "Athletic",
    turkish: "Atletik",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1aVtGw4z_UNmqYf3kCzkEa054DEpzJWxO",
    id: 140,
  ),
  Data(
    english: "Atrocity",
    turkish: "Vahşet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13Cp8MJxNTysi3_pN6iNXPvWMoSsjWdVg",
    id: 141,
  ),
  Data(
    english: "Attachment",
    turkish: "Eklenti",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Fo5mcb-kYxAeP4gk6WIRVn4JutfU0fzT",
    id: 142,
  ),
  Data(
    english: "Attain",
    turkish: "Erişmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BaHO1wIrj6WR2Hyws1rdpYyI5g9QO46K",
    id: 143,
  ),
  Data(
    english: "Attendance",
    turkish: "Katılım",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qTcCy0KXcnuCt3KpS3J2UMc7wSVBGj4W",
    id: 144,
  ),
  Data(
    english: "Attribute",
    turkish: "Özellik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1W7Di_rIEnIMEPByA9WdfUr3x9tahcxEU",
    id: 145,
  ),
  Data(
    english: "Auction",
    turkish: "Açık Arttırma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=18rpDDws732iFAqx29co_nTBqjBFS-nNF",
    id: 146,
  ),
  Data(
    english: "Audit",
    turkish: "Denetçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13svznKutHbDQNvAuwKpg2JYY7ARB0zMo",
    id: 147,
  ),
  Data(
    english: "Authentic",
    turkish: "Orijinal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ENFuuwaMYb5Nx-V-MF1ZEKuLb9tqaKMa",
    id: 148,
  ),
  Data(
    english: "Authorize",
    turkish: "Yetki Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1wR3ouN0bZd3ZRSTJnqoOaaPgTsNAi04i",
    id: 149,
  ),
  Data(
    english: "Autonomy",
    turkish: "Özerklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1enIXA1voM-rJt75LGv57_outmpZBkWOr",
    id: 150,
  ),
  Data(
    english: "Autumn",
    turkish: "Sonbahar",
    level: WordLevel.a2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mIgLfPpRD3BHuaovORHpgIpD_0YrDe6w",
    id: 151,
  ),
  Data(
    english: "Availability",
    turkish: "Mevcut Olma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1A2ZVhBYPJmvGSSGkjrIc7ZAm0gcxFJfT",
    id: 152,
  ),
  Data(
    english: "Await",
    turkish: "Beklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AN5yPFczD-Wo6_WtuSWi7SbQ6DIE27pe",
    id: 153,
  ),
  Data(
    english: "Awareness",
    turkish: "Farkındalık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1gbf38_w59c-cIRaIhc-1atVl06T4fPLg",
    id: 154,
  ),
  Data(
    english: "Awkward",
    turkish: "Beceriksiz",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1akY2mbfG57S-0aeNklfH-GE5vddQIZ9z",
    id: 155,
  ),
  Data(
    english: "Backing",
    turkish: "Destekleme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T8-Pi3T88_cNE-SrnODNwi-1_6YI3I5_",
    id: 156,
  ),
  Data(
    english: "Backup",
    turkish: "Destek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mXH78sHGyQE_cwJuwKH2MOCR7CwA4sjx",
    id: 157,
  ),
  Data(
    english: "Badge",
    turkish: "Rozet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1kvvk41tQO57XZlSU-NCXaAR7XwgHvpps",
    id: 158,
  ),
  Data(
    english: "Bail",
    turkish: "Kefalet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AN_mXG7e-2DU280dJ8yGFyT9XS5ll4K3",
    id: 159,
  ),
  Data(
    english: "Balanced",
    turkish: "Dengeli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=142dSdyRz19B5GkKK0QiEkhiRXAmRes25",
    id: 160,
  ),
  Data(
    english: "Ballot",
    turkish: "Oylama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YDsXUR62WUIJcjT_NbjxOOidGRqcJgRp",
    id: 161,
  ),
  Data(
    english: "Bankruptcy",
    turkish: "İflas",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZlzSqUKr69hEvlciDajq4BCFZg6Ahyd2",
    id: 162,
  ),
  Data(
    english: "Banner",
    turkish: "Sancak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1vEK42YgDlG0sON0s8Mw-4xaPUG1wNj-N",
    id: 163,
  ),
  Data(
    english: "Bare",
    turkish: "Çorak",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tqeLYnjaqXyP_D0O2kVumop0ZW2QYsbY",
    id: 164,
  ),
  Data(
    english: "Barely",
    turkish: "Ancak",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PdIm1DWGwn58yJW26Pd-Vh-heO3rE8EZ",
    id: 165,
  ),
  Data(
    english: "Bargain",
    turkish: "Pazarlık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1vE3nzAOGyj3MQv9zXAw9xg05aAlT1rAz",
    id: 166,
  ),
  Data(
    english: "Barrel",
    turkish: "Namlu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1u-GnhRJoONz_ylv5KzuFUXI5J59zSIYn",
    id: 167,
  ),
  Data(
    english: "Basement",
    turkish: "Bodrum",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fLPg5mKqVFUFI_Fpfl70TcfSxb5Ij_Lv",
    id: 168,
  ),
  Data(
    english: "Basket",
    turkish: "Sepet",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1EpVDX70QTmBfucAKk-fwSMlYjfD95xCb",
    id: 169,
  ),
  Data(
    english: "Bat",
    turkish: "Yarasa",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1btyry_kKS0nrJe5YGu856aYzJgOXW9JR",
    id: 170,
  ),
  Data(
    english: "Battlefield",
    turkish: "Savaş Alanı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1pyqlIlbrUNxO5XIWlS1VugI8gHaFvo6X",
    id: 171,
  ),
  Data(
    english: "Bay",
    turkish: "Körfez",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1yEME9Rs_M-N3nGiyVSuFS60dlvx94TWh",
    id: 172,
  ),
  Data(
    english: "Beam",
    turkish: "Işın",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LDklALd36Ag8k6bOTVEvtww5dGetsmSx",
    id: 173,
  ),
  Data(
    english: "Beast",
    turkish: "Hınzır",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1O0mbOrOFGDmwmMNx962CXL7rBmpM8blK",
    id: 174,
  ),
  Data(
    english: "Behalf",
    turkish: "Temsilen",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BIrdCmTau5MM7EKHnJdtz5wVjfhvyxU0",
    id: 175,
  ),
  Data(
    english: "Behavioral",
    turkish: "Davranışsal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eVah5H0KnXnXExscxXzOKv2f5s2PGqjj",
    id: 176,
  ),
  Data(
    english: "Beloved",
    turkish: "Sevgili",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PmnPpKagQIxy70yuLji-GYHV9hEZ1jP4",
    id: 177,
  ),
  Data(
    english: "Bench",
    turkish: "Bank",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Qj8zQM_I8iSwjmoKIPRgXUHbd1blvr8y",
    id: 178,
  ),
  Data(
    english: "Benchmark",
    turkish: "Kalite Seviyesi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1J_2BkCzE8sGRNvwVkiPj92mfbNSjmF-u",
    id: 179,
  ),
  Data(
    english: "Beneath",
    turkish: "Altında",
    level: WordLevel.b1,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ron8lMD18loLTPt57hp-YUl2zABmVoZE",
    id: 180,
  ),
  Data(
    english: "Beneficial",
    turkish: "Faydalı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=17GynwUAA0hnSVvMPlFyJFl-G8HB2wY0d",
    id: 181,
  ),
  Data(
    english: "Beneficiary",
    turkish: "Yardıma Muhtaç",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ue7dmF5c37Pm-oi6ls104i5GIo0nqPHX",
    id: 182,
  ),
  Data(
    english: "Beside",
    turkish: "Yanında",
    level: WordLevel.a2,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xaPuqb7FudoToTcTG3VfZASfA5IwET0e",
    id: 183,
  ),
  Data(
    english: "Besides",
    turkish: "Ayrıca",
    level: WordLevel.b1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1bKXcqSi1vp7xTaDeS45AIZKnNXUbbe5F",
    id: 184,
  ),
  Data(
    english: "Betray",
    turkish: "İhanet Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Kzfs5KCrLKXv4FuZvSP52zprA2hKry_8",
    id: 185,
  ),
  Data(
    english: "Beverage",
    turkish: "İçecek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1lzSEhGP0OGJ-P5PH3sFxcw_tMQQL1WmQ",
    id: 186,
  ),
  Data(
    english: "Bias",
    turkish: "Önyargı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1lwIyX8hpcRubZnL1rctA4GWyvfi_UJzI",
    id: 187,
  ),
  Data(
    english: "Bid",
    turkish: "Girişim",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1gkOrmbF_VvtJBFu3N_uHvHyfFuT3CRjc",
    id: 188,
  ),
  Data(
    english: "Bind",
    turkish: "Bağlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=173GFX-VU7wrEKTfvwqQA7huiATdds8vj",
    id: 189,
  ),
  Data(
    english: "Biological",
    turkish: "Biyolojik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1wAXjQJmoLLMNYBebqToIgLXwoO0cVWIQ",
    id: 190,
  ),
  Data(
    english: "Bishop",
    turkish: "Piskopos",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13SlPmJaiAKgwDAr5ZN4vfr37FObJVZgD",
    id: 191,
  ),
  Data(
    english: "Bizarre",
    turkish: "Acayip",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HTBL2gqYybW0Y-6JvI5Q_L4Tjt8lPVLQ",
    id: 192,
  ),
  Data(
    english: "Blade",
    turkish: "Bıçak Ağzı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1d0qiUlpm-HP59HEOexQ5R2ZaRcLQzQ7x",
    id: 193,
  ),
  Data(
    english: "Blanket",
    turkish: "Battaniye",
    level: WordLevel.a2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GODnPAtsu3Hwfc0fH8bCR-Uobqi06z4_",
    id: 194,
  ),
  Data(
    english: "Blast",
    turkish: "Büyük Patlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1iFYYcm4vOknprC3fQE131-VLdso5f2ha",
    id: 195,
  ),
  Data(
    english: "Bleed",
    turkish: "Kanamak",
    level: WordLevel.b1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YTY7uve0-cp6QBbFJAyp3rXKkAvlN34m",
    id: 196,
  ),
  Data(
    english: "Blend",
    turkish: "Karıştırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv",
    id: 197,
  ),
  Data(
    english: "Blend",
    turkish: "Karışım",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv",
    id: 198,
  ),
  Data(
    english: "Bless",
    turkish: "Kutsamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MkufwyLGV5VsnbGbEXLhaVvipAD015Rh",
    id: 199,
  ),
  Data(
    english: "Blessing",
    turkish: "Nimet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hCvEMqn5jP1YOYjGloh-YW0ilf3V_YDD",
    id: 200,
  ),
  Data(
    english: "Blow",
    turkish: "Üflemek",
    level: WordLevel.b1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1l0aH9e-Y9uKXVpZCxxIiWjUNh1A8UdRV",
    id: 201,
  ),
  Data(
    english: "Boast",
    turkish: "Övünme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HQ6AoQ01KhiHtlmVVF6veiDDoOldx22v",
    id: 202,
  ),
  Data(
    english: "Bold",
    turkish: "Cesur",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1uYbm9tntPs_5bUlSplx9brJhD1kwIk1P",
    id: 203,
  ),
  Data(
    english: "Booking",
    turkish: "Rezervasyon",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZLoEgrEfWZPsPfpjJYh63QemGkYpne2T",
    id: 204,
  ),
  Data(
    english: "Boom",
    turkish: "Patlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BgeD8Iqa54x2sbM8JUpidZhNpVhhJqjp",
    id: 205,
  ),
  Data(
    english: "Boost",
    turkish: "Desteklemek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7",
    id: 206,
  ),
  Data(
    english: "Boost",
    turkish: "Geliştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7",
    id: 207,
  ),
  Data(
    english: "Bounce",
    turkish: "Zıplamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fTOhd6bAqsIg4XIlTxCWcs1rq33uvtI0",
    id: 208,
  ),
  Data(
    english: "Bound",
    turkish: "Sorumlu",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Jq6jD5WwrLp5Ia_aVs2L0Vb-a8NY785h",
    id: 209,
  ),
  Data(
    english: "Boundary",
    turkish: "Sınır",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1JCX2lhRZ6c9SPr4pP9exH20PCmz_MWxu",
    id: 210,
  ),
  Data(
    english: "Bow",
    turkish: "Selamlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1yKQ3KKeppIJ7LX8nkyMK8DmXbpbd824T",
    id: 211,
  ),
  Data(
    english: "Breach",
    turkish: "İhlal",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc",
    id: 212,
  ),
  Data(
    english: "Breach",
    turkish: "İhlal Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc",
    id: 213,
  ),
  Data(
    english: "Breakdown",
    turkish: "Zihinsel Çöküntü",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13T3nVaPk39JNeRcvPEYftKc0xPYFnMVD",
    id: 214,
  ),
  Data(
    english: "Breakthrough",
    turkish: "Önemli Buluş",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1yvM-81xf2hBrH4B17dXdAIL46ovYv1Xa",
    id: 215,
  ),
  Data(
    english: "Breed",
    turkish: "Yavrulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4",
    id: 216,
  ),
  Data(
    english: "Breed",
    turkish: "Hayvan Cinsi",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4",
    id: 217,
  ),
  Data(
    english: "Brick",
    turkish: "Tuğla",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ycw3b3MBcQlQ3NvbYkIyfnH_P_CVyBp4",
    id: 218,
  ),
  Data(
    english: "Briefly",
    turkish: "Kısaca",
    level: WordLevel.b1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ikXHbX1SUmQnNFqr821vH_sGqwK6YNLr",
    id: 219,
  ),
  Data(
    english: "Broadband",
    turkish: "Geniş Bant",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1UIk5OwyIgtXZIbooC7sm5pZzrmz3u3xs",
    id: 220,
  ),
  Data(
    english: "Broadcaster",
    turkish: "Yayıncı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=19unVvGq4AgcBxrRfm6Dn_jQ1cxZ4G-Yx",
    id: 221,
  ),
  Data(
    english: "Broadly",
    turkish: "Genel Anlamda",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xIhBnQw9Uz8RurMgGXAj8K8Kjl7Xj9QA",
    id: 222,
  ),
  Data(
    english: "Browser",
    turkish: "Tarayıcı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1IDSqeHaCS0Iiw1q6pJ4gNIDVle6kh8dj",
    id: 223,
  ),
  Data(
    english: "Brutal",
    turkish: "Vahşi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13D_5oiScD4K7RcU9DWuTNeGj6RZUH9xF",
    id: 224,
  ),
  Data(
    english: "Buck",
    turkish: "Dolar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1KFUNLfJKmIRZMZQ4ECk94FfZoHJTVtU7",
    id: 225,
  ),
  Data(
    english: "Buddy",
    turkish: "Ahbap",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1sgEfnpoxSLFdWabuoMT1gXKCintZDBuK",
    id: 226,
  ),
  Data(
    english: "Buffer",
    turkish: "Tampon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1es76q0tNqKrobQS8ecUwrLFTc0t6hi1b",
    id: 227,
  ),
  Data(
    english: "Bug",
    turkish: "Hata",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14ppKaOzDRJY6QYLmD6NwddzkbnlIpvEA",
    id: 228,
  ),
  Data(
    english: "Bulk",
    turkish: "Çok Miktarda",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1bQwd7s1Hj9mPaxnodLT4QhwYaLy7XFbI",
    id: 229,
  ),
  Data(
    english: "Burden",
    turkish: "Sorumluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_sTORdaVQZqw6lW48v2XsEV8bRX2Mc78",
    id: 230,
  ),
  Data(
    english: "Bureaucracy",
    turkish: "Bürokrasi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1w8txOnMGcBgKic4SYhiKOCsGEuJkbNK_",
    id: 231,
  ),
  Data(
    english: "Burial",
    turkish: "Defin",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1vwjx3fVB9hWpdjeU2PJSxvRdxdg0kjFT",
    id: 232,
  ),
  Data(
    english: "Burst",
    turkish: "İnfilak Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ToTR1IcAfFSTFdpxr3nJL8jsi6D6baJo",
    id: 233,
  ),
  Data(
    english: "Cabinet",
    turkish: "Kabine",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CpWGPwOwRULUOLm6ezwjmV4OWbh5bkva",
    id: 234,
  ),
  Data(
    english: "Calculation",
    turkish: "Hesaplama",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14bsKLxrxSkKNQRXk_4LxoWFgtISzlyun",
    id: 235,
  ),
  Data(
    english: "Candle",
    turkish: "Mum",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=106ZzBefaicJ44yqjxqBKjYHcB-MtKlg6",
    id: 236,
  ),
  Data(
    english: "Canvas",
    turkish: "Tuval",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MBozCbLV0r2pnH0BEsLIFqPYwAC2vNm7",
    id: 237,
  ),
  Data(
    english: "Capability",
    turkish: "Kabiliyet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1P3bZd0a7mg4Ays4iThpfNDAd61D53lLb",
    id: 238,
  ),
  Data(
    english: "Carriage",
    turkish: "Vagon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12_AJ4ZYDSguG67TuzkqSlonv6heNay74",
    id: 239,
  ),

  Data(
    english: "Carve",
    turkish: "Yontmak",
    level: WordLevel.c2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GueweJ0OQSQKRLGMflT2bLCktcfYMTjV",
    id: 240,
  ),
  Data(
    english: "Casino",
    turkish: "Kumarhane",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TALxbkbBqZz-PcsL3DOgMH7IU3md5V_1",
    id: 241,
  ),
  Data(
    english: "Castle",
    turkish: "Kale",
    level: WordLevel.a2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1i9oVMHdPxXQWS8vmlJ4LcB-vZ0l6Kj6W",
    id: 242,
  ),
  Data(
    english: "Casual",
    turkish: "Tesadüfi",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ukLwk-tHprUsDQkKzcwq-4KAD3oFxV-I",
    id: 243,
  ),
  Data(
    english: "Casualty",
    turkish: "Zayiat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1deznVgkqf1CHzDnVpRMLcKGs8XE1Y2mB",
    id: 244,
  ),
  Data(
    english: "Cater",
    turkish: "Yemek Servisi Yapmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_mpsIAe_MvBdIrsPSFdtiKtX9AlstqLv",
    id: 245,
  ),
  Data(
    english: "Cattle",
    turkish: "Sığır",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1upY1nNg15YNbeOeI4_oKlsWKxV6iSavO",
    id: 246,
  ),
  Data(
    english: "Caution",
    turkish: "Uyarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QnxjgVpmyulLN_forHNhP3yDENCx4w4u",
    id: 247,
  ),
  Data(
    english: "Cautious",
    turkish: "Dikkatli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TiX8xba2sfPMZypjJHqvlhz2mXrOoNAX",
    id: 248,
  ),
  Data(
    english: "Cave",
    turkish: "Mağara",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1W2-P4ijx7RKIgmr7d9il7xJJZXh1unAf",
    id: 249,
  ),
  Data(
    english: "Cease",
    turkish: "Durdurmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14ssnSeHVXu6i2N_HafSFHoXSoAWOZuY0",
    id: 250,
  ),
  Data(
    english: "Cemetery",
    turkish: "Mezarlık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16TCbCkr6Gv_sKgMBx3ql4Og6q93ZRJYx",
    id: 251,
  ),
  Data(
    english: "Certainty",
    turkish: "Kesinlik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1DqozJ3_ahkuCcwzOzO-96pLYFlIEISfX",
    id: 252,
  ),
  Data(
    english: "Certificate",
    turkish: "Sertifika",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ykjyNWbR78lTgsCfVQWM8NLBTlBeXtb6",
    id: 253,
  ),
  Data(
    english: "Challenging",
    turkish: "Zorlayan",
    level: WordLevel.b1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hdHidp6l3aLrTPOubRsdzVPKTRs6z18l",
    id: 254,
  ),
  Data(
    english: "Chamber",
    turkish: "Oda",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T6WaN-G_tNYTyQFGhWsYgr9nW4jrGnNM",
    id: 255,
  ),
  Data(
    english: "Championship",
    turkish: "Şampiyonluk",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zardrzj5CY6kNtpp4sR1_sWXOF4Xu7c0",
    id: 256,
  ),
  Data(
    english: "Chaos",
    turkish: "Kaos",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=18TZV1n_JvJfddNKvMYQj78dpUPR_8oy2",
    id: 257,
  ),
  Data(
    english: "Characterize",
    turkish: "Nitelendirmek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14RkBJC_XNw5veno832jXcRb4C2FEcFes",
    id: 258,
  ),
  Data(
    english: "Charm",
    turkish: "Sevimlilik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1N6A_GE4h1Qj9J8vHR0kIxlGcr5cfeelU",
    id: 259,
  ),
  Data(
    english: "Charming",
    turkish: "Cazibeli",
    level: WordLevel.b1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=17rYaeM1q9cfS1_pmy4t627dYl8lRPg-N",
    id: 260,
  ),
  Data(
    english: "Charter",
    turkish: "Tüzük",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PKs64frj_R_Nov3fDCagiXAOCcMti8YT",
    id: 261,
  ),
  Data(
    english: "Chase",
    turkish: "Kovalamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1H2SxxmJ3_Qe1AKYXiKJnj33-gpLHqPaB",
    id: 262,
  ),
  Data(
    english: "Chase",
    turkish: "Takip",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1H2SxxmJ3_Qe1AKYXiKJnj33-gpLHqPaB",
    id: 263,
  ),
  Data(
    english: "Cheek",
    turkish: "Yanak",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_EEQdDOqQF5Dx6wQdsbGZX2orOTzfqZM",
    id: 264,
  ),
  Data(
    english: "Cheer",
    turkish: "Alkışlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qoxfXDGuNl6gXTrBp38NnZGYsU7fr24o",
    id: 265,
  ),
  Data(
    english: "Choir",
    turkish: "Koro",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1x-kbgDWyCFzGv2P3REeUUqN08hC_3iCP",
    id: 266,
  ),
  Data(
    english: "Chop",
    turkish: "Doğramak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14-5GkstfmVlJ6-_FWI2QlFFZMw8TU2qW",
    id: 267,
  ),
  Data(
    english: "Chronic",
    turkish: "Kronik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1jxIef5Qqt-h_isy2-0-eQjhnBa22VD1G",
    id: 268,
  ),
  Data(
    english: "Chunk",
    turkish: "Büyük Parça",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_lrEwPB8UomuTC9w2_nPAq332PK_dZeG",
    id: 269,
  ),
  Data(
    english: "Circuit",
    turkish: "Devre",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1SDUKEETat8T6uC9Wzam7Rddyvd90r-BR",
    id: 270,
  ),
  Data(
    english: "Circulate",
    turkish: "Duyurmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1aY9V5IIjOxON84UNB0Lkc0VFIByZmB4A",
    id: 271,
  ),
  Data(
    english: "Circulation",
    turkish: "Dolaşım",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1inU8YD8cR1_bj0WaCWcBWqqNliVvfNGN",
    id: 272,
  ),
  Data(
    english: "Citizenship",
    turkish: "Vatandaşlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1upWlsotAmMJZlyGmDZA98LLLuZ2cPPnT",
    id: 273,
  ),
  Data(
    english: "Civic",
    turkish: "Kentsel",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1g4Yz7wI1a78eXMtkQ__OlUFQt9QrQR9i",
    id: 274,
  ),
  Data(
    english: "Civilian",
    turkish: "Sivil",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1b_krKp9zx_EV4duXyjFcuG8BCbLjk6XX",
    id: 275,
  ),
  Data(
    english: "Civilization",
    turkish: "Medeniyet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TaDYiHZJpqGh9p1oTAT-Cz8OUC6Mj0f-",
    id: 276,
  ),
  Data(
    english: "Clarify",
    turkish: "Açıklamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1__fkVwqNbdwoc-XTuQdfgPCCnla1PWag",
    id: 277,
  ),
  Data(
    english: "Clarity",
    turkish: "Açıklık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1OfDKuJP5ehHqI8VeUsvvnNuYxdSyVMCm",
    id: 278,
  ),
  Data(
    english: "Clash",
    turkish: "Çarpışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mAecLRHqsf9VBq5VPKk1Q91_2xCRXuuV",
    id: 279,
  ),
  Data(
    english: "Classification",
    turkish: "Sınıflandırma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1f5I5nB3lvONU_pT5W6Z_QgoMVr-Yux-2",
    id: 280,
  ),
  Data(
    english: "Classify",
    turkish: "Sınıflandırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=11GPg3TVwSftJQ_tZrk7i2LL5RRvtT1Gm",
    id: 281,
  ),
  Data(
    english: "Cliff",
    turkish: "Yamaç",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14Erwyxld537br9Ih3HZnF5eEz7oo4zbx",
    id: 282,
  ),
  Data(
    english: "Cling",
    turkish: "Tutunmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QlVDVRfQmI09e1RPRH-HXq-gAGksECVZ",
    id: 283,
  ),
  Data(
    english: "Clinic",
    turkish: "Klinik",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1lC2K1pCdPi_6cFVJkz4xWRwdrglYtgAc",
    id: 284,
  ),
  Data(
    english: "Clip",
    turkish: "Toka",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=10xFCQPNDvOEPeVSC7NKH0igVk-ZiH-Rz",
    id: 285,
  ),

  Data(
    english: "Closure",
    turkish: "Kapanma",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1lDBqugYtvwIh4_YD_cPA_lqT0wvId63p",
    id: 286,
  ),
  Data(
    english: "Cluster",
    turkish: "Küme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1NDH96T9DugwTsk8cMPHUAlSzOxy6dEsl",
    id: 287,
  ),
  Data(
    english: "Coalition",
    turkish: "Koalisyon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1W9ibqdNUHlB79JWXXUgJ49RpheZrl0Ej",
    id: 288,
  ),
  Data(
    english: "Coastal",
    turkish: "Kıyı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hO9oFgO1qwlzxYm5nnk_gA48w3QTf2m8",
    id: 289,
  ),
  Data(
    english: "Cognitive",
    turkish: "Anlama",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1p-jOoA9lhuWJwjuUHkHLdqniG-9gqOwl",
    id: 290,
  ),
  Data(
    english: "Coincide",
    turkish: "Denk Gelmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xzluMKAWxgCbDD5dlDfZWerNC3lu46rg",
    id: 291,
  ),
  Data(
    english: "Coincidence",
    turkish: "Tesadüf",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TuddkBhATi5wjb6ibLwY8gNWDEIQ7LGK",
    id: 292,
  ),
  Data(
    english: "collaborate",
    turkish: "İşbirliği Yapmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=10KaQuCJVFC-Iy9IG71yc8tCtVw_PxL_Z",
    id: 293,
  ),
  Data(
    english: "Collaboration",
    turkish: "İşbirliği",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zZYQwtxTwKoS9AEvt9_F9AjOJH_OQNwm",
    id: 294,
  ),
  Data(
    english: "Collective",
    turkish: "Toplu",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1N-X1-AHVAOjx9JgFLkgZSdsu1ac4NGrj",
    id: 295,
  ),
  Data(
    english: "Collector",
    turkish: "Toplayıcı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XMBdmpZC8aZucynYdfgGKql9q4Jn1uOB",
    id: 296,
  ),
  Data(
    english: "Collision",
    turkish: "Çarpışma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_9_PC8iNnKrZuJt4-xgh9Nzn-XFa5w8T",
    id: 297,
  ),
  Data(
    english: "Colonial",
    turkish: "Sömürgeci",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1oM4otn5-piG3v0xVfez9U4Y1kG0FUz0z",
    id: 298,
  ),
  Data(
    english: "Colony",
    turkish: "Sömürge",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MUK4KgMCH-Md9DEisFYuHCUKiCLDi3He",
    id: 299,
  ),
  Data(
    english: "Colorful",
    turkish: "Renkli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Z0mDBz8nQezBGF4g8r1mRi6pM9N1SNV4",
    id: 300,
  ),
  Data(
    english: "Columnist",
    turkish: "Köşe Yazarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LO_d20DcyIMBaOdI4Uda655sTorxbRsm",
    id: 301,
  ),
  Data(
    english: "Combat",
    turkish: "Savaş",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14fJ2qrRWNH7K0i3SLNX_OIQvQ29VQHQ5",
    id: 302,
  ),
  Data(
    english: "Combat",
    turkish: "Savaşmak",
    level: WordLevel.c2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14fJ2qrRWNH7K0i3SLNX_OIQvQ29VQHQ5",
    id: 303,
  ),
  Data(
    english: "Comic",
    turkish: "Komik",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TlBQ4_vgoohO492KbtwPxDZRpAvpwQX5",
    id: 304,
  ),
  Data(
    english: "Commander",
    turkish: "Komutan",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12ZI6W0NTJkrUaK22M98YCrFOUjDbB6mV",
    id: 305,
  ),
  Data(
    english: "Commence",
    turkish: "Başlamak",
    level: WordLevel.c2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12aHLsSyG4vNVgZBt_-x5CPoz0ryFjz2U",
    id: 306,
  ),
  Data(
    english: "Commentary",
    turkish: "Yorum",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1IbL-hjEWH47BmqrGqoJJBVea1BzzuDDm",
    id: 307,
  ),
  Data(
    english: "Commentator",
    turkish: "Yorumcu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1z0HwW8UgLPp3cHOkGTrb8cQtLj2MmHDt",
    id: 308,
  ),
  Data(
    english: "Commerce",
    turkish: "Ticaret",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZNgFDx6LIo942FrvSlGAGq3DNMdmTu_B",
    id: 309,
  ),
  Data(
    english: "Commissioner",
    turkish: "Komisyon Üyesi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1S4WLSFCN2IweTq-HoXjut_I94okqaeWK",
    id: 310,
  ),
  Data(
    english: "Commodity",
    turkish: "Ürün",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1iv6Umo7ijL_Cj9bjzB0nmGcuiOyAZRzi",
    id: 311,
  ),
  Data(
    english: "Companion",
    turkish: "Ahbap",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ax1FH2Xg0oTN0YmScGAfk8p2ftxntFhp",
    id: 312,
  ),
  Data(
    english: "Comparable",
    turkish: "Kıyaslanabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZaOzpWoEKFGf_T_3Zajs8CQEohcKm3kf",
    id: 313,
  ),
  Data(
    english: "Comparative",
    turkish: "Karşılaştırmalı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BA1K_YSnkdxR3LORap9z7rUfu503cNI7",
    id: 314,
  ),
  Data(
    english: "Compassion",
    turkish: "Merhamet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tGc6vQI3j0yuVX4qS-Ic6ZNH8nmQjtVU",
    id: 315,
  ),
  Data(
    english: "Compel",
    turkish: "Zorlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1OzUvMsuf1I5zmTGHy1HDm7VIJVGZoq0e",
    id: 316,
  ),
  Data(
    english: "Compelling",
    turkish: "Zorlayıcı",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HhhjR6CMruVInORq_8h7lPRCaWg4cYU8",
    id: 317,
  ),
  Data(
    english: "Compensate",
    turkish: "Telafi Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1kbxQDaRDxlmjLWlSH8ZWXw7O6xGaNga2",
    id: 318,
  ),
  Data(
    english: "Compensation",
    turkish: "Tazminat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=17DBuLievLiAdO9EwL46P9ziHhBGQqSJa",
    id: 319,
  ),
  Data(
    english: "Competence",
    turkish: "Ustalık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Gmn-5mgzP1KFId6oOW6L3E6ikNukuIhH",
    id: 320,
  ),
  Data(
    english: "Competent",
    turkish: "Usta",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FvnCas1aXygW06rCco85zVZgJdEoKFKj",
    id: 321,
  ),
  Data(
    english: "Compile",
    turkish: "Derlemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YnpmWaxLY3ixiqbbwWef61YjK4h0Cpy3",
    id: 322,
  ),
  Data(
    english: "Complement",
    turkish: "Tamamlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QYiEYwKTZKB9Ic_ANFNbmGhi_eC-TStE",
    id: 323,
  ),
  Data(
    english: "Completion",
    turkish: "Bitme",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zrpi8E3dMv0G_i6t02BB-BMRSpza3unn",
    id: 324,
  ),
  Data(
    english: "Complexity",
    turkish: "Karmaşıklık",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1vYfaoH7BTjNKo9G0J--wuX_LccXoK7QN",
    id: 325,
  ),
  Data(
    english: "Compliance",
    turkish: "Rıza",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1p5Em7uxgBlfMbeWRsiKjKvMw_5B9BwLU",
    id: 326,
  ),
  Data(
    english: "Complication",
    turkish: "Zorluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YD1YErX61SIU1_vAmWP0RrCZU2SQGeIJ",
    id: 327,
  ),
  Data(
    english: "Comply",
    turkish: "Uymak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-eFkGrRy5mhxkuxKdgqHWMT8ceb8OjyM",
    id: 328,
  ),
  Data(
    english: "Compose",
    turkish: "Oluşturmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zB72GGBUr4Ne0fdNPWDUHa5XLCd6IWjt",
    id: 329,
  ),
  Data(
    english: "Composer",
    turkish: "Besteci",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YkBHe-olIOoVVSHVvzp6Tq3LVN3r98jW",
    id: 330,
  ),
  Data(
    english: "Composition",
    turkish: "Beste",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CFK0O515kFyTnZT-qAcuiuy7ojB5vQ5m",
    id: 331,
  ),
  Data(
    english: "Compound",
    turkish: "Bileşim",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FRce3ycAEqzFYMQvwuksLucjc_MCAr8e",
    id: 332,
  ),
  Data(
    english: "Comprehensive",
    turkish: "Kapsamlı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=19Fm8GQDfc6rpJB283-vkjlzpWF5mClcT",
    id: 333,
  ),

  Data(
    english: "Comprise",
    turkish: "Meydana Gelmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ecF_i1s2aukhufjeL4XY9oPemKDGtA7j",
    id: 334,
  ),
  Data(
    english: "Compromise",
    turkish: "Uzlaşma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tlFiJQHxT2JHX8Xozxz-x9SFmiF0wU0C",
    id: 335,
  ),
  Data(
    english: "Compulsory",
    turkish: "Zorunlu",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PaRTrv7gMjxQdRDXmCCX_sW6Th5jOMEX",
    id: 336,
  ),
  Data(
    english: "Compute",
    turkish: "Hesaplamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1KI4DZM4pHVmOtnWbu0J_DjGNK0J7IQJH",
    id: 336,
  ),
  Data(
    english: "Conceal",
    turkish: "Gizlemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ye68Ljer6cRiCo_7XWxSo4iT2ypc_BKB",
    id: 337,
  ),
  Data(
    english: "Concede",
    turkish: "Kabul Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1uhyMtyxxq0aB2Asp9EmJnmkNA7SDcx1y",
    id: 338,
  ),
  Data(
    english: "Conceive",
    turkish: "Gebe Kalmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14fwxudDKq9ZjsgYdPlW4Yyp0Umtnkc9f",
    id: 339,
  ),
  Data(
    english: "Conception",
    turkish: "Düşünce",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1i7MlABYnc76HmyDZgeGru_jMsCte-sEv",
    id: 340,
  ),
  Data(
    english: "Concession",
    turkish: "Taviz",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1esmFppZ0NTgU9sy2kMB0Y2t3dB-ffji2",
    id: 341,
  ),
  Data(
    english: "Concrete",
    turkish: "Beton",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QyVEK7qHFzQFxFZUuFrZB9LoxLmzk7-k",
    id: 342,
  ),
  Data(
    english: "Concrete",
    turkish: "Somut",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QyVEK7qHFzQFxFZUuFrZB9LoxLmzk7-k",
    id: 343,
  ),
  Data(
    english: "Condemn",
    turkish: "Kınamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GqNvrucAcLj3X3U6h8d9Sq2c_IEx3OYw",
    id: 344,
  ),
  Data(
    english: "Confer",
    turkish: "Görüşmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1lSlYytOsVTOeU98y5t2HCuHy35CDO2Yb",
    id: 345,
  ),
  Data(
    english: "Confess",
    turkish: "İtiraf Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PP8hDLZa4XpkxOC6Csg4D39hPDcU4f9h",
    id: 346,
  ),
  Data(
    english: "Confession",
    turkish: "İtiraf",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FyxPyNWOJ6a733fLTqINd0FqBxJZqXje",
    id: 347,
  ),
  Data(
    english: "Configuration",
    turkish: "Yapılandırma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TZXveBDo--OH1v5tRYlICU5YoTNKAL4C",
    id: 348,
  ),
  Data(
    english: "Confine",
    turkish: "Sınırlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ha3k5tDUx9bPQOjpYxs8vVAIYFIXe24G",
    id: 349,
  ),
  Data(
    english: "Confirmation",
    turkish: "Doğrulama",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1d_2_fmtHAfZZeZsBJtWazMi35_7qUM5m",
    id: 350,
  ),
  Data(
    english: "Confront",
    turkish: "Karşılaşmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1RqpJrAw52_dBvc7wffNjjpaZVR7cTPtx",
    id: 351,
  ),
  Data(
    english: "Confrontation",
    turkish: "Tartışma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zrPTIy52lv2YgEdSUfC-JIgaCUA0MpL8",
    id: 352,
  ),
  Data(
    english: "Confusion",
    turkish: "Karışıklık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15yZxLlBXcYuD-P3EK2MZRnj4kH7JOj3c",
    id: 353,
  ),
  Data(
    english: "Congratulate",
    turkish: "Tebrik Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_pvqN1-8b25aJaTe0Bf0G4TC970TEwVI",
    id: 354,
  ),
  Data(
    english: "Congregation",
    turkish: "Cemaat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ymnpr6Cw2ZTLSWldulxtblNTHxeYRbdS",
    id: 355,
  ),
  Data(
    english: "Conquer",
    turkish: "Fethetmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1c1mw9Bxq9MBPxQHAUY_0rVDm-sJUrbYo",
    id: 356,
  ),
  Data(
    english: "Conscience",
    turkish: "Vicdan",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zFseFrAWuj91dqv4oXO_DQRV8gLG5trA",
    id: 357,
  ),
  Data(
    english: "Consciousness",
    turkish: "Bilinç",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14q1h9vElWgen-BF6q0KlYoi2DMMvmX5b",
    id: 358,
  ),
  Data(
    english: "Consecutive",
    turkish: "Ardışık",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1y2jQIyh0Yk_EBgAiyp22gVTwhNl16eJg",
    id: 359,
  ),
  Data(
    english: "Consensus",
    turkish: "Uzlaşma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1kh1lj8s93uEGybyGaTB0RB5fZdtNEp7R",
    id: 360,
  ),
  Data(
    english: "Consent",
    turkish: "Razı Olmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HAO6BozTVCZeZQ4_E8Fx9FyUTdmJOeqz",
    id: 361,
  ),
  Data(
    english: "Consequently",
    turkish: "Bu Nedenle",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Fm-qmphQIffX42dS8beY02HzGP80VdCP",
    id: 362,
  ),
  Data(
    english: "Conservation",
    turkish: "Koruma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BQSMXeoxtAO8y-owUqqE1QpDuL4WOOIz",
    id: 363,
  ),
  Data(
    english: "Conserve",
    turkish: "Korumak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12CIHnbEN6wPE_6tjKMwawpRWvOduIBG1",
    id: 364,
  ),
  Data(
    english: "Considerable",
    turkish: "Önemli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hfb_UMgHalUixqXlM8ZqAwFGjwiClA-Z",
    id: 365,
  ),
  Data(
    english: "Considerably",
    turkish: "Epeyce",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1az_TxxEGKYLddxYHBpnfNsK2frpZZT8b",
    id: 366,
  ),
  Data(
    english: "Consistency",
    turkish: "Tutarlılık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VJ7kTE_BTQXBa2hY6gerZg_hcBiK1TBU",
    id: 367,
  ),
  Data(
    english: "Consistently",
    turkish: "Sürekli Olarak",
    level: WordLevel.c2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FOHe7ryu8qgbvfgFO5w3WskhDc5j7XYY",
    id: 368,
  ),
  Data(
    english: "Consolidate",
    turkish: "Takviye Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zevQBl5eqoF9ht9Gk6GIS8iewL_w4C-b",
    id: 369,
  ),
  Data(
    english: "Conspiracy",
    turkish: "Komplo",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1rTL9M1xOcenAY7nWrcvwJd6TWtAOa6LV",
    id: 370,
  ),
  Data(
    english: "Constitute",
    turkish: "Oluşturmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-rKIotNRiUA_cgrkLMBnqnZnndpU11q9",
    id: 371,
  ),
  Data(
    english: "Constitution",
    turkish: "Anayasa",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=176AGMCvghPUPM7YNkjHT3oS9XgAkZKHN",
    id: 372,
  ),
  Data(
    english: "Constitutional",
    turkish: "Anayasal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-eP7Fm7lvXRDpTPX64MzBN2hym2QQDN6",
    id: 373,
  ),
  Data(
    english: "Constraint",
    turkish: "Kısıtlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=133PnzCu5E8o1dnnD_ejAn_IxRsh0kPPA",
    id: 374,
  ),
  Data(
    english: "Consult",
    turkish: "Danışmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=11qibIGE5TxoovfkwblKPxTIEPKcem2jV",
    id: 375,
  ),
  Data(
    english: "Consultant",
    turkish: "Danışman",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ekH1i4u0NiMFtt97oFrPeKX96PHDQPlN",
    id: 376,
  ),
  Data(
    english: "Consultation",
    turkish: "Danışma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16LSztL75AY63_hKVvh2d4SJCgHhB-Wqi",
    id: 377,
  ),
  Data(
    english: "Consumption",
    turkish: "Tüketim",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13a_tW9wBRWEKkJ7A-elZ6P6QGxX6gOoy",
    id: 378,
  ),
  Data(
    english: "Contemplate",
    turkish: "Düşünmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1z1miwThO4FpcWgjy2imhnPXOJBnOGn9I",
    id: 379,
  ),
  Data(
    english: "Contempt",
    turkish: "Küçümseme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1q4eewQjezcszZOAkj2TvMxVOFs4ZqIe2",
    id: 380,
  ),
  Data(
    english: "Contend",
    turkish: "İddia Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1o6d1sWicMEqla3qxyaflwbODPxIbI5AQ",
    id: 381,
  ),
  Data(
    english: "Contender",
    turkish: "Yarışmacı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1f9SRK6IQ08zPDkAz4R0VHzb-wnwTc9Rd",
    id: 382,
  ),
  Data(
    english: "Content",
    turkish: "İçerik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xQxTid5Kyo2OknAFHZTaRbPw9sZ27AKb",
    id: 383,
  ),
  Data(
    english: "Contention",
    turkish: "Çekişme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MSp9F-wt7M45Qi0C82EttSWcUhi8zcCY",
    id: 384,
  ),
  Data(
    english: "Continually",
    turkish: "Sürekli Olarak",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1G57p2xWiz2_stUyDy70AFVN4p81qdTL9",
    id: 385,
  ),
  Data(
    english: "Contractor",
    turkish: "Müteahhit",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13HbUjmJZDp42GEpBqYOMlzHFuWTEJePJ",
    id: 386,
  ),
  Data(
    english: "Contradiction",
    turkish: "Çelişki",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qCYN4wJ9Rd17Qe0c8y-0d5cnkHxtvyad",
    id: 387,
  ),
  Data(
    english: "Contrary",
    turkish: "Zıt",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1evN3PccW7s9lrVvyArDZSX7WQ-jvHnZa",
    id: 388,
  ),
  Data(
    english: "Contrary",
    turkish: "Aksine",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1evN3PccW7s9lrVvyArDZSX7WQ-jvHnZa",
    id: 389,
  ),
  Data(
    english: "Contributor",
    turkish: "Destekçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Y4QHQjaD-brNc05v9gPETDMX2Nhtzo6c",
    id: 390,
  ),
  Data(
    english: "Controversial",
    turkish: "Tartışmalı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eXquZ5dWVzx9Jh3yoG7VA5OyMKiZUgQc",
    id: 391,
  ),
  Data(
    english: "Controversy",
    turkish: "Tartışma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1coH7EsUG7jINutuZdQGT20el-LcEG4Vq",
    id: 392,
  ),
  Data(
    english: "Convenience",
    turkish: "Kolaylık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AuRkdqRM4agifn-qg2kCHxrZoi-taV26",
    id: 393,
  ),
  Data(
    english: "Convention",
    turkish: "Gelenek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1nn5Xy1ICMtKYvlF3ukJ7gHJVX0TNT4SD",
    id: 394,
  ),
  Data(
    english: "Conventional",
    turkish: "Geleneksel",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1bZsjAK4bBm4Uwr6kcIXH6zBtI82ebKbV",
    id: 395,
  ),
  Data(
    english: "Conversion",
    turkish: "Dönüşüm",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1glUX2-DpE9JFJdLOm7rK2R0RZPtj29Gr",
    id: 396,
  ),
  Data(
    english: "Convey",
    turkish: "Nakletmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1EHDJC8BkOXOQzWcWinyhNx29vCXfqSZY",
    id: 397,
  ),
  Data(
    english: "Convict",
    turkish: "Suçlu Bulmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tD-twmKQYRPBjPyNBqPaht_6J9su5h2b",
    id: 398,
  ),
  Data(
    english: "Convict",
    turkish: "Suçlu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tD-twmKQYRPBjPyNBqPaht_6J9su5h2b",
    id: 399,
  ),
  Data(
    english: "Conviction",
    turkish: "Mahkumiyet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1RbwMM6gDPdvh26N23BvnkeUe6SPHX-Ta",
    id: 400,
  ),
  Data(
    english: "Convincing",
    turkish: "İkna Edici",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15pc_v-RqUegDtRHs34b9l9mVxk5xibOm",
    id: 401,
  ),
  Data(
    english: "Cooperate",
    turkish: "İşbirliği Yapmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1X2dMrh92NZdsebDshSrpkVymjCoO7EMT",
    id: 402,
  ),
  Data(
    english: "Cooperative",
    turkish: "Ortak Çalışmak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1EfRhbr6daV5lPN47JQptkWnkuj1AzIFI",
    id: 403,
  ),
  Data(
    english: "Coordinate",
    turkish: "Koordine Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xuDBC3Z_8zvd9n_apbsJV0eevwUYpKGN",
    id: 404,
  ),
  Data(
    english: "Coordination",
    turkish: "Kordinasyon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XzCopKpAW7CZr7bzAKm38ms6-8D4iGQP",
    id: 405,
  ),
  Data(
    english: "Cop",
    turkish: "Polis",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ijub-xHVjF09OVVL-buLDJkTDOjfYlHw",
    id: 406,
  ),
  Data(
    english: "Cope",
    turkish: "Başa Çıkmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Wzs4wgSNQFijfpiiYxxn0yDoPebYqihp",
    id: 407,
  ),
  Data(
    english: "Copper",
    turkish: "Bakır",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=19ZZ4lXEqzcaOVy8XzLSPlh3iPkJJpYqN",
    id: 408,
  ),
  Data(
    english: "Copyright",
    turkish: "Telif Hakkı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=18SeF0WvxR_ExExMfFA0M9rAsQive0Mnt",
    id: 409,
  ),
  Data(
    english: "Corporation",
    turkish: "Şirket",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CBcC_e56yhk8Xt-YqIIDivoz7IZjqdIV",
    id: 410,
  ),
  Data(
    english: "Correction",
    turkish: "Düzeltme",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1NkANUjBZfv_fw2JAAIZvg-qNLs2QNaox",
    id: 411,
  ),
  Data(
    english: "Correlate",
    turkish: "İlişkisi Olmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fN5LeujTj_TxrOeypzFutVo8dSa5Rr1_",
    id: 412,
  ),
  Data(
    english: "Correlation",
    turkish: "İlişkilendirme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eovXpOPLnSdRu7XmsaVxI7qtLkXdqKfe",
    id: 413,
  ),
  Data(
    english: "Correspond",
    turkish: "Yazışmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1KCl646NN_huDg4803ffLw-r9GdljoiRa",
    id: 414,
  ),
  Data(
    english: "Correspondence",
    turkish: "Yazışma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CVJHMi-ePscAEAk4U2yVotlMGvtQhM8H",
    id: 415,
  ),
  Data(
    english: "Correspondent",
    turkish: "Muhabir",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1uUb-zznqMEYR0PWMll5AZmjKycsK4k_J",
    id: 416,
  ),
  Data(
    english: "Corresponding",
    turkish: "Benzer",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xNdPjqeVxsGMUv0Q0v4MIM-GdXk7SYu1",
    id: 417,
  ),
  Data(
    english: "Corridor",
    turkish: "Koridor",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1K3Lr8r7s8yNqgnsJtafNSgWPkWqEUBsl",
    id: 418,
  ),
  Data(
    english: "Corrupt",
    turkish: "Yozlaşmak",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1pjIXZ3kSVsX9owONowD68M3g-4-o6oAp",
    id: 419,
  ),
  Data(
    english: "Corruption",
    turkish: "Yolsuzluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1I4H0bOuIqGrJs8R89hIi6-sflmBJ9VLf",
    id: 420,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 421,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 422,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 423,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 424,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 425,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 426,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 427,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 428,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 429,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 430,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 431,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 432,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 433,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 434,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 435,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 436,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 437,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 438,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 439,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 440,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 441,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 442,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 443,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 444,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 445,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 446,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 447,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 448,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 449,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 450,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 451,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 452,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 453,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 454,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 455,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 456,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 457,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 458,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 459,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 460,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 461,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 462,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 463,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 464,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 465,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 466,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 467,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 468,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 469,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 470,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 471,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 472,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 473,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 474,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 475,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 476,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 477,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 478,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 479,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 480,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 481,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 482,
  ),
  Data(
    english: "EN",
    turkish: "TR",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 483,
  ),
];
