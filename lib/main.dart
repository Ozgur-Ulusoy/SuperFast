import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Data_Layer/test.dart';
import 'package:engame2/Presentation_Layer/Screens/MainPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Business_Layer/cubit/answer_cubit.dart';
import 'Business_Layer/cubit/question_cubit.dart';
import 'Business_Layer/cubit/timer_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await fLoadData();
  Test(); //? Test
  runApp(const MyApp());
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo', //!
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainPage(),
      ),
    );
  }
}

//* Ana Sayfa => Rekor - Oyna Tuşu - Ses Açık/Kapalı tuşu
