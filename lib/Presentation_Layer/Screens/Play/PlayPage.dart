// import 'dart:async';

// import 'package:audioplayers/audioplayers.dart';
// import 'package:engame2/Data_Layer/data.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../../Business_Layer/cubit/answer_cubit.dart';
// import '../../../Business_Layer/cubit/question_cubit.dart';
// import '../../../Business_Layer/cubit/timer_cubit.dart';

// class PlayPage extends StatefulWidget {
//   const PlayPage({Key? key}) : super(key: key);

//   @override
//   State<PlayPage> createState() => _PlayPageState();
// }

// class _PlayPageState extends State<PlayPage> {
//   Timer? timer;
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   //! Ses Oynatma

//   // late Source s;

//   void StartTimer() {
//     BlocProvider.of<TimerCubit>(context).ResetTime();
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       BlocProvider.of<TimerCubit>(context).DecreaseTime();
//       if (BlocProvider.of<TimerCubit>(context).state.remainTime <= 0) {
//         timer.cancel();
//         print("end");
//         //! puan ekranı
//       }
//     });
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     //* sayfa açıldığında ilk olarak eski cevap - soru ve şıkları resetler
//     BlocProvider.of<AnswerCubit>(context)
//         .ResetAnswer(); //* kullanıcnın cevabını resetledi
//     BlocProvider.of<QuestionCubit>(
//             context) //! tipi kullanıcının seçtiği türden olacak
//         .ChangeQuestion(type: QuestionType.turkish); //* ilk soruyu sordu
//     BlocProvider.of<AnswerCubit>(context).ResetIsPressList(
//         BlocProvider.of<QuestionCubit>(context)
//             .state
//             .letters!
//             .length); //* kullanıcının seçtiği şıkları resetledi

//     StartTimer();
//     _audioPlayer.setPlayerMode(PlayerMode.mediaPlayer);
//     _audioPlayer.setVolume(1);
//   }

//   int ReturnGLIndex(int a) {
//     int res = 0;
//     for (var i = 0; i < a; i++) {
//       res += BlocProvider.of<QuestionCubit>(context)
//           .state
//           .answer
//           .split(" ")[i]
//           .length;
//     }
//     return res;
//   }

//   int ReturnIsPressedIndex(int a) {
//     if ((BlocProvider.of<AnswerCubit>(context).state as NormalAnswerState)
//             .answerList!
//             .length <=
//         a) {
//       return -1;
//     }

