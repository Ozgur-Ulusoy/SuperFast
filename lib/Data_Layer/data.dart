import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class Data {
  String english; //? ingilizce hali
  String turkish; //? turkce hali
  WordType type; //? tip'i ( isim zamir fiil vb. )
  WordLevel level; //? ingilizce level seviyesi
  String?
      mediaLink; //! Kullanılmıyor - ses dosyasi linki - suan kullanılmıyor aktif olarak
  // String mediaLinkTr; //! Kullanılmıyor - türkce ses dosyasi linki
  WordFavType favType;
  bool isFav; //? favori mi
  int id; //? listedeki id si
  String link; //! Kullanılmıyor - cambdridge kelime sayfasının linki
  String exampleSentence; //? örnek cümle

  Data({
    required this.english,
    required this.turkish,
    required this.level,
    required this.type,
    this.mediaLink,
    required this.id,
    // this.mediaLinkTr = "Tr Link", //! REQUIRED
    this.favType = WordFavType.nlearned,
    this.isFav = false,
    this.link = "Çeviri Sayfasına Git", //! REQUIRED
    this.exampleSentence = "Example Sentence", //! REQUIRED
  });
}

Future<String> getSoundUrl(String en) async {
  try {
    var url = Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$en');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      String result = "";
      List map = jsonResponse[0]['phonetics'];
      for (var i = 0; i < map.length; i++) {
        if (map[i]["audio"] != "") {
          result = map[i]["audio"];
          break;
        }
      }
      print(result);
      return result;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return "";
    }
  } on Exception {
    // TODO
    return "";
  }
}

Future<void> fLoadSvgPictures() async {
  await Future.wait([
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/Group 7.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/gamepadicon.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/firstplayphoto.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/secondplayphoto.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/thirdplayphoto.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/fourthplayphoto.svg",
      ),
      null,
    ),
    precachePicture(
      ExactAssetPicture(
        SvgPicture.svgStringDecoderBuilder, // See UPDATE below!
        "assets/images/playSoundVector.svg",
      ),
      null,
    ),
    // other SVGs or images here
  ]);
}

Future<void> fLoadData({BuildContext? context}) async {
  // bool isInitial = false,  parametre
  await Hive.initFlutter();
  MainData.localData = await Hive.openBox(KeyUtils.boxName);

  //! Settings
  MainData.isSoundOn =
      MainData.localData!.get(KeyUtils.isSoundOnKey, defaultValue: true);

  MainData.getNotification = MainData.localData!
      .get(KeyUtils.isGetNotificationOnKey, defaultValue: true);

  MainData.removeControlButtonEngame = MainData.localData!
      .get(KeyUtils.isEngameControlButtonOnKey, defaultValue: false);

  if (await Permission.ignoreBatteryOptimizations.isGranted == true) {
    MainData.localData!.put(KeyUtils.isBatteryOptimizeDisabledKey, true);
  } else {
    MainData.localData!.put(KeyUtils.isBatteryOptimizeDisabledKey, false);
  }

  MainData.isBatteryOptimizeDisabled = MainData.localData!
      .get(KeyUtils.isBatteryOptimizeDisabledKey, defaultValue: false);

  MainData.isAutoRestartEnabledForBackground = MainData.localData!
      .get(KeyUtils.isAutoRestartEnabledForBackgroundKey, defaultValue: false);

  MainData.showAlwaysDailyWord = MainData.localData!
      .get(KeyUtils.isShowDailyWordOnKey, defaultValue: true);

  MainData.homePageNotifiAlert = MainData.localData!
      .get(KeyUtils.isShowHomePageNotifiAlertOnKey, defaultValue: true);

  // !
  MainData.isFavListChanged =
      MainData.localData!.get(KeyUtils.isFavListChangedKey, defaultValue: true);

  MainData.isLearnedListChanged = MainData.localData!
      .get(KeyUtils.isLearnedListChangedKey, defaultValue: true);

  try {
    if (FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.isAnonymous) {
      if (MainData.isFavListChanged || MainData.isLearnedListChanged) {
        await FirebaseFirestore.instance
            .collection(KeyUtils.usersCollectionKey)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then(
          (value) {
            if (MainData.isFavListChanged) {
              MainData.favList = value[KeyUtils.favListValueKey];
              MainData.localData!.put('favList', MainData.favList);
              print("Favlist - Firebaseden çekildi");
            }
            if (MainData.isLearnedListChanged) {
              MainData.learnedList = value[KeyUtils.learnedListValueKey];
              MainData.localData!
                  .put(KeyUtils.learnedListValueKey, MainData.learnedList);
              print("LearnedList - Firebaseden çekildi");
            }
          },
        );

        if (MainData.isFavListChanged) {
          MainData.isFavListChanged = false;
          MainData.localData!
              .put(KeyUtils.isFavListChangedKey, MainData.isFavListChanged);
        }

        if (MainData.isLearnedListChanged) {
          MainData.isLearnedListChanged = false;
          MainData.localData!.put(
              KeyUtils.isLearnedListChangedKey, MainData.isLearnedListChanged);
        }
      }
    }
  } catch (e) {}

  MainData.learnedList =
      MainData.localData!.get(KeyUtils.learnedListValueKey, defaultValue: "");

  MainData.userUID =
      MainData.localData!.get(KeyUtils.userUIDKey, defaultValue: "");

  MainData.isFirstOpen =
      MainData.localData!.get(KeyUtils.isFirstOpenKey, defaultValue: true);

  MainData.username =
      MainData.localData!.get(KeyUtils.usernameKey, defaultValue: null);

  MainData.favList =
      MainData.localData!.get(KeyUtils.favListValueKey, defaultValue: "");

  if (MainData.learnedList != "") {
    String data = MainData.localData!.get(KeyUtils.learnedListValueKey);
    data.trim().split(" ").forEach((e) {
      // questionData.elementAt(int.tryParse(e)! - 1).favType =
      //     WordFavType.learned;
      // MainData.learnedDatas!.add(questionData.elementAt(int.tryParse(e)! - 1));
      Data data =
          questionData.where((element) => element.id == int.tryParse(e)).first;
      data.favType = WordFavType.learned;
      MainData.learnedDatas!.add(data);
    });
  }

  if (MainData.favList != "") {
    String data = MainData.localData!.get(KeyUtils.favListValueKey);
    data.trim().split(" ").forEach((e) {
      // questionData.elementAt(int.tryParse(e)! - 1).isFav = true;
      // MainData.favDatas!.add(questionData.elementAt(int.tryParse(e)! - 1));
      Data data =
          questionData.where((element) => element.id == int.tryParse(e)).first;
      data.isFav = true;
      MainData.favDatas!.add(data);
    });
  }
  MainData.notLearnedDatas = questionData
      .where((element) => element.favType == WordFavType.nlearned)
      .toList();

  // MainData.dailyData = (MainData.learnedDatas! + MainData.notLearnedDatas!)
  //     .where((element) =>
  //         element.id ==
  //         MainData.localData!.get(KeyUtils.dailyWordIdKey, defaultValue: 1))
  //     .first;

  // CONTINUE HERE
  // offlineken oynanılan ve kazanılan rekorlar için 4 ayrı değişken olustur true oldugunda kaydedilen local degerler firebase'e aktarılacak

  //! değişen değerler direkt olarak firebase'ye aktarılacak

  MainData.isEngameGameRecordChanged = MainData.localData!
      .get(KeyUtils.isEngameGameRecordChangedKey, defaultValue: true);

  MainData.isSoundGameRecordChanged = MainData.localData!
      .get(KeyUtils.isSoundGameRecordChangedKey, defaultValue: true);

  MainData.isWordleGameRecordChanged = MainData.localData!
      .get(KeyUtils.isWordleGameRecordChangedKey, defaultValue: true);

  MainData.isLetterGameRecordChanged = MainData.localData!
      .get(KeyUtils.isLetterGameRecordChangedKey, defaultValue: true);

  try {
    if (FirebaseAuth.instance.currentUser != null &&
        !FirebaseAuth.instance.currentUser!.isAnonymous) {
      if (MainData.isEngameGameRecordChanged ||
          MainData.isLetterGameRecordChanged ||
          MainData.isSoundGameRecordChanged ||
          MainData.isWordleGameRecordChanged) {
        Map<String, dynamic> map = await FirebaseFirestore.instance
            .collection(KeyUtils.usersCollectionKey)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get()
            .then(
              (value) => value[KeyUtils.gameRecordsMapKey],
            );
        print(map);

        MainData.engameGameRecord = map[KeyUtils.engameGameRecordKey];
        MainData.soundGameRecord = map[KeyUtils.soundGameRecordKey];
        MainData.wordleGameRecord = map[KeyUtils.wordleGameRecordKey];
        MainData.letterGameRecord = map[KeyUtils.letterGameRecordKey];
        await MainData.localData!
            .put(KeyUtils.engameGameRecordKey, MainData.engameGameRecord);
        await MainData.localData!
            .put(KeyUtils.soundGameRecordKey, MainData.soundGameRecord);
        await MainData.localData!
            .put(KeyUtils.wordleGameRecordKey, MainData.wordleGameRecord);
        await MainData.localData!
            .put(KeyUtils.letterGameRecordKey, MainData.letterGameRecord);
        MainData.isEngameGameRecordChanged = false;
        MainData.isSoundGameRecordChanged = false;
        MainData.isWordleGameRecordChanged = false;
        MainData.isLetterGameRecordChanged = false;
        await MainData.localData!
            .put(KeyUtils.isEngameGameRecordChangedKey, false);
        await MainData.localData!
            .put(KeyUtils.isSoundGameRecordChangedKey, false);
        await MainData.localData!
            .put(KeyUtils.isWordleGameRecordChangedKey, false);
        await MainData.localData!
            .put(KeyUtils.isLetterGameRecordChangedKey, false);
      }
    }
  } catch (e) {}

  MainData.engameGameRecord =
      MainData.localData!.get(KeyUtils.engameGameRecordKey, defaultValue: 0);
  // MainData.isEngameGameRecordChanged = MainData.localData!
  //     .get(KeyUtils.isEngameGameRecordChangedKey, defaultValue: true);

  MainData.soundGameRecord =
      MainData.localData!.get(KeyUtils.soundGameRecordKey, defaultValue: 0);
  // MainData.isSoundGameRecordChanged = MainData.localData!
  //     .get(KeyUtils.isSoundGameRecordChangedKey, defaultValue: true);

  MainData.wordleGameRecord =
      MainData.localData!.get(KeyUtils.wordleGameRecordKey, defaultValue: 0);
  // MainData.isWordleGameRecordChanged = MainData.localData!
  //     .get(KeyUtils.isWordleGameRecordChangedKey, defaultValue: true);

  MainData.letterGameRecord =
      MainData.localData!.get(KeyUtils.letterGameRecordKey, defaultValue: 0);
  // MainData.isLetterGameRecordChanged = MainData.localData!
  //     .get(KeyUtils.isLetterGameRecordChangedKey, defaultValue: true);
  // print("-----------------------");
  // print(MainData.engameGameRecord);
  // print(MainData.soundGameRecord);
  // print(MainData.wordleGameRecord);
  // print(MainData.letterGameRecord);
  // print(MainData.isEngameGameRecordChanged);
  // print(MainData.isSoundGameRecordChanged);
  // print(MainData.isWordleGameRecordChanged);
  // print(MainData.isLetterGameRecordChanged);
  // print("-----------------------");

  // int randomIndex =
  //     MainData.localData!.get(KeyUtils.dailyWordIdKey, defaultValue: 1);
  // List<Data> allList = MainData.learnedDatas! + MainData.notLearnedDatas!;
  // MainData.dailyData =
  //     allList.where((element) => element.id == randomIndex).first;
}

