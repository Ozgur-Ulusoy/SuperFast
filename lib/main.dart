import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Data_Layer/test.dart';
import 'package:engame2/Presentation_Layer/Screens/MainPage.dart';
import 'package:engame2/Presentation_Layer/Screens/PlayPage.dart';
import 'package:engame2/Presentation_Layer/Screens/RegisterPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Business_Layer/cubit/answer_cubit.dart';
import 'Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'Business_Layer/cubit/question_cubit.dart';
import 'Business_Layer/cubit/timer_cubit.dart';
import 'Presentation_Layer/Screens/FirstPage.dart';
import 'Presentation_Layer/Screens/HomePage.dart';
import 'Presentation_Layer/Screens/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await refleshUser();
  await fLoadData(isInitial: true);
  Test(); //? Test
  runApp(const MyApp());
}

Future refleshUser() async {
  try {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseAuth.instance.currentUser!.reload();
    }
  } catch (e) {}
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
          '/playClassicMode': (context) => const PlayPage(),
        },
      ),
    );
  }
}

//* Ana Sayfa => Rekor - Oyna Tuşu - Ses Açık/Kapalı tuşu