//     for (var i = 0;
//         i < BlocProvider.of<QuestionCubit>(context).state.letters!.length;
//         i++) {
//       if (BlocProvider.of<QuestionCubit>(context).state.letters![i] ==
//               (BlocProvider.of<AnswerCubit>(context).state as NormalAnswerState)
//                   .answerList![a] &&
//           (BlocProvider.of<AnswerCubit>(context).state as NormalAnswerState)
//                   .isPressedList![i] ==
//               true) {
//         return i;
//       }
//     }
//     return -1;
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     timer!.cancel();
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double w = MediaQuery.of(context).size.width;
//     double h = MediaQuery.of(context).size.height;
//     return Scaffold(
//       // backgroundColor: const Color.fromARGB(255, 39, 2, 126).withOpacity(0.75),
//       body: Stack(
//         children: [
//           Container(
//             width: w,
//             height: h,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   // const Color.fromARGB(255, 39, 2, 126).withOpacity(0.75),
//                   // const Color.fromARGB(255, 39, 2, 126).withOpacity(0.7),
//                   const Color.fromARGB(255, 45, 9, 128).withOpacity(0.75),
//                   const Color.fromARGB(255, 45, 9, 128).withOpacity(0.7),
//                 ],
//               ),
//             ),
//           ),
//           SafeArea(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(right: w * 0.05),
//                     child: Row(
//                       children: [
//                         IconButton(
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                           icon: const Icon(Icons.arrow_back),
//                         ),
//                         const Spacer(),
//                         BlocBuilder<TimerCubit, TimerState>(
//                           builder: (context, state) {
//                             return Text(
//                               state.remainTime.toString(),
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 22,
//                               ),
//                             );
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   BlocBuilder<QuestionCubit, QuestionState>(
//                     builder: (context, state) {
//                       return MaterialButton(
//                         color: Colors.red,
//                         onPressed: () async {
//                           await _audioPlayer
//                               .play(UrlSource(state.data.mediaLink));
//                         },
//                       );
//                     },
//                   ),
//                   //* Soru
//                   BlocBuilder<QuestionCubit, QuestionState>(
//                     builder: (context, state) {
//                       return Text(state.question);
//                     },
//                   ),

//                   //! Test için var - kaldırılacak
//                   BlocBuilder<QuestionCubit, QuestionState>(
//                     builder: (context, state) {
//                       return Text(state.answer);
//                     },
//                   ),

//                   //* kelime sayısı kadar alt alta
//                   //* her kelime sayısındaki harf kadar grid

//                   BlocBuilder<AnswerCubit, AnswerState>(
//                     builder: (context, state) {
//                       return Padding(
//                         padding: EdgeInsets.all(w * 0.025),
//                         child: ListView.separated(
//                             physics: const BouncingScrollPhysics(),
//                             separatorBuilder: (context, index) {
//                               return SizedBox(
//                                 height: h * 0.01,
//                               );
//                             },
//                             shrinkWrap: true,
//                             itemCount: BlocProvider.of<QuestionCubit>(context)
//                                 .state
//                                 .answer
//                                 .split(" ")
//                                 .length,
//                             itemBuilder: (context, int glindex) {
//                               return GridView.builder(
//                                 //* Kullanıcının şıkları seçerek doldurması gereken cevap alanı => şıklarla cevabı teker teker oluşturur
//                                 physics: const BouncingScrollPhysics(),
//                                 shrinkWrap: true,
//                                 itemCount: BlocProvider.of<QuestionCubit>(
//                                                 context)
//                                             .state
//                                             .answer
//                                             .split(" ") ==
//                                         []
//                                     ? BlocProvider.of<QuestionCubit>(context)
//                                         .state
//                                         .answer
//                                         .length
//                                     : BlocProvider.of<QuestionCubit>(context)
//                                         .state
//                                         .answer
//                                         .split(" ")[glindex]
//                                         .length, //* sorunun harf sayısı kadar ( doldurması gereken alan )
//                                 gridDelegate:
//                                     SliverGridDelegateWithFixedCrossAxisCount(
//                                   crossAxisCount: BlocProvider.of<
//                                                   QuestionCubit>(context)
//                                               .state
//                                               .answer
//                                               .split(" ") ==
//                                           []
//                                       ? BlocProvider.of<QuestionCubit>(context)
//                                           .state
//                                           .answer
//                                           .length
//                                       : BlocProvider.of<QuestionCubit>(context)
//                                           .state
//                                           .answer
//                                           .split(" ")[glindex]
//                                           .length,
//                                   crossAxisSpacing: w * 0.03,
//                                 ),
//                                 itemBuilder: (__, index) {
//                                   return GestureDetector(
//                                     onTap: () async {
//                                       // if (BlocProvider.of<AnswerCubit>(context)
//                                       //         .state
//                                       //         .answerList!
//                                       //         .length <=
//                                       //     index + ReturnGLIndex(glindex)) {
//                                       //   return;
//                                       // }
//                                       //! //!
//                                       // await _audioPlayer.play(UrlSource(
//                                       //     "https://drive.google.com/uc?export=download&id=1Z9495eNstJ7fLRMg3qP-i8RjjeD-NJPh"));
//                                       //! //!
//                                       BlocProvider.of<AnswerCubit>(context)
//                                           .DeleteAnswer(
//                                               index: index +
//                                                   ReturnGLIndex(glindex),
//                                               ispressedIndex:
//                                                   ReturnIsPressedIndex(index +
//                                                       ReturnGLIndex(glindex)));
//                                     },
//                                     child: FittedBox(
//                                       child: Container(
//                                         width: w * 0.06,
//                                         height: w * 0.06,
//                                         // color: Colors.redAccent,
//                                         color: Colors.transparent,
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.end,
//                                           children: [
//                                             const Expanded(
//                                                 flex: 2, child: SizedBox()),
//                                             index + ReturnGLIndex(glindex) <
//                                                     (BlocProvider.of<AnswerCubit>(
//                                                                     context)
//                                                                 .state
//                                                             as NormalAnswerState)
//                                                         .answerList!
//                                                         .length
//                                                 ? Expanded(
//                                                     flex: 100,
//                                                     child: FittedBox(
//                                                       fit: BoxFit.contain,
//                                                       child: Text(
//                                                         (BlocProvider.of<AnswerCubit>(
//                                                                             context)
//                                                                         .state
//                                                                     as NormalAnswerState)
//                                                                 .answerList![
//                                                             index +
//                                                                 ReturnGLIndex(
//                                                                     glindex)],
//                                                         style: const TextStyle(
//                                                             fontSize: 30),
//                                                       ),
//                                                     ),
//                                                   )
//                                                 : const Text(" "),
//                                             // const Spacer(),
//                                             const Expanded(
//                                                 flex: 2, child: SizedBox()),
//                                             Container(
//                                               width: w * 0.2,
//                                               height: w * 0.007,
//                                               color: Colors.black,
//                                             )
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   );
//                                   // : const SizedBox();
//                                 },
//                               );
//                             }),
//                       );
//                     },
//                   ),
//                   const Spacer(),
//                   BlocBuilder<AnswerCubit, AnswerState>(
//                     builder: (context, state) {
//                       return BlocBuilder<QuestionCubit, QuestionState>(
//                         builder: (context, state) {
//                           return Padding(
//                             padding: EdgeInsets.all(w * 0.025),
//                             child: GridView.builder(
//                               physics: const BouncingScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: state
//                                   .letters!.length, //* şıklar kadar grid var
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                 //* grid ayarları
//                                 crossAxisCount: state.letters!.length <= 9
//                                     ? 3
//                                     : state.letters!.length <= 16
//                                         ? 4
//                                         : 5,
//                                 // state.letters!.length > 8
//                                 //     ? state.letters!.length ~/ 2.55
//                                 //     : state.letters!.length ~/ 1.75,
//                                 crossAxisSpacing: w * 0.05,
//                                 mainAxisExtent: w * 0.15,
//                               ),
//                               itemBuilder: (__, index) {
//                                 //* Eğer şık seçilmişse şık butonunu kapar ( yerine boş bir sizedbox gösterir )
//                                 return (BlocProvider.of<AnswerCubit>(context)
//                                                 .state as NormalAnswerState)
//                                             .isPressedList![index] ==
//                                         false
//                                     ? FittedBox(
//                                         child: MaterialButton(
//                                           color: Colors.blueAccent,
//                                           onPressed: () {
//                                             //* şıkka basıldığı zaman kullanıcının cevabına bu şıkkı ekler
//                                             // if (BlocProvider.of<QuestionCubit>(
//                                             //             context)
//                                             //         .state
//                                             //         .answer[BlocProvider.of<
//                                             //             AnswerCubit>(context)
//                                             //         .state
//                                             //         .answerList!
//                                             //         .length] !=
//                                             //     " ") {
//                                             BlocProvider.of<AnswerCubit>(
//                                                     context)
//                                                 .ChangeAnswer(
//                                                     state.letters![index],
//                                                     index: index);
//                                             // } else {
//                                             //   BlocProvider.of<AnswerCubit>(
//                                             //           context)
//                                             //       .ChangeAnswer(" ");
//                                             //   BlocProvider.of<AnswerCubit>(
//                                             //           context)
//                                             //       .ChangeAnswer(
//                                             //           state.letters![index],
//                                             //           index: index);
//                                             // }