Future<void> fResetData({required BuildContext context}) async {
  await Hive.initFlutter();
  MainData.localData = await Hive.openBox(KeyUtils.boxName);

  MainData.isFavListChanged = true;
  MainData.localData!
      .put(KeyUtils.isFavListChangedKey, MainData.isFavListChanged);
  //
  MainData.isLearnedListChanged = true;
  MainData.localData!
      .put(KeyUtils.isLearnedListChangedKey, MainData.isLearnedListChanged);
  //
  MainData.favList = "";
  MainData.localData!.put(KeyUtils.favListValueKey, MainData.favList);
  //
  MainData.learnedList = "";
  MainData.localData!.put(KeyUtils.learnedListValueKey, MainData.learnedList);
  //
  MainData.userUID = "";
  MainData.localData!.put(KeyUtils.userUIDKey, MainData.userUID);
  //
  MainData.username = "";
  MainData.localData!.put(KeyUtils.usernameKey, MainData.username);
  //

  MainData.learnedDatas = [];
  MainData.favDatas = [];
  MainData.notLearnedDatas = [];

  MainData.engameGameRecord = 0;
  MainData.localData!
      .put(KeyUtils.engameGameRecordKey, MainData.engameGameRecord);
  MainData.isEngameGameRecordChanged = true;
  MainData.localData!.put(KeyUtils.isEngameGameRecordChangedKey, true);
  //
  MainData.soundGameRecord = 0;
  MainData.localData!
      .put(KeyUtils.soundGameRecordKey, MainData.soundGameRecord);
  MainData.isSoundGameRecordChanged = true;
  MainData.localData!.put(KeyUtils.isSoundGameRecordChangedKey, true);
  //
  MainData.wordleGameRecord = 0;
  MainData.localData!
      .put(KeyUtils.wordleGameRecordKey, MainData.wordleGameRecord);
  MainData.isWordleGameRecordChanged = true;
  MainData.localData!.put(KeyUtils.isWordleGameRecordChangedKey, true);
  //
  MainData.letterGameRecord = 0;
  MainData.localData!
      .put(KeyUtils.letterGameRecordKey, MainData.letterGameRecord);
  MainData.isLetterGameRecordChanged = true;
  MainData.localData!.put(KeyUtils.isLetterGameRecordChangedKey, true);

  print(MainData.learnedList);

  //! settings
  MainData.isSoundOn = true;
  await MainData.localData!.put(KeyUtils.isSoundOnKey, true);
  MainData.getNotification = true;
  await MainData.localData!.put(KeyUtils.isGetNotificationOnKey, true);
  MainData.removeControlButtonEngame = false;
  await MainData.localData!.put(KeyUtils.isEngameControlButtonOnKey, false);

  if (await Permission.ignoreBatteryOptimizations.isGranted == true) {
    MainData.localData!.put(KeyUtils.isBatteryOptimizeDisabledKey, true);
  } else {
    MainData.localData!.put(KeyUtils.isBatteryOptimizeDisabledKey, false);
  }

  await MainData.localData!.put(KeyUtils.isBatteryOptimizeDisabledKey, false);

  await MainData.localData!
      .put(KeyUtils.isAutoRestartEnabledForBackgroundKey, false);

  try {
    await FirebaseMessaging.instance
        .subscribeToTopic(KeyUtils.notificationTopicKey);
  } catch (e) {}

  MainData.showAlwaysDailyWord = true;
  await MainData.localData!.put(KeyUtils.isShowDailyWordOnKey, true);
  // MainData.
  MainData.homePageNotifiAlert = true;
  await MainData.localData!.put(KeyUtils.isShowHomePageNotifiAlertOnKey, true);

  MainData.isFirstOpen = true;
  await MainData.localData!.put(KeyUtils.isFirstOpenKey, true);

  BlocProvider.of<HomePageSelectedWordCubit>(context).ResetState();
}

