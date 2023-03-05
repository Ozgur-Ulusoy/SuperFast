import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Data_Layer/test.dart';
import 'package:engame2/Presentation_Layer/Screens/MainPage.dart';
import 'package:engame2/Presentation_Layer/Screens/MyWordsPage.dart';
import 'package:engame2/Presentation_Layer/Screens/Play/EngamePage.dart';
import 'package:engame2/Presentation_Layer/Screens/Auth/RegisterPage.dart';
import 'package:engame2/Presentation_Layer/Screens/Play/WordGamePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upgrader/upgrader.dart';

import 'Business_Layer/cubit/answer_cubit.dart';
import 'Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'Business_Layer/cubit/question_cubit.dart';
import 'Business_Layer/cubit/timer_cubit.dart';
import 'Presentation_Layer/Screens/FirstPage.dart';
import 'Presentation_Layer/Screens/HomePage.dart';
import 'Presentation_Layer/Screens/Auth/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await refleshUser();
  await fLoadData();
  await fLoadSvgPictures();
  Test(); //? Test
  LicenseRegistry.addLicense(() async* {
    //? google fonts license
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });
  runApp(const MyApp());
}

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
            FirebaseAuth.instance.currentUser!.isAnonymous == false) {
          if (MainData.isFavListChanged == true) {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({'favList': MainData.favList});
            MainData.isFavListChanged = false;
          }
          if (MainData.isLearnedListChanged == true) {
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({'learnedList': MainData.learnedList});
            MainData.isLearnedListChanged = false;
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
          initialRoute: '/',
          routes: {
            // When navigating to the "/" route, build the FirstScreen widget.
            '/': (context) => const MainPage(),
            '/firstOpenPage': (context) => const FirstOpenPage(),
            '/loginPage': (context) => const LoginPage(),
            '/homePage': (context) => const HomePage(),
            '/registerPage': (context) => const RegisterPage(),
            // '/playClassicMode': (context) => const PlayPage(), //! sonradan düzeltilicek
            '/playEngameMode': (context) => const EngamePage(),
            '/playWordGameMode': (context) => const WordGamePage(),
            '/myWordsPage': (context) => const MyWordsPage(),
          },
        ),
      ),
    );
  }
}

//* Ana Sayfa => Rekor - Oyna Tuşu - Ses Açık/Kapalı tuşu
