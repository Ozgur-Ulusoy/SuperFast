import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/homepage_notifi_alert_cubit.dart';
import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Screens/MainPage.dart';
import 'package:engame2/Presentation_Layer/Screens/MyWordsPage.dart';
import 'package:engame2/Presentation_Layer/Screens/Play/EngamePage.dart';
import 'package:engame2/Presentation_Layer/Screens/Auth/RegisterPage.dart';
import 'package:engame2/Presentation_Layer/Screens/Play/WordGamePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:upgrader/upgrader.dart';
import 'package:workmanager/workmanager.dart';

import 'Business_Layer/cubit/answer_cubit.dart';
import 'Business_Layer/cubit/cubit/word_filter_cubit.dart';
import 'Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'Business_Layer/cubit/question_cubit.dart';
import 'Business_Layer/cubit/timer_cubit.dart';
import 'Presentation_Layer/Screens/FirstPage.dart';
import 'Presentation_Layer/Screens/HomePage.dart';
import 'Presentation_Layer/Screens/Auth/LoginPage.dart';
import 'Presentation_Layer/Screens/Play/SoundGamePage.dart';
import 'Presentation_Layer/Screens/ProfilePage.dart';
import 'Presentation_Layer/Screens/SettingsPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //! DEBUG
  // RequestConfiguration configuration =
  //     RequestConfiguration(testDeviceIds: ["71E560CE43A9A87F70D994CE11BEAA10"]);
  // MobileAds.instance.updateRequestConfiguration(configuration);
  //!
  await Firebase.initializeApp();
  await refleshUser();

  //! Test for duplicate id - DebuG
  // List<int> a = [];
  // for (var i = 1; i < questionData.length; i++) {
  //   if (a.contains(questionData[i].id) == false) {
  //     a.add(questionData[i].id);
  //   } else {
  //     print("duplicate id: ${questionData[i].id}");
  //   }
  //   if (questionData[i].english == "EN" || questionData[i].english == "E") {
  //     print("EN: ${questionData[i].id}");
  //   }
  //   if (questionData[i].turkish == "TR" || questionData[i].turkish == "T") {
  //     print("TR: ${questionData[i].id}");
  //   }
  // }

  //! WorkManager
  await Workmanager().initialize(
    // The top level function, aka callbackDispatcher
    callbackDispatcher,

    // If enabled it will post a notification whenever
    // the task is running. Handy for debugging tasks
    isInDebugMode: false,
  );

  await Workmanager().registerPeriodicTask(
      "dailyRandomWordTaskID",

      //This is the value that will be
      // returned in the callbackDispatcher
      "dailyRandomWordTask",
      initialDelay: const Duration(hours: 1), //! 1 saat olucak
      // When no frequency is provided
      // the default 15 minutes is set.
      // Minimum frequency is 15 min.
      // Android will automatically change
      // your frequency to 15 min
      // if you have configured a lower frequency.
      frequency: const Duration(days: 1), //! 1 gün olucak
      existingWorkPolicy: ExistingWorkPolicy.append);

  await fLoadData();
  await setMainDataDailyWord(); //? set daily word
  await fLoadSvgPictures();
  // Test(); //? Test
  //
  // LicenseRegistry.addLicense(() async* {
  //   //? google fonts license
  //   final license = await rootBundle.loadString('google_fonts/OFL.txt');
  //   yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  // });

  //! FirebaseMessaging
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true, // Required to display a heads up notification
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

//! WorkManager
@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    //?
    if (task == "dailyRandomWordTask") {
      await setRandomDailyWord();
    }
    return Future.value(true);
  });
}

