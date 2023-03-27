import 'package:flutter/material.dart';

Color cBackgroundColor = const Color.fromRGBO(233, 244, 255, 1);
Color cBlueBackground = const Color.fromRGBO(76, 81, 198, 1);

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // path.moveTo(size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    // path.addArc(Rect.largest, 15, 45);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => true;
}

class ScreenUtil {
  static double height = 1920;
  static double width = 1080;
  static double textScaleFactor = 1.5;
  static double wordSpacing = 1.5;
  static double letterSpacing = 1;
  static double topPadding = 0;

  static void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    // _mediaQueryData = mediaQuery;
    // _pixelRatio = mediaQuery.devicePixelRatio;
    width = mediaQuery.size.width;
    height = mediaQuery.size.height;
    // _statusBarHeight = mediaQuery.padding.top;
    // bottomBarHeight = mediaQueryData.padding.bottom;
    textScaleFactor = mediaQuery.textScaleFactor;
    topPadding = AppBar().preferredSize.height + mediaQuery.padding.top;

    // print(height);
    // print(width);
  }
}

enum WordSelectedStateEnums {
  learnedWordState,
  notLearnedWordState,
  favoriteWordState,
}

class KeyUtils {
  //! Hive
  static const String boxName = "SuperFastBox";
  //? Settings
  static const String isSoundOnKey = "isSoundOn";
  static const String isGetNotificationOnKey =
      "isGetNotificationOn"; // isGetNotificationOn
  static const String isEngameControlButtonOnKey = "isEngameControlButtonOn";
  static const String isBatteryOptimizeDisabledKey =
      "isBatteryOptimizeDisabled";
  static const String isAutoRestartEnabledForBackgroundKey =
      "isAutoRestartEnabledForBackground";
  static const String isShowDailyWordOnKey = "isShowDailyWordOn";
  static const String isShowHomePageNotifiAlertOnKey = "isShowHomePageNotifiOn";
  //?
  static const String isFirstOpenKey = "isFirstOpen";
  static const String dailyWordIdKey = "dailyWordId";
  static const String isEngameGameRecordChangedKey =
      "isEngameGameRecordChanged";
  static const String isSoundGameRecordChangedKey = "isSoundGameRecordChanged";
  static const String isWordleGameRecordChangedKey =
      "isWordleGameRecordChanged";
  static const String isLetterGameRecordChangedKey =
      "isLetterGameRecordChanged";

  static const String isGoogleGamesSignedInKey = "isGoogleGamesSignedIn";

  //? Ads
  // static const String canWatchVideoAdKey = "canWatchVideoAd";
  static const String lastWatchedAdTime = "lastWatchedAdTime";
  static int adWatchVideoDelayMinute = 4;
  static String videoAdDelayWMKey = "watchVideoAdDelay";

  //? Firebase
  static const String isFavListChangedKey = "isFavListChanged";
  static const String isLearnedListChangedKey = "isLearnedListChanged";
  static const String usersCollectionKey = "Users";
  static const String favListValueKey = "favList";
  static const String learnedListValueKey = "learnedList";
  static const String userUIDKey = "UserUID";
  static const String usernameKey = "username";
  static const String gameRecordsMapKey = "GameRecors";
  static const String engameGameRecordKey = "engameGameRecord";
  static const String soundGameRecordKey = "soundGameRecord";
  static const String wordleGameRecordKey = "wordleGameRecord";
  static const String letterGameRecordKey = "letterGameRecord";

  //! Firebase Notification
  static String notificationTopicKey = "notificationTopic";

  //? ROUTES
  static const String initialPageKey = '/';
  static const String firstOpenPageKey = '/firstOpenPage';
  static const String loginPageKey = '/loginPage';
  static const String homePageKey = '/homePage';
  static const String registerPageKey = '/registerPage';
  static const String testGamePageKey = '/testGamePage';
  static const String letterGamePageKey = '/letterGamePage';
  static const String soundGamePageKey = '/soundGamePage';
  static const String wordsPageKey = '/wordsPage';
  static const String settingsPageKey = '/settingsPage';
  static const String profilePageKey = '/profilePage';
}