Future<void> saveSkipFirstOpen(
    {bool haveUsername = false,
    String username = "",
    required BuildContext context}) async {
  MainData.localData!.put(KeyUtils.isFirstOpenKey, false);
  MainData.localData!
      .put(KeyUtils.userUIDKey, FirebaseAuth.instance.currentUser!.uid);
  MainData.isFirstOpen = false;
  MainData.userUID = FirebaseAuth.instance.currentUser!.uid;

  if (haveUsername) {
    MainData.username = username;
    MainData.localData!.put(KeyUtils.usernameKey, MainData.username);
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
  static List<Data>? favDatas = [];
  static Data? dailyData;

  //! oyunlarla ilgili
  static int? engameGameRecord = 0;
  static bool isEngameGameRecordChanged = false;
  static int? soundGameRecord = 0;
  static bool isSoundGameRecordChanged = false;
  static int? wordleGameRecord = 0;
  static bool isWordleGameRecordChanged = false;
  static int? letterGameRecord = 0;
  static bool isLetterGameRecordChanged = false;

  //! settings
  static bool isSoundOn = true; //? ses
  static bool getNotification = true; //? bildirim
  static bool removeControlButtonEngame =
      false; //? engamede kontrol butonunu kaldır
  static bool showAlwaysDailyWord =
      true; //? her zaman ilk açılışta günlük kelimeyi göster
  static bool isBatteryOptimizeDisabled =
      false; //? pil optimize ayarı yapıldı mı
  static bool isAutoRestartEnabledForBackground =
      false; //? arkaplanda otomatik yeniden başlatma ayarı yapıdlı mı - yapıldıgı kontrol edilemiyor
  static bool homePageNotifiAlert = true; //? anasayfada bildirim uyarısı

  //! cok önemli degil
  static bool isShowedDailyWord = false;
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
    turkish: "Varlık",
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
    turkish: "Tamamlanma",
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
    english: "Costly",
    turkish: "Pahalı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 421,
  ),
  Data(
    english: "Councillor",
    turkish: "Kurul Üyesi",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 422,
  ),
  Data(
    english: "Counsellor",
    turkish: "Danışman",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 423,
  ),
  Data(
    english: "Counter",
    turkish: "Tezgah",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 424,
  ),
  Data(
    english: "Counter",
    turkish: "Karşılık Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 425,
  ),
  Data(
    english: "Counterpart",
    turkish: "Meslektaş",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 426,
  ),
  Data(
    english: "Countless",
    turkish: "Sayısız",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 427,
  ),
  Data(
    english: "Coup",
    turkish: "Darbe",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 428,
  ),

  Data(
    english: "Courtesy",
    turkish: "Nezaket",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 429,
  ),
  Data(
    english: "Coverage",
    turkish: "Kapsama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 430,
  ),
  Data(
    english: "Cowboy",
    turkish: "Kovboy",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 431,
  ),
  Data(
    english: "Crack",
    turkish: "Çatlak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 432,
  ),
  Data(
    english: "Crack",
    turkish: "Kaliteli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 433,
  ),
  Data(
    english: "Craft",
    turkish: "Hüner",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 434,
  ),
  Data(
    english: "Crawl",
    turkish: "Emeklemek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 435,
  ),
  Data(
    english: "Creativity",
    turkish: "Yaratıcılık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 436,
  ),
  Data(
    english: "Creator",
    turkish: "Yaratıcı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 437,
  ),
  Data(
    english: "Credibility",
    turkish: "Güvenilirlik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 438,
  ),
  Data(
    english: "Credible",
    turkish: "Güvenilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 439,
  ),
  Data(
    english: "Creep",
    turkish: "Sızmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 440,
  ),
  Data(
    english: "Critique",
    turkish: "Eleştiri",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 441,
  ),
  Data(
    english: "Crown",
    turkish: "Taç",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 442,
  ),
  Data(
    english: "Crude",
    turkish: "Ham",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 443,
  ),
  Data(
    english: "Cruise",
    turkish: "Gemi Seyahati",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 444,
  ),
  Data(
    english: "Crush",
    turkish: "Ezmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 445,
  ),
  Data(
    english: "Cue",
    turkish: "İpucu",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 446,
  ),
  Data(
    english: "Cult",
    turkish: "Mezhep",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 447,
  ),
  Data(
    english: "Cultivate",
    turkish: "Tarlayı Sürmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 448,
  ),
  Data(
    english: "Curiosity",
    turkish: "Merak",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 449,
  ),
  Data(
    english: "Curious",
    turkish: "Meraklı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 450,
  ),
  Data(
    english: "Curriculum",
    turkish: "Müfredat",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 451,
  ),
  Data(
    english: "Custody",
    turkish: "Gözaltı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 452,
  ),
  Data(
    english: "Cute",
    turkish: "Şirin",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 453,
  ),
  Data(
    english: "Cutting",
    turkish: "Kırıcı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 454,
  ),
  Data(
    english: "Cynical",
    turkish: "Kötümser",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 455,
  ),
  Data(
    english: "Dairy",
    turkish: "Süthane",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 456,
  ),
  Data(
    english: "Dam",
    turkish: "Baraj",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 457,
  ),
  Data(
    english: "Damage",
    turkish: "Hasar",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 458,
  ),
  Data(
    english: "Dare",
    turkish: "Cürret",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 459,
  ),
  Data(
    english: "Darkness",
    turkish: "Karanlık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 460,
  ),
  Data(
    english: "Database",
    turkish: "Veritabanı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 461,
  ),
  Data(
    english: "Dawn",
    turkish: "Şafak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 462,
  ),
  Data(
    english: "Deadline",
    turkish: "Mühlet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 463,
  ),
  Data(
    english: "Deadly",
    turkish: "Öldürücü",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 464,
  ),
  Data(
    english: "Dealer",
    turkish: "Tüccar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 465,
  ),
  Data(
    english: "Debris",
    turkish: "Enkaz",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 466,
  ),
  Data(
    english: "Decisive",
    turkish: "Belirleyici",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 467,
  ),
  Data(
    english: "Deck",
    turkish: "Güverte",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 468,
  ),
  Data(
    english: "Declaration",
    turkish: "Beyan",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 469,
  ),
  Data(
    english: "Dedicated",
    turkish: "Özel",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 470,
  ),
  Data(
    english: "Dedication",
    turkish: "İthaf",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 471,
  ),
  Data(
    english: "Deed",
    turkish: "Tapu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 472,
  ),
  Data(
    english: "Deem",
    turkish: "Varsaymak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 473,
  ),
  Data(
    english: "Default",
    turkish: "Varsayılan",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 474,
  ),
  Data(
    english: "Defect",
    turkish: "Kusur",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 475,
  ),
  Data(
    english: "Defender",
    turkish: "Savunucu",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 476,
  ),
  Data(
    english: "Defensive",
    turkish: "Savunmaya Yönelik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 477,
  ),
  Data(
    english: "Deficiency",
    turkish: "Eksiklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 478,
  ),
  Data(
    english: "Deficit",
    turkish: "Açık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 479,
  ),
  Data(
    english: "Defy",
    turkish: "Karşı Koymak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 480,
  ),
  Data(
    english: "Delegate",
    turkish: "Delege",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 481,
  ),
  Data(
    english: "Delegation",
    turkish: "Delegasyon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 482,
  ),
  Data(
    english: "Delete",
    turkish: "Silmek",
    level: WordLevel.b1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 483,
  ),
  Data(
    english: "Delicate",
    turkish: "Narin",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 484,
  ),
  Data(
    english: "Delighted",
    turkish: "Memnun",
    level: WordLevel.b1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 485,
  ),
  Data(
    english: "Democracy",
    turkish: "Demokrasi",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 486,
  ),
  Data(
    english: "Democratic",
    turkish: "Demokratik",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 487,
  ),
  Data(
    english: "Demon",
    turkish: "Şeytan",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 488,
  ),
  Data(
    english: "Demonstration",
    turkish: "Gösteri",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 489,
  ),
  Data(
    english: "Denial",
    turkish: "İnkar",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 490,
  ),
  Data(
    english: "Denounce",
    turkish: "Suçlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 491,
  ),
  Data(
    english: "Dense",
    turkish: "Yoğun",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 492,
  ),
  Data(
    english: "Density",
    turkish: "Yoğunluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 493,
  ),
  Data(
    english: "Depart",
    turkish: "Ayrılmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 494,
  ),
  Data(
    english: "Dependence",
    turkish: "Bağımlılık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 495,
  ),
  Data(
    english: "Dependent",
    turkish: "Bağımlı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 496,
  ),
  Data(
    english: "Depict",
    turkish: "Tanımlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 497,
  ),
  Data(
    english: "Deploy",
    turkish: "Konuşlandırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 498,
  ),
  Data(
    english: "Deployment",
    turkish: "Yayılma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 499,
  ),
  Data(
    english: "Deposit",
    turkish: "Koymak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 500,
  ),
  Data(
    english: "Depression",
    turkish: "Depresyon",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 501,
  ),
  Data(
    english: "Deprive",
    turkish: "Yoksun Bırakmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 502,
  ),
  Data(
    english: "Deputy",
    turkish: "Vekil",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 503,
  ),
  Data(
    english: "Derive",
    turkish: "Türemek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 504,
  ),
  Data(
    english: "Descend",
    turkish: "Alçalmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 505,
  ),
  Data(
    english: "Descent",
    turkish: "Alçalma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 506,
  ),
  Data(
    english: "Designate",
    turkish: "Atamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 507,
  ),
  Data(
    english: "Desirable",
    turkish: "Hoş",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 508,
  ),
  Data(
    english: "Desktop",
    turkish: "Masaüstü",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 509,
  ),
  Data(
    english: "Desperately",
    turkish: "Umutsuzca",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink: "https://",
    id: 510,
  ),
  Data(
    english: "Destruction",
    turkish: "Yıkım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 511,
  ),
  Data(
    english: "Destructive",
    turkish: "Yıkıcı",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 512,
  ),
  Data(
    english: "Detain",
    turkish: "Alıkoymak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 513,
  ),
  Data(
    english: "Detection",
    turkish: "Bulma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 514,
  ),
  Data(
    english: "Detention",
    turkish: "Tutuklanma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 515,
  ),
  Data(
    english: "Deteriorate",
    turkish: "Kötüleşmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 516,
  ),
  Data(
    english: "Determination",
    turkish: "Kararlılık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 517,
  ),
  Data(
    english: "Devastate",
    turkish: "Yıkmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 518,
  ),
  Data(
    english: "Devil",
    turkish: "Şeytan",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 519,
  ),
  Data(
    english: "Devise",
    turkish: "Tasarlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 520,
  ),
  Data(
    english: "Devote",
    turkish: "Adamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 521,
  ),
  Data(
    english: "Diagnose",
    turkish: "Teşhis Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 522,
  ),
  Data(
    english: "Diagnosis",
    turkish: "Teşhis",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 523,
  ),
  Data(
    english: "Dictate",
    turkish: "Yazdırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 524,
  ),
  Data(
    english: "Dictator",
    turkish: "Diktatör",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 525,
  ),
  Data(
    english: "Differ",
    turkish: "Farklı Olmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 526,
  ),
  Data(
    english: "Differentiate",
    turkish: "Ayırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 527,
  ),
  Data(
    english: "Dignity",
    turkish: "Haysiyet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 528,
  ),
  Data(
    english: "Dilemma",
    turkish: "İkilem",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 529,
  ),
  Data(
    english: "Dimension",
    turkish: "Boyut",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 530,
  ),
  Data(
    english: "Diminish",
    turkish: "Azaltmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 531,
  ),
  Data(
    english: "Dip",
    turkish: "Daldırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 532,
  ),
  Data(
    english: "Directory",
    turkish: "Rehber",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 533,
  ),
  Data(
    english: "Disability",
    turkish: "Sakatlık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 534,
  ),
  Data(
    english: "Disabled",
    turkish: "Sakat",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 535,
  ),
  Data(
    english: "Disagreement",
    turkish: "Anlaşmazlık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 536,
  ),
  Data(
    english: "Disappointment",
    turkish: "Hayal Kırıklığı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 537,
  ),
  Data(
    english: "Disastrous",
    turkish: "Feci",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 538,
  ),
  Data(
    english: "Discard",
    turkish: "Atmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 539,
  ),
  Data(
    english: "Discharge",
    turkish: "Tahliye",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 540,
  ),
  Data(
    english: "Disclose",
    turkish: "İfşa Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 541,
  ),
  Data(
    english: "Disclosure",
    turkish: "İfşa",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 542,
  ),
  Data(
    english: "Discourage",
    turkish: "Vazgeçirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 543,
  ),
  Data(
    english: "Discourse",
    turkish: "Söylem",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 544,
  ),
  Data(
    english: "Discretion",
    turkish: "Sağduyu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 545,
  ),
  Data(
    english: "Discrimination",
    turkish: "Ayrımcılık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 546,
  ),
  Data(
    english: "Dismissal",
    turkish: "İşten Atılma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 547,
  ),
  Data(
    english: "Disorder",
    turkish: "Düzensizlik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 548,
  ),
  Data(
    english: "Displace",
    turkish: "Yer Değiştirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 549,
  ),
  Data(
    english: "Disposal",
    turkish: "Atma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 550,
  ),
  Data(
    english: "Dispute",
    turkish: "Anlaşmazlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 551,
  ),
  Data(
    english: "Disrupt",
    turkish: "Engellemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 552,
  ),
  Data(
    english: "Disruption",
    turkish: "Bozulma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 553,
  ),
  Data(
    english: "Dissolve",
    turkish: "Eritmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 554,
  ),
  Data(
    english: "Distant",
    turkish: "Uzak",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 555,
  ),
  Data(
    english: "Distinct",
    turkish: "Farklı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 556,
  ),
  Data(
    english: "Distinction",
    turkish: "Ayrım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 557,
  ),
  Data(
    english: "Distinctive",
    turkish: "Karakteristik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 558,
  ),
  Data(
    english: "Distinguish",
    turkish: "Ayırt Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 559,
  ),
  Data(
    english: "Distort",
    turkish: "Çarpıtmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 560,
  ),
  Data(
    english: "Distress",
    turkish: "Sıkıntı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 561,
  ),
  Data(
    english: "Disturb",
    turkish: "Rahatsız Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 562,
  ),
  Data(
    english: "Disturbing",
    turkish: "Rahatsız Edici",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 563,
  ),
  Data(
    english: "Dive",
    turkish: "Dalmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 564,
  ),
  Data(
    english: "Diverse",
    turkish: "Çeşitli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 565,
  ),
  Data(
    english: "Diversity",
    turkish: "Çeşitlilik",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 566,
  ),
  Data(
    english: "Divert",
    turkish: "Saptırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 567,
  ),
  Data(
    english: "Divine",
    turkish: "İlahi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 568,
  ),
  Data(
    english: "Divorce",
    turkish: "Boşanmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 569,
  ),
  Data(
    english: "Doctrine",
    turkish: "Doktrin",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 570,
  ),
  Data(
    english: "Domain",
    turkish: "İhtisas",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 571,
  ),
  Data(
    english: "Dominance",
    turkish: "Hakimiyet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 572,
  ),
  Data(
    english: "Dominant",
    turkish: "Baskın",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 573,
  ),
  Data(
    english: "Donation",
    turkish: "Bağış",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 574,
  ),
  Data(
    english: "Dose",
    turkish: "Doz",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 575,
  ),
  Data(
    english: "Dot",
    turkish: "Nokta",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 576,
  ),
  Data(
    english: "Drain",
    turkish: "Kurutmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 577,
  ),
  Data(
    english: "Drift",
    turkish: "Sürüklenmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 578,
  ),
  Data(
    english: "Driving",
    turkish: "Sürüş",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 579,
  ),
  Data(
    english: "Drought",
    turkish: "Kuraklık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 580,
  ),
  Data(
    english: "Drown",
    turkish: "Boğulmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 581,
  ),
  Data(
    english: "Dual",
    turkish: "İkili",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 582,
  ),
  Data(
    english: "Dull",
    turkish: "Sıkıcı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 583,
  ),
  Data(
    english: "Dumb",
    turkish: "Aptal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 584,
  ),
  Data(
    english: "Dump",
    turkish: "Çöplük",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 585,
  ),
  Data(
    english: "Duo",
    turkish: "Düet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 586,
  ),
  Data(
    english: "Duration",
    turkish: "Süre",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 587,
  ),
  Data(
    english: "Eager",
    turkish: "İstekli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 588,
  ),
  Data(
    english: "Earnings",
    turkish: "Kazanç",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 589,
  ),
  Data(
    english: "Ease",
    turkish: "Rahatlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 590,
  ),
  Data(
    english: "Echo",
    turkish: "Yankı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 591,
  ),
  Data(
    english: "Ecological",
    turkish: "Ekolojik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 592,
  ),
  Data(
    english: "Economics",
    turkish: "İktisat",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 593,
  ),
  Data(
    english: "Economist",
    turkish: "İktisatçı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 594,
  ),
  Data(
    english: "Editorial",
    turkish: "Başyazı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 595,
  ),
  Data(
    english: "Educator",
    turkish: "Eğitimci",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 596,
  ),
  Data(
    english: "Effectiveness",
    turkish: "Verimlilik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 597,
  ),
  Data(
    english: "Efficiency",
    turkish: "Verim",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 598,
  ),
  Data(
    english: "Efficiently",
    turkish: "Verimli",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink: "https://",
    id: 599,
  ),
  Data(
    english: "Elaborate",
    turkish: "Ayrıntılı",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 600,
  ),
  Data(
    english: "Elbow",
    turkish: "Dirsek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "https://",
    id: 601,
  ),
  Data(
    english: "Elegant",
    turkish: "Zarif",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 602,
  ),
  Data(
    english: "Elementary",
    turkish: "Temel",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 603,
  ),
  Data(
    english: "Elevate",
    turkish: "Yükseltmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 604,
  ),
  Data(
    english: "Eligible",
    turkish: "Uygun",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "https://",
    id: 605,
  ),
  Data(
    english: "Eliminate",
    turkish: "Elemek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "https://",
    id: 606,
  ),
  Data(
    english: "Embark",
    turkish: "Binmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 607,
  ),
  Data(
    english: "Embarrassment",
    turkish: "Utanç",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 608,
  ),
  Data(
    english: "Embassy",
    turkish: "Elçilik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "https://",
    id: 609,
  ),
  Data(
    english: "Embed",
    turkish: "Gömmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "https://",
    id: 610,
  ),
  Data(
    english: "Embody",
    turkish: "Somutlaştırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 611,
  ),
  Data(
    english: "Embrace",
    turkish: "Kucaklamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 612,
  ),
  Data(
    english: "Emergence",
    turkish: "Ortaya Çıkma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 613,
  ),
  Data(
    english: "Emission",
    turkish: "Yayma",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 614,
  ),
  Data(
    english: "Empire",
    turkish: "İmparatorluk",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 615,
  ),
  Data(
    english: "Empirical",
    turkish: "Deneysel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 616,
  ),
  Data(
    english: "Empower",
    turkish: "Yetkilendirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 617,
  ),
  Data(
    english: "Enact",
    turkish: "Yasallaştırma",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 618,
  ),
  Data(
    english: "Encompass",
    turkish: "Kapsamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 619,
  ),
  Data(
    english: "Encouragement",
    turkish: "Teşvik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 620,
  ),
  Data(
    english: "Endeavor",
    turkish: "Çaba",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 621,
  ),
  Data(
    english: "Endless",
    turkish: "Sonsuz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 622,
  ),
  Data(
    english: "Endorse",
    turkish: "Onaylamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 623,
  ),
  Data(
    english: "Endorsement",
    turkish: "Onaylama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 624,
  ),
  Data(
    english: "Endure",
    turkish: "Dayanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 625,
  ),
  Data(
    english: "Enforce",
    turkish: "Uygulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 626,
  ),
  Data(
    english: "Enforcement",
    turkish: "Uygulama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 627,
  ),
  Data(
    english: "Engagement",
    turkish: "Nişan",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 628,
  ),
  Data(
    english: "Engaging",
    turkish: "Çekici",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 629,
  ),
  Data(
    english: "Enjoyable",
    turkish: "Zevkli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 630,
  ),
  Data(
    english: "Enrich",
    turkish: "Zenginleştirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 631,
  ),
  Data(
    english: "Enroll",
    turkish: "Kaydolmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 632,
  ),
  Data(
    english: "Enterprise",
    turkish: "Girişim",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 633,
  ),
  Data(
    english: "Entertaining",
    turkish: "Eğlenceli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 634,
  ),
  Data(
    english: "Enthusiast",
    turkish: "Meraklı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 635,
  ),
  Data(
    english: "Entitle",
    turkish: "Yetkili Kılmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 636,
  ),
  Data(
    english: "Entity",
    turkish: "Varlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 637,
  ),
  Data(
    english: "Entrepreneur",
    turkish: "Girişimci",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 638,
  ),
  Data(
    english: "Envelope",
    turkish: "Zarf",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 639,
  ),
  Data(
    english: "Epidemic",
    turkish: "Salgın",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 640,
  ),
  Data(
    english: "Equality",
    turkish: "Denklik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 641,
  ),
  Data(
    english: "Equation",
    turkish: "Eşitlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 642,
  ),
  Data(
    english: "Equip",
    turkish: "Donatmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 643,
  ),
  Data(
    english: "Equivalent",
    turkish: "Eşit",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 644,
  ),
  Data(
    english: "Era",
    turkish: "Çağ",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 645,
  ),
  Data(
    english: "Erupt",
    turkish: "Patlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 646,
  ),
  Data(
    english: "Escalate",
    turkish: "Yükselmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 647,
  ),
  Data(
    english: "Essence",
    turkish: "Esas",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 648,
  ),
  Data(
    english: "Essentially",
    turkish: "Esasen",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 649,
  ),
  Data(
    english: "Establishment",
    turkish: "Kuruluş",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 650,
  ),
  Data(
    english: "Eternal",
    turkish: "Sonsuz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 651,
  ),
  Data(
    english: "Ethnic",
    turkish: "Etnik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 652,
  ),
  Data(
    english: "Evacuate",
    turkish: "Tahliye Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 653,
  ),
  Data(
    english: "Evaluation",
    turkish: "Değerlendirme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 654,
  ),
  Data(
    english: "Evident",
    turkish: "Belirgin",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 655,
  ),
  Data(
    english: "Evoke",
    turkish: "Anımsatmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 656,
  ),
  Data(
    english: "Evolution",
    turkish: "Evrim",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 657,
  ),
  Data(
    english: "Evolutionary",
    turkish: "Evrimsel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 658,
  ),
  Data(
    english: "Evolve",
    turkish: "Geliştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 659,
  ),
  Data(
    english: "Exaggerate",
    turkish: "Abartmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 660,
  ),
  Data(
    english: "Exceed",
    turkish: "Aşmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 661,
  ),
  Data(
    english: "Excellence",
    turkish: "Üstünlük",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 662,
  ),
  Data(
    english: "Exception",
    turkish: "İstisna",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 663,
  ),
  Data(
    english: "Exceptional",
    turkish: "Olağanüstü",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 664,
  ),
  Data(
    english: "Excess",
    turkish: "Aşırılık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 665,
  ),
  Data(
    english: "Excessive",
    turkish: "Aşırı",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 666,
  ),
  Data(
    english: "Exclude",
    turkish: "Dışlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 667,
  ),
  Data(
    english: "Exclusion",
    turkish: "Dışlama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 668,
  ),
  Data(
    english: "Exclusive",
    turkish: "Özel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 669,
  ),
  Data(
    english: "Exclusively",
    turkish: "Yalnız",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 670,
  ),
  Data(
    english: "Execute",
    turkish: "Uygulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 671,
  ),
  Data(
    english: "Execution",
    turkish: "İdam",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 672,
  ),
  Data(
    english: "Exert",
    turkish: "Uygulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 673,
  ),
  Data(
    english: "Exile",
    turkish: "Sürgün",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 674,
  ),
  Data(
    english: "Expansion",
    turkish: "Genişleme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 675,
  ),
  Data(
    english: "Expedition",
    turkish: "Sefer",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 676,
  ),
  Data(
    english: "Expenditure",
    turkish: "Harcama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 677,
  ),
  Data(
    english: "Experimental",
    turkish: "Deneysel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 678,
  ),
  Data(
    english: "Expertise",
    turkish: "Uzmanlık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 679,
  ),
  Data(
    english: "Expire",
    turkish: "Sona Ermek",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 680,
  ),
  Data(
    english: "Explicit",
    turkish: "Belirgin",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 681,
  ),
  Data(
    english: "Explicitly",
    turkish: "Açıkça",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 682,
  ),
  Data(
    english: "Exploit",
    turkish: "Sömürmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 683,
  ),
  Data(
    english: "Exploitation",
    turkish: "Sömürü",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 684,
  ),
  Data(
    english: "Explosive",
    turkish: "Patlayıcı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 685,
  ),
  Data(
    english: "Exposure",
    turkish: "Maruziyet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 686,
  ),
  Data(
    english: "Extension",
    turkish: "Eklenti",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 687,
  ),
  Data(
    english: "Extensive",
    turkish: "Geniş",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 688,
  ),
  Data(
    english: "Extract",
    turkish: "Çıkarmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 689,
  ),
  Data(
    english: "Extremist",
    turkish: "Fanatik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 690,
  ),
  Data(
    english: "Fabric",
    turkish: "Kumaş",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 691,
  ),
  Data(
    english: "Fabulous",
    turkish: "Harika",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 692,
  ),
  Data(
    english: "Facilitate",
    turkish: "Kolaylaştırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 693,
  ),
  Data(
    english: "Faction",
    turkish: "Hizip",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 694,
  ),
  Data(
    english: "Faculty",
    turkish: "Fakülte",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 695,
  ),
  Data(
    english: "Fade",
    turkish: "Solmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 696,
  ),
  Data(
    english: "Fairness",
    turkish: "Doğruluk",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 697,
  ),
  Data(
    english: "Fake",
    turkish: "Sahte",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 698,
  ),
  Data(
    english: "Fame",
    turkish: "Şöhret",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 699,
  ),
  Data(
    english: "Fare",
    turkish: "Bilet Ücreti",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 700,
  ),
  Data(
    english: "Fatal",
    turkish: "Ölümcül",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 701,
  ),
  Data(
    english: "Fate",
    turkish: "Kader",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 702,
  ),
  Data(
    english: "Favorable",
    turkish: "Elverişli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 703,
  ),
  Data(
    english: "Feat",
    turkish: "Kahramanlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 704,
  ),
  Data(
    english: "Felony",
    turkish: "Suç",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 705,
  ),
  Data(
    english: "Fibre",
    turkish: "Lif",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 706,
  ),
  Data(
    english: "Filter",
    turkish: "Süzmek",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 707,
  ),
  Data(
    english: "Fine",
    turkish: "Hoş",
    level: WordLevel.a1,
    type: WordType.noun,
    id: 708,
  ),
  Data(
    english: "Firearm",
    turkish: "Ateşli Silah",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 709,
  ),
  Data(
    english: "Firefighter",
    turkish: "İtfayeci",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 710,
  ),
  Data(
    english: "Firework",
    turkish: "Havai Fişek",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 711,
  ),
  Data(
    english: "Firm",
    turkish: "Sert",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 712,
  ),
  Data(
    english: "Fiscal",
    turkish: "Mali",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 713,
  ),
  Data(
    english: "Fit",
    turkish: "Uygun",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 714,
  ),
  Data(
    english: "Flavor",
    turkish: "Lezzet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 715,
  ),
  Data(
    english: "Flaw",
    turkish: "Kusur",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 716,
  ),
  Data(
    english: "Flawed",
    turkish: "Kusurlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 717,
  ),
  Data(
    english: "Flee",
    turkish: "Kaçmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 718,
  ),
  Data(
    english: "Fleet",
    turkish: "Filo",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 719,
  ),
  Data(
    english: "Flesh",
    turkish: "Et",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 720,
  ),
  Data(
    english: "Flexibility",
    turkish: "Esneklik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 721,
  ),
  Data(
    english: "Flourish",
    turkish: "Güzelleşmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 722,
  ),
  Data(
    english: "Fluid",
    turkish: "Sıvı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 723,
  ),
  Data(
    english: "Fond",
    turkish: "Düşkün",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 724,
  ),
  Data(
    english: "Fool",
    turkish: "Kandırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 725,
  ),
  Data(
    english: "Forbid",
    turkish: "Yasaklamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 726,
  ),
  Data(
    english: "Forecast",
    turkish: "Tahmin",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 727,
  ),
  Data(
    english: "Foreigner",
    turkish: "Yabancı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 728,
  ),
  Data(
    english: "Forge",
    turkish: "Demirhane",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 729,
  ),
  Data(
    english: "Format",
    turkish: "Biçim",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 730,
  ),
  Data(
    english: "Formation",
    turkish: "Oluşum",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 731,
  ),
  Data(
    english: "Formerly",
    turkish: "Eskiden",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 732,
  ),
  Data(
    english: "Formulate",
    turkish: "Şekillendirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 733,
  ),
  Data(
    english: "Forth",
    turkish: "İleri",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 734,
  ),
  Data(
    english: "Forthcoming",
    turkish: "Gelecek",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 735,
  ),
  Data(
    english: "Fortunate",
    turkish: "Şanslı",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 736,
  ),
  Data(
    english: "Forum",
    turkish: "Meydan",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 737,
  ),
  Data(
    english: "Foster",
    turkish: "Bakmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 738,
  ),
  Data(
    english: "Foundation",
    turkish: "Temel",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 739,
  ),
  Data(
    english: "Founder",
    turkish: "Kurucu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 740,
  ),
  Data(
    english: "Fraction",
    turkish: "Kesir",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 741,
  ),
  Data(
    english: "Fragile",
    turkish: "Kırılgan",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 742,
  ),
  Data(
    english: "Fragment",
    turkish: "Kırıntı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 743,
  ),
  Data(
    english: "Framework",
    turkish: "Çerçeve",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 744,
  ),
  Data(
    english: "Franchise",
    turkish: "Bayilik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 745,
  ),
  Data(
    english: "Frankly",
    turkish: "Açıkça",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 746,
  ),
  Data(
    english: "Fraud",
    turkish: "Sahtekar",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 747,
  ),
  Data(
    english: "Freely",
    turkish: "Serbestçe",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 748,
  ),
  Data(
    english: "Frequent",
    turkish: "Olağan",
    level: WordLevel.a1,
    type: WordType.adjective,
    id: 749,
  ),
  Data(
    english: "Frustrating",
    turkish: "Umut Kırıcı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 750,
  ),
  Data(
    english: "Frustration",
    turkish: "Hüsran",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 751,
  ),
  Data(
    english: "Functional",
    turkish: "İşlevsel",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 752,
  ),
  Data(
    english: "Fundamentally",
    turkish: "Esasen",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 753,
  ),
  Data(
    english: "Funeral",
    turkish: "Cenaze Töreni",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 754,
  ),
  Data(
    english: "Furious",
    turkish: "Öfkeli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 755,
  ),
  Data(
    english: "Gambling",
    turkish: "Kumar",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 756,
  ),
  Data(
    english: "Gathering",
    turkish: "Toplantı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 757,
  ),
  Data(
    english: "Gear",
    turkish: "Vites",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 758,
  ),
  Data(
    english: "Gender",
    turkish: "Cinsiyet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 759,
  ),
  Data(
    english: "Gene",
    turkish: "Gen",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 760,
  ),
  Data(
    english: "Genius",
    turkish: "Dahi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 761,
  ),
  Data(
    english: "Genocide",
    turkish: "Soykırım",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 762,
  ),
  Data(
    english: "Genuine",
    turkish: "Gerçek",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 763,
  ),
  Data(
    english: "Genuinely",
    turkish: "Gerçekten",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 764,
  ),
  Data(
    english: "Gig",
    turkish: "Konser",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 765,
  ),
  Data(
    english: "Glance",
    turkish: "Göz Atmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 766,
  ),
  Data(
    english: "Glimpse",
    turkish: "Gözatma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 767,
  ),
  Data(
    english: "Globalization",
    turkish: "Küreselleşme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 768,
  ),
  Data(
    english: "Globe",
    turkish: "Küre",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 769,
  ),
  Data(
    english: "Glorious",
    turkish: "Muhteşem",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 770,
  ),
  Data(
    english: "Glory",
    turkish: "Şan",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 771,
  ),
  Data(
    english: "Goodness",
    turkish: "İyilik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 772,
  ),
  Data(
    english: "Gorgeous",
    turkish: "Muhteşem",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 773,
  ),
  Data(
    english: "Governance",
    turkish: "Yönetim",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 774,
  ),
  Data(
    english: "Grace",
    turkish: "Zarafet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 775,
  ),
  Data(
    english: "Grasp",
    turkish: "Kavramak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 776,
  ),
  Data(
    english: "Grave",
    turkish: "Mezar",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 777,
  ),
  Data(
    english: "Gravity",
    turkish: "Yer Çekimi",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 778,
  ),
  Data(
    english: "Greatly",
    turkish: "Çokça",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 779,
  ),
  Data(
    english: "Greenhouse",
    turkish: "Sera",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 780,
  ),
  Data(
    english: "Grid",
    turkish: "Izgara",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 781,
  ),
  Data(
    english: "Grief",
    turkish: "Keder",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 782,
  ),
  Data(
    english: "Grin",
    turkish: "Sırıtmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 783,
  ),
  Data(
    english: "Grind",
    turkish: "Öğütmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 784,
  ),
  Data(
    english: "Grip",
    turkish: "Kavrama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 785,
  ),
  Data(
    english: "Gross",
    turkish: "Brüt",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 786,
  ),
  Data(
    english: "Guidance",
    turkish: "Rehberlik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 787,
  ),
  Data(
    english: "Guideline",
    turkish: "Yönerge",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 788,
  ),
  Data(
    english: "Guilt",
    turkish: "Suçluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 789,
  ),
  Data(
    english: "Gut",
    turkish: "Bağırsak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 790,
  ),
  Data(
    english: "Hail",
    turkish: "Dolu",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 791,
  ),
  Data(
    english: "Halfway",
    turkish: "Ortasında",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 792,
  ),
  Data(
    english: "Halt",
    turkish: "Durmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 793,
  ),
  Data(
    english: "Handle",
    turkish: "Tokmak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 794,
  ),
  Data(
    english: "Handy",
    turkish: "Kullanışlı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 795,
  ),
  Data(
    english: "Harbor",
    turkish: "Liman",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 796,
  ),
  Data(
    english: "Hardware",
    turkish: "Donanım",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 797,
  ),
  Data(
    english: "Harmony",
    turkish: "Uyum",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 798,
  ),
  Data(
    english: "Harsh",
    turkish: "Sert",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 799,
  ),
  Data(
    english: "Harvest",
    turkish: "Hasat",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 800,
  ),
  Data(
    english: "Hatred",
    turkish: "Kin",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 801,
  ),
  Data(
    english: "Haunt",
    turkish: "Uğrak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 802,
  ),
  Data(
    english: "Hazard",
    turkish: "Tehlike",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 803,
  ),
  Data(
    english: "Headquarters",
    turkish: "Karargah",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 804,
  ),
  Data(
    english: "Heal",
    turkish: "İyileştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 805,
  ),
  Data(
    english: "Heighten",
    turkish: "Yükseltmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 806,
  ),
  Data(
    english: "Helmet",
    turkish: "Kask",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 807,
  ),
  Data(
    english: "Heritage",
    turkish: "Miras",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 808,
  ),
  Data(
    english: "Hidden",
    turkish: "Gizli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 809,
  ),
  Data(
    english: "Hierarchy",
    turkish: "Hiyerarşi",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 810,
  ),
  Data(
    english: "Hilarious",
    turkish: "Gülünç",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 811,
  ),
  Data(
    english: "Hint",
    turkish: "İpucu",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 812,
  ),
  Data(
    english: "Hip",
    turkish: "Kalça",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 813,
  ),
  Data(
    english: "Historian",
    turkish: "Tarihçi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 814,
  ),
  Data(
    english: "Homeland",
    turkish: "Anavatan",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 815,
  ),
  Data(
    english: "Homeless",
    turkish: "Evsiz",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 816,
  ),
  Data(
    english: "Honesty",
    turkish: "Dürüstlük",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 817,
  ),
  Data(
    english: "Honey",
    turkish: "Bal",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 818,
  ),
  Data(
    english: "Hook",
    turkish: "Kanca",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 819,
  ),
  Data(
    english: "Hopefully",
    turkish: "Umutla",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 820,
  ),
  Data(
    english: "Horizon",
    turkish: "Ufuk",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 821,
  ),
  Data(
    english: "Horn",
    turkish: "Boynuz",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 822,
  ),
  Data(
    english: "Hostage",
    turkish: "Rehine",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 823,
  ),
  Data(
    english: "Hostile",
    turkish: "Saldırgan",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 824,
  ),
  Data(
    english: "Hostility",
    turkish: "Düşmanlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 825,
  ),
  Data(
    english: "Humanitarian",
    turkish: "İnsani",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 826,
  ),
  Data(
    english: "Humanity",
    turkish: "İnsanlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 827,
  ),
  Data(
    english: "Humble",
    turkish: "Mütevazı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 828,
  ),
  Data(
    english: "Hunger",
    turkish: "Açlık",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 829,
  ),
  Data(
    english: "Identical",
    turkish: "Aynı",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 830,
  ),
  Data(
    english: "Identification",
    turkish: "Kimlik",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 831,
  ),
  Data(
    english: "Idiot",
    turkish: "Aptal",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 832,
  ),
  Data(
    english: "Ignorance",
    turkish: "Cehalet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 833,
  ),
  Data(
    english: "Imagery",
    turkish: "Tasvir",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 834,
  ),
  Data(
    english: "Immense",
    turkish: "Muazzam",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 835,
  ),
  Data(
    english: "Immigration",
    turkish: "Göçmenlik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 836,
  ),
  Data(
    english: "Imminent",
    turkish: "Yakın",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 837,
  ),
  Data(
    english: "Immune",
    turkish: "Bağışık",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 838,
  ),
  Data(
    english: "Implement",
    turkish: "Uygulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 839,
  ),
  Data(
    english: "Implementation",
    turkish: "Uygulama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 840,
  ),
  Data(
    english: "Implication",
    turkish: "İma",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 841,
  ),
  Data(
    english: "Imprison",
    turkish: "Hapsetmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 842,
  ),
  Data(
    english: "Inability",
    turkish: "Yetersizlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 843,
  ),
  Data(
    english: "Inadequate",
    turkish: "Yetersiz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 844,
  ),
  Data(
    english: "Inappropriate",
    turkish: "Uygunsuz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 845,
  ),
  Data(
    english: "Incarcerate",
    turkish: "Hapsetmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 846,
  ),
  Data(
    english: "Incentive",
    turkish: "Teşvik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 847,
  ),
  Data(
    english: "Incidence",
    turkish: "Oran",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 848,
  ),
  Data(
    english: "Inclusion",
    turkish: "İçerme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 849,
  ),
  Data(
    english: "Incorrect",
    turkish: "Yanlış",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 850,
  ),
  Data(
    english: "Incur",
    turkish: "Uğramak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 851,
  ),
  Data(
    english: "Independence",
    turkish: "Bağımsızlık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 852,
  ),
  Data(
    english: "Index",
    turkish: "Dizin",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 853,
  ),
  Data(
    english: "Indication",
    turkish: "Gösterge",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 854,
  ),
  Data(
    english: "Indicator",
    turkish: "Gösterge",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 855,
  ),
  Data(
    english: "Indictment",
    turkish: "Kusur",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 856,
  ),
  Data(
    english: "Indigenous",
    turkish: "Yerli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 857,
  ),
  Data(
    english: "Induce",
    turkish: "İnandırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 858,
  ),
  Data(
    english: "Indulge",
    turkish: "Şımartmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 859,
  ),
  Data(
    english: "Inequality",
    turkish: "Eşitsizlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 860,
  ),
  Data(
    english: "Inevitable",
    turkish: "Kaçınılmaz",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 861,
  ),
  Data(
    english: "Infamous",
    turkish: "Rezil",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 862,
  ),
  Data(
    english: "Infant",
    turkish: "Bebek",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 863,
  ),
  Data(
    english: "Infect",
    turkish: "Bulaştırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 864,
  ),
  Data(
    english: "Inflation",
    turkish: "Enflasyon",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 865,
  ),
  Data(
    english: "Influential",
    turkish: "Nüfuzlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 866,
  ),
  Data(
    english: "Info",
    turkish: "Bilgi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 867,
  ),
  Data(
    english: "Infrastructure",
    turkish: "Altyapı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 868,
  ),
  Data(
    english: "Inherent",
    turkish: "Doğuştan",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 869,
  ),
  Data(
    english: "Inhibit",
    turkish: "Engellemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 870,
  ),
  Data(
    english: "Initiate",
    turkish: "Başlatmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 871,
  ),
  Data(
    english: "Injection",
    turkish: "İğne",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 872,
  ),
  Data(
    english: "Injustice",
    turkish: "Adaletsizlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 873,
  ),
  Data(
    english: "Ink",
    turkish: "Mürekkep",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 874,
  ),
  Data(
    english: "Inmate",
    turkish: "Mahkum",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 875,
  ),
  Data(
    english: "Innovation",
    turkish: "Yenilik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 876,
  ),
  Data(
    english: "Innovative",
    turkish: "Yenilikçi",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 877,
  ),
  Data(
    english: "Input",
    turkish: "Girdi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 878,
  ),
  Data(
    english: "Inquire",
    turkish: "Sormak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 879,
  ),
  Data(
    english: "Insert",
    turkish: "Yerleştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 880,
  ),
  Data(
    english: "Insertion",
    turkish: "Ekleme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 881,
  ),
  Data(
    english: "Inspect",
    turkish: "Denetlemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 882,
  ),
  Data(
    english: "Inspection",
    turkish: "Denetleme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 883,
  ),
  Data(
    english: "Inspector",
    turkish: "Müfettiş",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 884,
  ),
  Data(
    english: "Inspiration",
    turkish: "İlham",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 885,
  ),
  Data(
    english: "Installation",
    turkish: "Kurulum",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 886,
  ),
  Data(
    english: "Instant",
    turkish: "Ani",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 887,
  ),
  Data(
    english: "Instantly",
    turkish: "Anında",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 888,
  ),
  Data(
    english: "Instinct",
    turkish: "İçgüdü",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 889,
  ),
  Data(
    english: "Institutional",
    turkish: "Kurumsal",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 890,
  ),
  Data(
    english: "Instruct",
    turkish: "Öğretmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 891,
  ),
  Data(
    english: "Insufficient",
    turkish: "Yetersiz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 892,
  ),
  Data(
    english: "Insult",
    turkish: "Hakaret",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 893,
  ),
  Data(
    english: "Intact",
    turkish: "Sağlam",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 894,
  ),
  Data(
    english: "Integrate",
    turkish: "Birleştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 895,
  ),
  Data(
    english: "Integration",
    turkish: "Birleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 896,
  ),
  Data(
    english: "Integrity",
    turkish: "Bütünlük",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 897,
  ),
  Data(
    english: "Intellectual",
    turkish: "Zihinsel",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 898,
  ),
  Data(
    english: "Intensify",
    turkish: "Şiddetlendirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 899,
  ),
  Data(
    english: "Intensity",
    turkish: "Şiddet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 900,
  ),
  Data(
    english: "Intensive",
    turkish: "Yoğun",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 901,
  ),
  Data(
    english: "Intent",
    turkish: "Niyet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 902,
  ),
  Data(
    english: "Interact",
    turkish: "Etkileşmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 903,
  ),
  Data(
    english: "Interaction",
    turkish: "Etkileşim",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 904,
  ),
  Data(
    english: "Interactive",
    turkish: "Etkileşimli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 905,
  ),
  Data(
    english: "Interface",
    turkish: "Arayüz",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 906,
  ),
  Data(
    english: "Interfere",
    turkish: "Karışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 907,
  ),
  Data(
    english: "ınterference",
    turkish: "Karışma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 908,
  ),
  Data(
    english: "Interim",
    turkish: "Geçici",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 909,
  ),
  Data(
    english: "Interior",
    turkish: "İç",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 910,
  ),
  Data(
    english: "Intermediate",
    turkish: "Orta",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 911,
  ),
  Data(
    english: "Interpretation",
    turkish: "Yorumlama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 912,
  ),
  Data(
    english: "Intersection",
    turkish: "Kavşak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 913,
  ),
  Data(
    english: "Interval",
    turkish: "Ara",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 914,
  ),
  Data(
    english: "Intervene",
    turkish: "Karışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 915,
  ),
  Data(
    english: "Intervention",
    turkish: "Müdahale",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 916,
  ),
  Data(
    english: "Intimate",
    turkish: "Kişisel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 917,
  ),
  Data(
    english: "Intriguing",
    turkish: "İlgi Çekici",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 918,
  ),
  Data(
    english: "Invade",
    turkish: "İstila Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 919,
  ),
  Data(
    english: "Invasion",
    turkish: "İstila",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 920,
  ),
  Data(
    english: "Inventory",
    turkish: "Envanter",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 921,
  ),
  Data(
    english: "Investigator",
    turkish: "Dedektif",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 922,
  ),
  Data(
    english: "Investor",
    turkish: "Yatırımcı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 923,
  ),
  Data(
    english: "Invisible",
    turkish: "Görülmez",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 924,
  ),
  Data(
    english: "Invoke",
    turkish: "Çağırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 925,
  ),
  Data(
    english: "Involvement",
    turkish: "Katılım",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 926,
  ),
  Data(
    english: "Ironic",
    turkish: "İronik",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 927,
  ),
  Data(
    english: "Irrelevant",
    turkish: "Alakasız",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 928,
  ),
  Data(
    english: "Isolate",
    turkish: "Yalıtmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 929,
  ),
  Data(
    english: "Isolation",
    turkish: "Yalıtım",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 930,
  ),
  Data(
    english: "Jail",
    turkish: "Hapishane",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 931,
  ),
  Data(
    english: "Joint",
    turkish: "Eklem",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 932,
  ),
  Data(
    english: "Journalism",
    turkish: "Gazetecilik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 933,
  ),
  Data(
    english: "Judicial",
    turkish: "Adli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 934,
  ),
  Data(
    english: "Just",
    turkish: "Sadece",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 935,
  ),
  Data(
    english: "Justification",
    turkish: "Gerekçe",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 936,
  ),
  Data(
    english: "Keen",
    turkish: "Hevesli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 937,
  ),
  Data(
    english: "Kidnap",
    turkish: "Kaçırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 938,
  ),
  Data(
    english: "Kidney",
    turkish: "Böbrek",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 939,
  ),
  Data(
    english: "Kindergarten",
    turkish: "Anaokulu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 940,
  ),
  Data(
    english: "Kingdom",
    turkish: "Krallık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 941,
  ),
  Data(
    english: "Kit",
    turkish: "Tehçizat",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 942,
  ),
  Data(
    english: "Ladder",
    turkish: "Merdiven",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 943,
  ),
  Data(
    english: "Lane",
    turkish: "Şerit",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 944,
  ),
  Data(
    english: "Lap",
    turkish: "Kucak",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 945,
  ),
  Data(
    english: "Lately",
    turkish: "Yakınlarda",
    level: WordLevel.b1,
    type: WordType.adverb,
    id: 946,
  ),
  Data(
    english: "Latter",
    turkish: "Son",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 947,
  ),
  Data(
    english: "Lawn",
    turkish: "Çim",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 948,
  ),
  Data(
    english: "Lawsuit",
    turkish: "Dava",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 949,
  ),
  Data(
    english: "Layout",
    turkish: "Düzen",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 950,
  ),
  Data(
    english: "Leak",
    turkish: "Sızdırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 951,
  ),
  Data(
    english: "Leap",
    turkish: "Sıçrama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 952,
  ),
  Data(
    english: "Legacy",
    turkish: "Miras",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 953,
  ),
  Data(
    english: "Legend",
    turkish: "Efsane",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 954,
  ),
  Data(
    english: "Legendary",
    turkish: "Efsanevi",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 955,
  ),
  Data(
    english: "Legislation",
    turkish: "Mevzuat",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 956,
  ),
  Data(
    english: "Legitimate",
    turkish: "Yasal",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 957,
  ),
  Data(
    english: "Lens",
    turkish: "Mercek",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 958,
  ),
  Data(
    english: "Lethal",
    turkish: "Öldürücü",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 959,
  ),
  Data(
    english: "Liable",
    turkish: "Sorumlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 960,
  ),
  Data(
    english: "Liberty",
    turkish: "Özgürlük",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 961,
  ),
  Data(
    english: "Lifetime",
    turkish: "Ömür",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 962,
  ),
  Data(
    english: "Lighting",
    turkish: "Işıklandırma",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 963,
  ),
  Data(
    english: "Likelihood",
    turkish: "Olasılık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 964,
  ),
  Data(
    english: "Limitation",
    turkish: "Sınırlama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 965,
  ),
  Data(
    english: "Linear",
    turkish: "Doğrusal",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 966,
  ),
  Data(
    english: "Lineup",
    turkish: "Sıralanmak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 967,
  ),
  Data(
    english: "Linger",
    turkish: "Oyalanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 968,
  ),
  Data(
    english: "Literacy",
    turkish: "Okur Yazarlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 969,
  ),
  Data(
    english: "Literally",
    turkish: "Gerçekten",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 970,
  ),
  Data(
    english: "Literary",
    turkish: "Edebi",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 971,
  ),
  Data(
    english: "Litter",
    turkish: "Çöp",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 972,
  ),
  Data(
    english: "Migration",
    turkish: "Göç",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 973,
  ),
  Data(
    english: "Militia",
    turkish: "Milis",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 974,
  ),
  Data(
    english: "Mill",
    turkish: "Değirmen",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 975,
  ),
  Data(
    english: "Miner",
    turkish: "Madenci",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 976,
  ),
  Data(
    english: "Minimize",
    turkish: "Azaltmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 977,
  ),
  Data(
    english: "Mining",
    turkish: "Madencilik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 978,
  ),
  Data(
    english: "Ministry",
    turkish: "Bakanlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 979,
  ),
  Data(
    english: "Minute",
    turkish: "Dakika",
    level: WordLevel.a1,
    type: WordType.noun,
    id: 980,
  ),
  Data(
    english: "Miracle",
    turkish: "Mucize",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 981,
  ),
  Data(
    english: "Miserable",
    turkish: "Perişan",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 982,
  ),
  Data(
    english: "Misery",
    turkish: "Sefalet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 983,
  ),
  Data(
    english: "Misleading",
    turkish: "Yanıltıcı",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 984,
  ),
  Data(
    english: "Missile",
    turkish: "Füze",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 985,
  ),
  Data(
    english: "Mob",
    turkish: "Güruh",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 986,
  ),
  Data(
    english: "Mobile",
    turkish: "Hareketli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 987,
  ),
  Data(
    english: "Moderate",
    turkish: "Orta",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 988,
  ),
  Data(
    english: "Modest",
    turkish: "Alçakgönüllü",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 989,
  ),
  Data(
    english: "Modification",
    turkish: "Değişiklik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 990,
  ),
  Data(
    english: "Monk",
    turkish: "Keşiş",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 991,
  ),
  Data(
    english: "Monster",
    turkish: "Canavar",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 992,
  ),
  Data(
    english: "Monthly",
    turkish: "Aylık",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 993,
  ),
  Data(
    english: "Monument",
    turkish: "Anıt",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 994,
  ),
  Data(
    english: "Morality",
    turkish: "Ahlak",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 995,
  ),
  Data(
    english: "Moreover",
    turkish: "Üstelik",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 996,
  ),
  Data(
    english: "Mortgage",
    turkish: "İpotek",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 997,
  ),
  Data(
    english: "Mosque",
    turkish: "Cami",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 998,
  ),
  Data(
    english: "Nosquito",
    turkish: "Sivrisinek",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 999,
  ),
  Data(
    english: "Motion",
    turkish: "Hareket",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1000,
  ),
  Data(
    english: "Motivation",
    turkish: "Motivasyon",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1001,
  ),
  Data(
    english: "Motive",
    turkish: "Sebep",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1002,
  ),
  Data(
    english: "Moving",
    turkish: "Hareketli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1003,
  ),
  Data(
    english: "Mutual",
    turkish: "Karşılıklı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1004,
  ),
  Data(
    english: "Myth",
    turkish: "Efsane",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1005,
  ),
  Data(
    english: "Naked",
    turkish: "Çıplak",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1006,
  ),
  Data(
    english: "Nasty",
    turkish: "Edepsiz",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1007,
  ),
  Data(
    english: "Nationwide",
    turkish: "Ülke Çapında",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1008,
  ),
  Data(
    english: "Nearby",
    turkish: "Yakında",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1009,
  ),
  Data(
    english: "Necessity",
    turkish: "Gereklilik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1010,
  ),
  Data(
    english: "Neglect",
    turkish: "İhmal",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1011,
  ),
  Data(
    english: "Negotiation",
    turkish: "Müzakere",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1012,
  ),
  Data(
    english: "Neighborhood",
    turkish: "Komşu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1013,
  ),
  Data(
    english: "Nest",
    turkish: "Yuva",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1014,
  ),
  Data(
    english: "Net",
    turkish: "Ağ",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1015,
  ),
  Data(
    english: "Neutral",
    turkish: "Tarafsız",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1016,
  ),
  Data(
    english: "Newly",
    turkish: "Yeni",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1017,
  ),
  Data(
    english: "Newsletter",
    turkish: "Haber Bülteni",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1018,
  ),
  Data(
    english: "Noble",
    turkish: "Soylu",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1019,
  ),
  Data(
    english: "Nominate",
    turkish: "Aday Göstermek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1020,
  ),
  Data(
    english: "Nomination",
    turkish: "Adaylık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1021,
  ),
  Data(
    english: "Nominee",
    turkish: "Aday",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1022,
  ),
  Data(
    english: "Nonsense",
    turkish: "Anlamsız",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1023,
  ),
  Data(
    english: "Noon",
    turkish: "Öğle",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 1024,
  ),
  Data(
    english: "Notably",
    turkish: "Özellikle",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1025,
  ),
  Data(
    english: "Notebook",
    turkish: "Defter",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 1026,
  ),
  Data(
    english: "Notify",
    turkish: "Bildirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1027,
  ),
  Data(
    english: "Novel",
    turkish: "Roman",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1028,
  ),
  Data(
    english: "Novelist",
    turkish: "Romancı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1029,
  ),
  Data(
    english: "Nursery",
    turkish: "Kreş",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1030,
  ),
  Data(
    english: "Nursing",
    turkish: "Hemşirelik",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1031,
  ),
  Data(
    english: "Nutrition",
    turkish: "Beslenme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1032,
  ),
  Data(
    english: "Objection",
    turkish: "İtiraz",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1033,
  ),
  Data(
    english: "Observer",
    turkish: "Gözlemci",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1034,
  ),
  Data(
    english: "Obsess",
    turkish: "Saplantılı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1035,
  ),
  Data(
    english: "Obsession",
    turkish: "Saplantı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1036,
  ),
  Data(
    english: "Obstacle",
    turkish: "Engel",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1037,
  ),
  Data(
    english: "Occasional",
    turkish: "Seyrek",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1038,
  ),
  Data(
    english: "Occupation",
    turkish: "İşgal",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1039,
  ),
  Data(
    english: "Occupy",
    turkish: "İşgal Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1040,
  ),
  Data(
    english: "Occurrence",
    turkish: "Olay",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1041,
  ),
  Data(
    english: "Odds",
    turkish: "İhtimal",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1042,
  ),
  Data(
    english: "Offender",
    turkish: "Suçlu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1043,
  ),
  Data(
    english: "Offering",
    turkish: "Teklif",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1044,
  ),
  Data(
    english: "Offspring",
    turkish: "Yavru",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1045,
  ),
  Data(
    english: "Ongoing",
    turkish: "Süren",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1046,
  ),
  Data(
    english: "Openly",
    turkish: "Açıkça",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1047,
  ),
  Data(
    english: "Optimism",
    turkish: "İyimserlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1048,
  ),
  Data(
    english: "Optimistic",
    turkish: "İyimser",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1049,
  ),
  Data(
    english: "Organization",
    turkish: "Kurum",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1050,
  ),
  Data(
    english: "Originate",
    turkish: "Kaynaklanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1051,
  ),
  Data(
    english: "Outbreak",
    turkish: "Salgın",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1052,
  ),
  Data(
    english: "Outfit",
    turkish: "Kıyafet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1053,
  ),
  Data(
    english: "Outing",
    turkish: "Gezi",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1054,
  ),
  Data(
    english: "Outlook",
    turkish: "Manzara",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1055,
  ),
  Data(
    english: "Output",
    turkish: "Çıktı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1056,
  ),
  Data(
    english: "Outrage",
    turkish: "Öfke",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1057,
  ),
  Data(
    english: "Outsider",
    turkish: "Yabancı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1058,
  ),
  Data(
    english: "Outstanding",
    turkish: "Mükemmel",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1059,
  ),
  Data(
    english: "Overcome",
    turkish: "Halletmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1060,
  ),
  Data(
    english: "Overly",
    turkish: "Aşırı",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1061,
  ),
  Data(
    english: "Oversee",
    turkish: "Denetlemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1062,
  ),
  Data(
    english: "Overturn",
    turkish: "Devirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1063,
  ),
  Data(
    english: "Overwhelm",
    turkish: "Kaplamak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1064,
  ),
  Data(
    english: "Overwhelming",
    turkish: "Ezici",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1065,
  ),
  Data(
    english: "Ownership",
    turkish: "Sahiplik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1066,
  ),
  Data(
    english: "Oxygen",
    turkish: "Oksijen",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1067,
  ),
  Data(
    english: "Packet",
    turkish: "Paket",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1068,
  ),
  Data(
    english: "Parade",
    turkish: "Geçit",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1069,
  ),
  Data(
    english: "Partial",
    turkish: "Kısmi",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1070,
  ),
  Data(
    english: "Partially",
    turkish: "Kısmen",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1071,
  ),
  Data(
    english: "Participation",
    turkish: "Katılım",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1072,
  ),
  Data(
    english: "Partnership",
    turkish: "Ortaklık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1073,
  ),
  Data(
    english: "Passing",
    turkish: "Geçici",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1074,
  ),
  Data(
    english: "Passionate",
    turkish: "Tutkulu",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1075,
  ),
  Data(
    english: "Passive",
    turkish: "Pasif",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1076,
  ),
  Data(
    english: "Password",
    turkish: "Şifre",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1077,
  ),
  Data(
    english: "Patch",
    turkish: "Yama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1078,
  ),
  Data(
    english: "Pathway",
    turkish: "Patika",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1079,
  ),
  Data(
    english: "Patience",
    turkish: "Sabır",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1080,
  ),
  Data(
    english: "Patrol",
    turkish: "Devriye",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1081,
  ),
  Data(
    english: "Peak",
    turkish: "Zirve",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1082,
  ),
  Data(
    english: "Peasant",
    turkish: "Köylü",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1083,
  ),
  Data(
    english: "Peculiar",
    turkish: "Tuhaf",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1084,
  ),
  Data(
    english: "Peer",
    turkish: "Akran",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1085,
  ),
  Data(
    english: "Penalty",
    turkish: "Ceza",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1086,
  ),
  Data(
    english: "Pension",
    turkish: "Emeklilik",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1087,
  ),
  Data(
    english: "Perceive",
    turkish: "Algılamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1088,
  ),
  Data(
    english: "Perception",
    turkish: "Algılama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1089,
  ),
  Data(
    english: "Permanent",
    turkish: "Kalıcı",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 1090,
  ),
  Data(
    english: "Persist",
    turkish: "Sürdürmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1091,
  ),
  Data(
    english: "Persistent",
    turkish: "Süregelen",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1092,
  ),
  Data(
    english: "Petition",
    turkish: "Dilekçe",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1093,
  ),
  Data(
    english: "Pharmacy",
    turkish: "Eczane",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1094,
  ),
  Data(
    english: "Philosopher",
    turkish: "Filozof",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1095,
  ),
  Data(
    english: "Philosophical",
    turkish: "Filozofik",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1096,
  ),
  Data(
    english: "Physician",
    turkish: "Doktor",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1097,
  ),
  Data(
    english: "Pill",
    turkish: "Hap",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1098,
  ),
  Data(
    english: "Pioneer",
    turkish: "Öncü",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1099,
  ),
  Data(
    english: "Pirate",
    turkish: "Korsan",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1100,
  ),
  Data(
    english: "Pit",
    turkish: "Çukur",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1101,
  ),
  Data(
    english: "Compute",
    turkish: "Hesaplamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1KI4DZM4pHVmOtnWbu0J_DjGNK0J7IQJH",
    id: 1102,
  ),
  Data(
    english: "Pity",
    turkish: "Acıma",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1103,
  ),
  Data(
    english: "Placement",
    turkish: "Yerleştirme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1104,
  ),
  Data(
    english: "Plea",
    turkish: "Savunma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1105,
  ),
  Data(
    english: "Plead",
    turkish: "Savunmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1106,
  ),
  Data(
    english: "Pledge",
    turkish: "Taahhüt",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1107,
  ),
  Data(
    english: "Plug",
    turkish: "Fiş",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1108,
  ),
  Data(
    english: "Plunge",
    turkish: "Düşüş",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1109,
  ),
  Data(
    english: "Pole",
    turkish: "Kutup",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1110,
  ),
  Data(
    english: "Poll",
    turkish: "Anket",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1111,
  ),
  Data(
    english: "Pond",
    turkish: "Gölet",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1112,
  ),
  Data(
    english: "Portion",
    turkish: "Porsiyon",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1113,
  ),
  Data(
    english: "Portray",
    turkish: "Betimlemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1114,
  ),
  Data(
    english: "Postpone",
    turkish: "Ertelemek",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1115,
  ),
  Data(
    english: "Postwar",
    turkish: "Savaş Sonrası",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1116,
  ),
  Data(
    english: "Preach",
    turkish: "Vaaz Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1117,
  ),
  Data(
    english: "Precedent",
    turkish: "Emsal",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1118,
  ),
  Data(
    english: "Precious",
    turkish: "Değerli",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1119,
  ),
  Data(
    english: "Precise",
    turkish: "Kesin",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1120,
  ),
  Data(
    english: "Precisely",
    turkish: "Kesinlikle",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1121,
  ),
  Data(
    english: "Precision",
    turkish: "Kesinlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1122,
  ),
  Data(
    english: "Predator",
    turkish: "Yırtıcı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1123,
  ),
  Data(
    english: "Predecessor",
    turkish: "Öncül",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1124,
  ),
  Data(
    english: "Predominantly",
    turkish: "Çoğunlukla",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1125,
  ),
  Data(
    english: "Preference",
    turkish: "Tercih",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1126,
  ),
  Data(
    english: "Pregnancy",
    turkish: "Hamilelik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1127,
  ),
  Data(
    english: "Prejudice",
    turkish: "Önyargı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1128,
  ),
  Data(
    english: "Preliminary",
    turkish: "Başlangıç",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1129,
  ),
  Data(
    english: "Premier",
    turkish: "Başlıca",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1130,
  ),
  Data(
    english: "Prescribe",
    turkish: "Buyurmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1131,
  ),
  Data(
    english: "Prescription",
    turkish: "Reçete",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1132,
  ),
  Data(
    english: "Presently",
    turkish: "Şimdi",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1133,
  ),
  Data(
    english: "Preservation",
    turkish: "Koruma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1134,
  ),
  Data(
    english: "Preside",
    turkish: "Yönetmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1135,
  ),
  Data(
    english: "Presidency",
    turkish: "Başkanlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1136,
  ),
  Data(
    english: "Prestigious",
    turkish: "Prestijli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1137,
  ),
  Data(
    english: "Presumably",
    turkish: "Herhalde",
    level: WordLevel.c1,
    type: WordType.adverb,
    id: 1138,
  ),
  Data(
    english: "Presume",
    turkish: "Varsaymak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1139,
  ),
  Data(
    english: "Prevail",
    turkish: "Yenmek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1140,
  ),
  Data(
    english: "Prevalence",
    turkish: "Yaygınlık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1141,
  ),
  Data(
    english: "Prevention",
    turkish: "Önlem",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1142,
  ),
  Data(
    english: "Prey",
    turkish: "Kurban",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1143,
  ),
  Data(
    english: "Pride",
    turkish: "Gurur",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1144,
  ),
  Data(
    english: "Primarily",
    turkish: "Başlıca",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1145,
  ),
  Data(
    english: "Principal",
    turkish: "Ana",
    level: WordLevel.b1,
    type: WordType.adjective,
    id: 1146,
  ),
  Data(
    english: "Privatization",
    turkish: "Özelleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1147,
  ),
  Data(
    english: "Privilege",
    turkish: "Ayrıcalık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1148,
  ),
  Data(
    english: "Probability",
    turkish: "Olasılık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1149,
  ),
  Data(
    english: "Probable",
    turkish: "Olası",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1150,
  ),
  Data(
    english: "Probe",
    turkish: "Soruşturmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1151,
  ),
  Data(
    english: "Problematic",
    turkish: "Sorunlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1152,
  ),
  Data(
    english: "Proceed",
    turkish: "İlerlemek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1153,
  ),
  Data(
    english: "Proceeds",
    turkish: "Gelir",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1154,
  ),
  Data(
    english: "Process",
    turkish: "İşlem",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1155,
  ),
  Data(
    english: "Processor",
    turkish: "İşlemci",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1156,
  ),
  Data(
    english: "Proclaim",
    turkish: "Duyurmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1157,
  ),
  Data(
    english: "Productive",
    turkish: "Üretken",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1158,
  ),
  Data(
    english: "Productivity",
    turkish: "Üretkenlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1159,
  ),
  Data(
    english: "Profitable",
    turkish: "Kazançlı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1160,
  ),
  Data(
    english: "Profound",
    turkish: "Derin",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1161,
  ),
  Data(
    english: "Progressive",
    turkish: "Aydın",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1162,
  ),
  Data(
    english: "Prohibit",
    turkish: "Yasaklamak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1163,
  ),
  Data(
    english: "Prominent",
    turkish: "Önemli",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1164,
  ),
  Data(
    english: "Promotion",
    turkish: "Terfi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1165,
  ),
  Data(
    english: "Prompt",
    turkish: "Çabuk",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1166,
  ),
  Data(
    english: "Pronounced",
    turkish: "Belirgin",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1167,
  ),
  Data(
    english: "Proportion",
    turkish: "Oran",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1168,
  ),
  Data(
    english: "Proposition",
    turkish: "Öneri",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1169,
  ),
  Data(
    english: "Prosecute",
    turkish: "Kovuşturmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1170,
  ),
  Data(
    english: "Prosecution",
    turkish: "Kovuşturma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1171,
  ),
  Data(
    english: "Prosecutor",
    turkish: "Savcı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1172,
  ),
  Data(
    english: "Prospective",
    turkish: "Muhtemel",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1173,
  ),
  Data(
    english: "Prosperity",
    turkish: "Refah",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1174,
  ),
  Data(
    english: "Protective",
    turkish: "Koruyucu",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1175,
  ),
  Data(
    english: "Protester",
    turkish: "Protestocu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1176,
  ),
  Data(
    english: "Province",
    turkish: "Eyalet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1177,
  ),
  Data(
    english: "Provincial",
    turkish: "Taşra",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1178,
  ),
  Data(
    english: "Provision",
    turkish: "Sağlama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1179,
  ),
  Data(
    english: "Provoke",
    turkish: "Kışkırtmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1180,
  ),
  Data(
    english: "Publicity",
    turkish: "Tanıtım",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1181,
  ),
  Data(
    english: "Publishing",
    turkish: "Yayıncılık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1182,
  ),
  Data(
    english: "Pulse",
    turkish: "Nabız",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1183,
  ),
  Data(
    english: "Pump",
    turkish: "Pompa",
    level: WordLevel.a1,
    type: WordType.noun,
    id: 1184,
  ),
  Data(
    english: "Punch",
    turkish: "Yumruk",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1185,
  ),
  Data(
    english: "Purely",
    turkish: "Sadece",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1186,
  ),
  Data(
    english: "Pursuit",
    turkish: "Kovalama",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1187,
  ),
  Data(
    english: "Puzzle",
    turkish: "Bulmaca",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 1188,
  ),
  Data(
    english: "Query",
    turkish: "Sorgu",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1189,
  ),
  Data(
    english: "Quest",
    turkish: "Araştırma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1190,
  ),
  Data(
    english: "Questionnaire",
    turkish: "Anket",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1191,
  ),
  Data(
    english: "Quota",
    turkish: "Kota",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1192,
  ),
  Data(
    english: "Racial",
    turkish: "Irksal",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1193,
  ),
  Data(
    english: "Racism",
    turkish: "Irkçılık",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1194,
  ),
  Data(
    english: "Racist",
    turkish: "Irkçı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1195,
  ),
  Data(
    english: "Radiation",
    turkish: "Radyasyon",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1196,
  ),
  Data(
    english: "Radical",
    turkish: "Köklü",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1197,
  ),
  Data(
    english: "Rage",
    turkish: "Öfke",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1198,
  ),
  Data(
    english: "Raid",
    turkish: "Yağma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1199,
  ),
  Data(
    english: "Rail",
    turkish: "Demiryolu",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1200,
  ),
  Data(
    english: "Rally",
    turkish: "Miting",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1201,
  ),
  Data(
    english: "Random",
    turkish: "Rastgele",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1202,
  ),
  Data(
    english: "Ranking",
    turkish: "Sıralama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1203,
  ),
  Data(
    english: "Rat",
    turkish: "Fare",
    level: WordLevel.a2,
    type: WordType.noun,
    id: 1204,
  ),
  Data(
    english: "Rating",
    turkish: "Değerlendirme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1205,
  ),
  Data(
    english: "Ratio",
    turkish: "Oran",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1206,
  ),
  Data(
    english: "Rational",
    turkish: "Akılcı",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1207,
  ),
  Data(
    english: "Ray",
    turkish: "Işın",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1208,
  ),
  Data(
    english: "Readily",
    turkish: "Kolayca",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1209,
  ),
  Data(
    english: "Realization",
    turkish: "Gerçekleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1210,
  ),
  Data(
    english: "Realm",
    turkish: "Krallık",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1211,
  ),
  Data(
    english: "Rear",
    turkish: "Arka",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1212,
  ),
  Data(
    english: "Reasonably",
    turkish: "Makul",
    level: WordLevel.b2,
    type: WordType.adverb,
    id: 1213,
  ),
  Data(
    english: "Reasoning",
    turkish: "Muhakeme",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1214,
  ),
  Data(
    english: "Rebel",
    turkish: "İsyancı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1215,
  ),
  Data(
    english: "Rebellion",
    turkish: "İsyancı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1216,
  ),
  Data(
    english: "Receiver",
    turkish: "Alıcı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1217,
  ),
  Data(
    english: "Recession",
    turkish: "Durgunluk",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1218,
  ),
  Data(
    english: "Recipient",
    turkish: "Alıcı",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1219,
  ),
  Data(
    english: "Reckon",
    turkish: "Sanmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1220,
  ),
  Data(
    english: "Recognition",
    turkish: "Tanıma",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1221,
  ),
  Data(
    english: "Recovery",
    turkish: "İyileşme",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1222,
  ),
  Data(
    english: "Recruit",
    turkish: "Acemi",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1223,
  ),
  Data(
    english: "Referee",
    turkish: "Hakem",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1224,
  ),
  Data(
    english: "Reflection",
    turkish: "Refleks",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1225,
  ),
  Data(
    english: "Reform",
    turkish: "Islah",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1226,
  ),
  Data(
    english: "Refuge",
    turkish: "Sığınma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1227,
  ),
  Data(
    english: "Refugee",
    turkish: "Sığınmacı",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1228,
  ),
  Data(
    english: "Refusal",
    turkish: "Reddetmek",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1229,
  ),
  Data(
    english: "Regime",
    turkish: "Rejim",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1230,
  ),
  Data(
    english: "Registration",
    turkish: "Kayıt",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1231,
  ),
  Data(
    english: "Regulate",
    turkish: "Düzenlemek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1232,
  ),
  Data(
    english: "Regulator",
    turkish: "Düzenleyici",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1233,
  ),
  Data(
    english: "Reign",
    turkish: "Saltanat",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1234,
  ),
  Data(
    english: "Reinforce",
    turkish: "Güçlendirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1235,
  ),
  Data(
    english: "Rejection",
    turkish: "Red",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1236,
  ),
  Data(
    english: "Relevance",
    turkish: "İlgi",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1237,
  ),
  Data(
    english: "Reliability",
    turkish: "Güvenilirlik",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1238,
  ),
  Data(
    english: "Relieve",
    turkish: "Rahatlatmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1239,
  ),
  Data(
    english: "Relieved",
    turkish: "Rahatlamış",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1240,
  ),
  Data(
    english: "Reluctant",
    turkish: "İsteksiz",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1241,
  ),
  Data(
    english: "Remainder",
    turkish: "Kalan",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1242,
  ),
  Data(
    english: "Remain",
    turkish: "Kalmak",
    level: WordLevel.b2,
    type: WordType.verb,
    id: 1243,
  ),
  Data(
    english: "Remarkable",
    turkish: "Olağanüstü",
    level: WordLevel.b2,
    type: WordType.adjective,
    id: 1244,
  ),
  Data(
    english: "Remedy",
    turkish: "Çare",
    level: WordLevel.b2,
    type: WordType.noun,
    id: 1245,
  ),
  Data(
    english: "Reminder",
    turkish: "Hatırlatma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1246,
  ),
  Data(
    english: "Removal",
    turkish: "Kaldırma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1247,
  ),
  Data(
    english: "Renew",
    turkish: "Yenilemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1248,
  ),
  Data(
    english: "Renowned",
    turkish: "Meşhur",
    level: WordLevel.c1,
    type: WordType.adjective,
    id: 1249,
  ),
  Data(
    english: "Rental",
    turkish: "Kiralama",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1250,
  ),
  Data(
    english: "Reporting",
    turkish: "Raporlama",
    level: WordLevel.b1,
    type: WordType.noun,
    id: 1251,
  ),
  Data(
    english: "Representation",
    turkish: "Temsil",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1252,
  ),
  Data(
    english: "Reproduce",
    turkish: "Çoğaltmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1253,
  ),
  Data(
    english: "Reproduction",
    turkish: "Çoğalma",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1254,
  ),
  Data(
    english: "Republic",
    turkish: "Cumhuriyet",
    level: WordLevel.c1,
    type: WordType.noun,
    id: 1255,
  ),
  Data(
    english: "Resemble",
    turkish: "Benzemek",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1256,
  ),
  Data(
    english: "Reside",
    turkish: "Oturmak",
    level: WordLevel.c1,
    type: WordType.verb,
    id: 1257,
  ),
  // Data(
  //   english: "Residence",
  //   turkish: "Konut",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1258,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
  // Data(
  //   english: "E",
  //   turkish: "T",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   id: 1201,
  // ),
];