Future<void> setRandomDailyWord() async {
  await Hive.initFlutter();
  Box box = await Hive.openBox("SuperFastBox");
  Random rnd = Random();
  int random = rnd.nextInt(questionData.length - 1) + 1;
  await box.put(KeyUtils.dailyWordIdKey, random);

  print(box.get(KeyUtils.dailyWordIdKey, defaultValue: 1).toString() + "a");
  print(random.toString() + "b");
  String learnedList = box.get(KeyUtils.learnedListValueKey, defaultValue: "");
  List<Data> learnedDatas = [];
  List<Data> notLearnedDatas = [];

  if (learnedList != "") {
    String data = learnedList;
    data.trim().split(" ").forEach((e) {
      if (int.tryParse(e) != null) {
        Data data =
            questionData.firstWhere((element) => element.id == int.tryParse(e));
        data.favType = WordFavType.learned;
        learnedDatas.add(data);
      }
    });
  }

  notLearnedDatas = questionData
      .where((element) => element.favType == WordFavType.nlearned)
      .toList();

  List<Data> datas = learnedDatas + notLearnedDatas;
  Data dailyData;
  try {
    dailyData = datas.where((element) => element.id == random).first;
  } catch (e) {
    dailyData = datas.first;
  }
  bool isNotificationsOn =
      await box.get(KeyUtils.isGetNotificationOnKey, defaultValue: true);
  if (isNotificationsOn) {
    await Firebase.initializeApp();

    await setupFlutterNotifications();

    await setNotificationSettings();

    await flutterLocalNotificationsPlugin.show(
      1,
      "Günün Kelimesi : ${dailyData.english}",
      "Türkçesi : ${dailyData.turkish}",
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          importance: Importance.high,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: '@mipmap/notification_icon',
          color: const Color.fromRGBO(76, 81, 198, 1),
        ),
      ),
      // payload: jsonEncode({
      //   "type": "openDailyWord",
      //   "action": "FLUTTER_NOTIFICATION_CLICK",
      // }),
    );
  }

  MainData.dailyData = dailyData;
  print(MainData.dailyData);
  // await setMainDataDailyWord();
  // HomePage.createKey().currentState!.getRandomDailyWord();
}

Future<void> setNotificationSettings() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/notification_icon');

  // const IOSInitializationSettings initializationSettingsIOS =
  //     IOSInitializationSettings(
  //   requestSoundPermission: false,
  //   requestBadgePermission: false,
  //   requestAlertPermission: false,
  //   // onDidReceiveLocalNotification: onDidReceiveLocalNotification,
  // );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
      macOS: null);

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    // onDidReceiveNotificationResponse: selectNotification,
  );
}

// Future selectNotification(String? payload) async {
//   //Handle notification tapped logic here
//   print("selected");
//   Map data = jsonDecode(payload!);
//   print("payload : $data");
//   if (data["type"] == "openDailyWord" &&
//       FirebaseAuth.instance.currentUser != null) {
//     await setMainDataDailyWord();
//     HomePage.createKey().currentState!.getRandomDailyWord();
//     // HomePage.scaffoldKey.currentState!.setState(() {
//     //   HomePage.scaffoldKey.currentState
//     // });
//   }
// }

//! Bu fonksiyon calisiyordu - fload dataya tasıyacagım
Future<void> setMainDataDailyWord() async {
  await Hive.initFlutter();
  Box box = await Hive.openBox(KeyUtils.boxName);
  int randomIndex = box.get(KeyUtils.dailyWordIdKey, defaultValue: 1);
  print(randomIndex.toString() + " " + "setMainDataDailyWord");
  List<Data> allList = MainData.learnedDatas! + MainData.notLearnedDatas!;
  try {
    MainData.dailyData =
        allList.where((element) => element.id == randomIndex).first;
  } catch (e) {
    MainData.dailyData = allList.first;
  }
}