//                                             //* kullanıcının eklediği şık sayısı ( kullanıcının cevabı ) cevabın harf sayısına eşitse bu duruma bakar
//                                             if ((BlocProvider.of<AnswerCubit>(
//                                                                 context)
//                                                             .state
//                                                         as NormalAnswerState)
//                                                     .answerList!
//                                                     .length ==
//                                                 state.answer
//                                                     .replaceAll(" ", "")
//                                                     .length) {
//                                               String res =
//                                                   ""; //* kullanıcıının seçtiği şıkları ( harfler ) tek bir stringte birleştirir ( örn : a , d , a , m  şıklarını => adam kelimesine çevirir )
//                                               for (var element in (BlocProvider
//                                                               .of<AnswerCubit>(
//                                                                   context)
//                                                           .state
//                                                       as NormalAnswerState)
//                                                   .answerList!) {
//                                                 res += element;
//                                               }

//                                               //* eğer kullanıcının cevabı sorunun cevabına eşitse doğrudur ve soru-cevap-şık resetlemesi yaptıktan sonra ekrana yeni bir soru getirir
//                                               if (res.replaceAll(" ", "") ==
//                                                   state.answer
//                                                       .replaceAll(" ", "")) {
//                                                 print("Dogru");
//                                                 BlocProvider.of<AnswerCubit>(
//                                                         context)
//                                                     .ResetAnswer();

//                                                 BlocProvider.of<QuestionCubit>(
//                                                         context)
//                                                     .ChangeQuestion(
//                                                         type: QuestionType
//                                                             .turkish);

//                                                 BlocProvider.of<AnswerCubit>(
//                                                         context)
//                                                     .ResetIsPressList(BlocProvider
//                                                             .of<QuestionCubit>(
//                                                                 context)
//                                                         .state
//                                                         .letters!
//                                                         .length);
//                                               }
//                                               //* kullanıcının ve sorunun cevabı eşleşmiyorsa ( yanlışsa ) sadece seçili şıkları ve kullanıcı cevap kısmını resetler - ekran soru ilk geldiği ekran gibi olur
//                                               else {
//                                                 print("Yanlis");
//                                                 BlocProvider.of<AnswerCubit>(
//                                                         context)
//                                                     .ResetAnswer();

//                                                 BlocProvider.of<AnswerCubit>(
//                                                         context)
//                                                     .ResetIsPressList(
//                                                         state.letters!.length);
//                                               }
//                                             }
//                                           },
//                                           child: Text(
//                                             BlocProvider.of<QuestionCubit>(
//                                                     context)
//                                                 .state
//                                                 .letters![index],
//                                             style: const TextStyle(
//                                               fontSize: 23,
//                                             ),
//                                           ),
//                                         ),
//                                       )
//                                     : const SizedBox();
//                               },
//                             ),
//                           );
//                           // return Text(state.answer);
//                         },
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