//! Notification
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await setupFlutterNotifications();
  // showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: '@mipmap/notification_icon',
            color: const Color.fromRGBO(76, 81, 198, 1)),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future refleshUser() async {
  try {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.reload();
    }
  } catch (e) {}
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getNotifiInApp();
    MobileAds.instance.initialize();
    // DebuG
    LicenseRegistry.addLicense(() async* {
      //? google fonts license
      final license = await rootBundle.loadString('google_fonts/OFL.txt');
      yield LicenseEntryWithLineBreaks(['google_fonts'], license);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resume");
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,
        // FirebaseMethods().updateLiveStatus(_authInstance.currentUser.uid, true);
        break;
      case AppLifecycleState.paused:
        print("pause");
        //Execute the code the when user leave the app
        // FirebaseMethods()
        //     .updateLiveStatus(_authInstance.currentUser.uid, false);
        break;

      case AppLifecycleState.inactive:
        print("inactive");
        if (FirebaseAuth.instance.currentUser != null &&
            FirebaseAuth.instance.currentUser!.isAnonymous == false &&
            MainData.isFirstOpen == false) {
          try {
            if (MainData.isFavListChanged == true) {
              await FirebaseFirestore.instance
                  .collection(KeyUtils.usersCollectionKey)
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'favList': MainData.favList});
              MainData.isFavListChanged = false;
              print("favList changed");
            }
            if (MainData.isLearnedListChanged == true) {
              await FirebaseFirestore.instance
                  .collection(KeyUtils.usersCollectionKey)
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .update({'learnedList': MainData.learnedList});
              MainData.isLearnedListChanged = false;
              print("learnedList changed");
            }
          } on Exception {
            // TODO
            MainData.isFavListChanged = true;
            MainData.isLearnedListChanged = true;
            await MainData.localData!.put(KeyUtils.isFavListChangedKey, true);
            await MainData.localData!
                .put(KeyUtils.isLearnedListChangedKey, true);
          }
        }

        break;

      case AppLifecycleState.detached:
        print("detached");

        break;

      default:
        break;
    }
  }

  // void _runWhileAppIsTerminated() async {
  //   var details =
  //       await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  //   if (details!.didNotificationLaunchApp) {
  //     if (details.payload != null) {
  //       print('notification payload: ' + details.payload!);
  //       var payload = jsonDecode(details.payload!);
  //       if (payload!["action"] == "openDailyWord") {
  //         await setMainDataDailyWord();
  //         await HomePage.createKey().currentState!.getRandomDailyWord();
  //       }
  //     }
  //   }
  // }

  // Future<void> initSetRandomlyWord() async {
  //   await Workmanager().registerPeriodicTask(
  //       "dailyRandomWordTaskID",

  //       //This is the value that will be
  //       // returned in the callbackDispatcher
  //       "dailyRandomWordTask",
  //       initialDelay: const Duration(seconds: 15), //! 1 saat olucak
  //       // When no frequency is provided
  //       // the default 15 minutes is set.
  //       // Minimum frequency is 15 min.
  //       // Android will automatically change
  //       // your frequency to 15 min
  //       // if you have configured a lower frequency.
  //       frequency: const Duration(minutes: 15), //! 1 gün olucak
  //       existingWorkPolicy: ExistingWorkPolicy.append);
  // }

  Future<void> getNotifiInApp() async {
    await setupFlutterNotifications();
    FirebaseMessaging.onMessage.listen((event) {
      showFlutterNotification(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        //* soru -  cevap - doğru cevap sayısı - puan - şıkları içerir
        BlocProvider(
          create: (context) => QuestionCubit(),
        ),

        //* kullanıcının seçtiği şıkları tutar
        BlocProvider(
          create: (context) => AnswerCubit(),
        ),

        //* zaman için
        BlocProvider(
          create: (context) => TimerCubit(),
        ),

        BlocProvider(
          create: (context) => LoginPageCubit(),
        ),

        BlocProvider(
          create: (context) => HomePageSelectedWordCubit(),
        ),

        BlocProvider(
          create: (context) => HomepageNotifiAlertCubit(),
        ),

        BlocProvider(
          create: (context) => WordFilterCubit(),
        ),
      ],
      child: UpgradeAlert(
        upgrader: Upgrader(
          languageCode: "tr",
          messages: UpgraderMessages(code: "tr"),
          durationUntilAlertAgain: const Duration(days: 1),
          shouldPopScope: () => true,
          canDismissDialog: true,
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'SuperFast', //!
          // theme: ThemeData(
          //   primarySwatch: Colors.blue,
          // ),
          // home: const MainPage(),
          initialRoute: KeyUtils.initialPageKey,
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            KeyUtils.initialPageKey: (context) => const MainPage(),
            KeyUtils.firstOpenPageKey: (context) => const FirstOpenPage(),
            KeyUtils.loginPageKey: (context) => const LoginPage(),
            KeyUtils.homePageKey: (context) => HomePage(),
            KeyUtils.registerPageKey: (context) => const RegisterPage(),
            KeyUtils.testGamePageKey: (context) => const EngamePage(),
            KeyUtils.letterGamePageKey: (context) => const WordGamePage(),
            KeyUtils.soundGamePageKey: (context) => const SoundGamePage(),
            KeyUtils.wordsPageKey: (context) => const MyWordsPage(),
            KeyUtils.settingsPageKey: (context) => const SettingsPage(),
            KeyUtils.profilePageKey: (context) => const ProfilePage(),
          },
        ),
      ),
    );
  }
}

//* Ana Sayfa => Rekor - Oyna Tuşu - Ses Açık/Kapalı tuşu
