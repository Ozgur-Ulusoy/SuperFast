import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Business_Layer/cubit/cubit/word_filter_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlaySoundCard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../Business_Layer/cubit/homepage_notifi_alert_cubit.dart';
import '../../Business_Layer/cubit/question_cubit.dart';
import '../../Presentation_Layer/Screens/WebviewPage.dart';
import '../../Presentation_Layer/Widgets/PlayAddToWordCard.dart';

mixin PopUpMixin {
  void openWordPopUp(BuildContext context, Data data, AudioPlayer audioPlayer) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return Center(
          child: Container(
            height: ScreenUtil.height * 0.5,
            width: ScreenUtil.width * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.width * 0.04,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: SvgPicture.asset(
                          "assets/images/ClosePopUpSvg.svg",
                          width: ScreenUtil.textScaleFactor * 38,
                          height: ScreenUtil.textScaleFactor * 38,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: ScreenUtil.height * 0.01),
                  Padding(
                    padding: EdgeInsets.only(
                      right: ScreenUtil.width * 0.04,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Spacer(),
                        BlocBuilder<HomePageSelectedWordCubit,
                            HomePageSelectedWordState>(
                          builder: (context, state) {
                            return AddToWordCard(
                              width: ScreenUtil.width * 0.35,
                              title: getAddToCardTypeTitle(
                                state.currentData!.favType,
                              ),
                              color: const Color(0xffFD830D),
                              onPressed: () {
                                BlocProvider.of<HomePageSelectedWordCubit>(
                                        context)
                                    .updateState(
                                        state.currentData!,
                                        getAddToCardTypeFuncType(
                                            state.currentData!.favType),
                                        context);
                                showCustomSnackbar(
                                    context,
                                    getAddToCardTypeSnackbarTitle(
                                        state.currentData!.favType),
                                    duration: 400);
                              },
                            );
                          },
                        ),
                        const Spacer(
                          flex: 10,
                        ),
                        BlocBuilder<HomePageSelectedWordCubit,
                            HomePageSelectedWordState>(
                          builder: (context, state) {
                            return AddToWordCard(
                              width: ScreenUtil.width * 0.35,
                              title: getAddToCardFavTitle(
                                  state.currentData!.isFav),
                              color: const Color(0xffFF725E),
                              onPressed: () {
                                BlocProvider.of<HomePageSelectedWordCubit>(
                                        context)
                                    .updateState(
                                        state.currentData,
                                        getAddToCardFavFuncType(
                                            state.currentData!.isFav),
                                        context);
                                showCustomSnackbar(
                                    context,
                                    state.currentData!.isFav
                                        ? "Favorilere Eklendi"
                                        : "Favorilerden Çıkarıldı",
                                    duration: 400);
                              },
                            );
                          },
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  popUpTextWidget("Kelime", data.english),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  popUpTextWidget("Anlamı", data.turkish),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  // popUpTextWidget("Örnek Cümle", data.exampleSentence),
                  // SizedBox(height: ScreenUtil.height * 0.015),
                  popUpTextWidget("Türü", returnTypeText(data.type.name)),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  popUpTextWidget(
                      "Seviyesi", data.level.name.toString().toUpperCase()),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  const Spacer(),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.04),
                    child: Row(
                      children: [
                        // PlaySoundCard(
                        //     audioPlayer: audioPlayer,
                        //     wordEn: data.english,
                        //     color: const Color(0XFFFD830D),
                        //     title: "Türkçe Telafuz"),
                        // const Spacer(),
                        Expanded(
                          child: PlaySoundCard(
                              audioPlayer: audioPlayer,
                              wordEn: data.english,
                              color: const Color(0XFF607FF2),
                              title: "İngilizce Telafuz"),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  FittedBox(
                    child: GestureDetector(
                      onTap: () {
                        //* Webview
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              // url: data.link,
                              url:
                                  "https://translate.google.com/?hl=tr&sl=en&tl=tr&text=${data.english}&op=translate",
                              title: data.english,
                            ),
                          ),
                        );

                        // launchUrl(Uri.parse(data
                        //     .link)); // https://www.google.com gibi linl https:// ile baslamalı
                        // launchUrl(Uri.parse("https://www.google.com"));
                      },
                      child: Text(
                        data.link,
                        style: TextStyle(
                          fontSize: ScreenUtil.textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void openDailyWordPopUp(
      BuildContext context, Data data, AudioPlayer audioPlayer) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.2),
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                height: ScreenUtil.height * 0.58,
                width: ScreenUtil.width * 0.8,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: ScreenUtil.width * 0.04,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: SvgPicture.asset(
                              "assets/images/ClosePopUpSvg.svg",
                              width: ScreenUtil.textScaleFactor * 38,
                              height: ScreenUtil.textScaleFactor * 38,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil.height * 0.025),
                      FittedBox(
                        child: Text(
                          "Günün Kelimesi",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.textScaleFactor * 25,
                            fontWeight: FontWeight.bold,
                            color: cBlueBackground,
                          ),
                        ),
                      ),
                      SizedBox(height: ScreenUtil.height * 0.02),
                      Padding(
                        padding: EdgeInsets.only(
                          right: ScreenUtil.width * 0.04,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Spacer(),
                            BlocBuilder<HomePageSelectedWordCubit,
                                HomePageSelectedWordState>(
                              builder: (context, state) {
                                return AddToWordCard(
                                  width: ScreenUtil.width * 0.35,
                                  title: getAddToCardTypeTitle(
                                    state.currentData!.favType,
                                  ),
                                  color: const Color(0xffFD830D),
                                  onPressed: () {
                                    BlocProvider.of<HomePageSelectedWordCubit>(
                                            context)
                                        .updateState(
                                            state.currentData!,
                                            getAddToCardTypeFuncType(
                                                state.currentData!.favType),
                                            context);

                                    showCustomSnackbar(
                                        context,
                                        getAddToCardTypeSnackbarTitle(
                                            state.currentData!.favType),
                                        duration: 400);
                                  },
                                );
                              },
                            ),
                            const Spacer(
                              flex: 10,
                            ),
                            BlocBuilder<HomePageSelectedWordCubit,
                                HomePageSelectedWordState>(
                              builder: (context, state) {
                                return AddToWordCard(
                                  width: ScreenUtil.width * 0.35,
                                  title: getAddToCardFavTitle(
                                      state.currentData!.isFav),
                                  color: const Color(0xffFF725E),
                                  onPressed: () {
                                    BlocProvider.of<HomePageSelectedWordCubit>(
                                            context)
                                        .updateState(
                                            state.currentData,
                                            getAddToCardFavFuncType(
                                                state.currentData!.isFav),
                                            context);
                                    showCustomSnackbar(
                                        context,
                                        state.currentData!.isFav
                                            ? "Favorilere Eklendi"
                                            : "Favorilerden Çıkarıldı",
                                        duration: 400);
                                  },
                                );
                              },
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil.height * 0.025),
                      popUpTextWidget("Kelime", data.english),
                      SizedBox(height: ScreenUtil.height * 0.015),
                      popUpTextWidget("Anlamı", data.turkish),
                      SizedBox(height: ScreenUtil.height * 0.015),
                      // popUpTextWidget("Örnek Cümle", data.exampleSentence),
                      // SizedBox(height: ScreenUtil.height * 0.015),
                      popUpTextWidget("Türü", returnTypeText(data.type.name)),
                      SizedBox(height: ScreenUtil.height * 0.015),
                      popUpTextWidget(
                          "Seviyesi", data.level.name.toString().toUpperCase()),
                      SizedBox(height: ScreenUtil.height * 0.025),
                      // const Spacer(
                      //   flex: 2,
                      // ),
                      const Spacer(),
                      Padding(
                        padding:
                            EdgeInsets.only(right: ScreenUtil.width * 0.04),
                        child: Row(
                          children: [
                            // PlaySoundCard(
                            //     audioPlayer: audioPlayer,
                            //     wordEn: data.english,
                            //     color: const Color(0XFFFD830D),
                            //     title: "Türkçe Telafuz"),
                            // const Spacer(),
                            Expanded(
                              child: PlaySoundCard(
                                  audioPlayer: audioPlayer,
                                  wordEn: data.english,
                                  color: const Color(0XFF607FF2),
                                  title: "İngilizce Telafuz"),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: ScreenUtil.height * 0.025),
                      FittedBox(
                        child: GestureDetector(
                          onTap: () {
                            //* Webview
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewPage(
                                  // url: data.link,
                                  url:
                                      "https://translate.google.com/?hl=tr&sl=en&tl=tr&text=${data.english}&op=translate",
                                  title: data.english,
                                ),
                              ),
                            );

                            // launchUrl(Uri.parse(data
                            //     .link)); // https://www.google.com gibi linl https:// ile baslamalı
                            // launchUrl(Uri.parse("https://www.google.com"));
                          },
                          child: Text(
                            data.link,
                            style: TextStyle(
                              fontSize: ScreenUtil.textScaleFactor * 18,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const Spacer(
                        flex: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showCustomDialog({
    required BuildContext context,
    String? message,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              height: ScreenUtil.height * 0.2,
              width: ScreenUtil.width * 0.6,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Center(
                  child: Text(
                message ?? "",
                textAlign: TextAlign.center,
              )),
            ),
          );
        });
  }

  // Future showCircularProgressingBar(BuildContext context) async {
  //   showDialog(
  //     context: context,
  //     barrierColor: Colors.transparent,
  //     barrierDismissible: false,
  //     builder: (context) {
  //       return Center(
  //         child: SizedBox(
  //           height: ScreenUtil.height * 0.1,
  //           width: ScreenUtil.width * 0.1,
  //           child: const Center(
  //             child: CircularProgressIndicator(
  //               color: Color.fromARGB(255, 66, 241, 72),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  void showCustomSnackbar(BuildContext context, String message,
      {int duration = 400,
      Color color = const Color.fromRGBO(76, 81, 198, 1)}) {
    // print(AppBar().preferredSize.height);
    // print(
    //   MediaQuery.of(context).padding.top,
    // );
    print(WidgetsBinding.instance.window.padding.top);

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          dismissDirection: DismissDirection.up,
          behavior: SnackBarBehavior.floating,
          // width: ScreenUtil.width * 0.95,
          margin: EdgeInsetsDirectional.only(
              bottom: ScreenUtil.height - ScreenUtil.topPadding,
              start: ScreenUtil.width * 0.05,
              end: ScreenUtil.width * 0.05),
          content: AbsorbPointer(
            absorbing: true,
            child: Text(message),
          ),
          backgroundColor: color,
          // isOpaque ? cBlueBackground.withOpacity(0.80) : cBlueBackground,
          action: SnackBarAction(
            textColor: Colors.white,
            label: "Kapat",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          duration: Duration(milliseconds: duration),
        ),
      );
  }

  void showAfterGameDialog(BuildContext context, bool isRecord,
      String recordKey, AsyncCallback callback, AsyncCallback goBackCallback) {
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Center(
    //       child: Container(
    //         width: ScreenUtil.width * 0.65,
    //         height: ScreenUtil.height * 0.65,
    //         decoration: BoxDecoration(
    //           color: Colors.white,
    //           borderRadius: BorderRadius.circular(25),
    //         ),
    //         child: Column(
    //           children: [
    //             Text(
    //               "Tebrikler !",
    //               style: GoogleFonts.poppins(
    //                   fontSize: 25, fontWeight: FontWeight.bold),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text(
            isRecord ? "Rekor Kırıldı !" : "Tebrikler !",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil.textScaleFactor * 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Puanınız : ${context.read<QuestionCubit>().state.point}",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Rekorunuz : ${MainData.localData!.get(recordKey, defaultValue: 0)}",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Doğru Cevap Sayısı : ${context.read<QuestionCubit>().state.trueAnswer}",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Yanlış Cevap Sayısı : ${context.read<QuestionCubit>().state.falseAnswer}",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                goBackCallback();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    KeyUtils.homePageKey, (Route<dynamic> route) => false);
              },
              child: Text(
                "Menüye Dön",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                callback();
              },
              child: Text(
                "Tekrar Oyna",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showPopUpForBackgroundHandles(BuildContext context,
      VoidCallback callbackBattery, VoidCallback callbackAutoStart) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: ScreenUtil.width * 0.85,
                height: ScreenUtil.height * 0.45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil.width * 0.05),
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Uyarı!",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.textScaleFactor * 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                          children: [
                            TextSpan(
                              text:
                                  " Eğer Uygulamamızdan Gelen Bildirimleri Alamıyorsanız Aşağıdaki Seçenekleri Uygulayınız.",
                              style: GoogleFonts.poppins(
                                fontSize: ScreenUtil.textScaleFactor * 16,
                                color: cBlueBackground,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      MaterialButton(
                        minWidth: ScreenUtil.width * 0.82,
                        height: ScreenUtil.height * 0.085,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: cBlueBackground,
                        onPressed: () async {
                          callbackBattery();
                        },
                        child: Text(
                          "Pil Tasarrufunu Kapat",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.textScaleFactor * 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      MaterialButton(
                        minWidth: ScreenUtil.width * 0.82,
                        height: ScreenUtil.height * 0.085,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: cBlueBackground,
                        onPressed: () async {
                          callbackAutoStart();
                        },
                        child: Text(
                          "Otomatik Başlatmayı Aç",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.textScaleFactor * 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () async {
                          BlocProvider.of<HomepageNotifiAlertCubit>(context)
                              .ChangeNotifiAlert(false);
                          await MainData.localData!.put(
                              KeyUtils.isShowHomePageNotifiAlertOnKey, false);
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Bu Uyarıyı Gösterme",
                          style: GoogleFonts.poppins(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil.textScaleFactor * 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void showFilterPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Container(
                width: ScreenUtil.width * 0.85,
                height: ScreenUtil.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    filterPopUpTextWidget(
                        "A1 Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isA1,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsA1(value!)),
                    filterPopUpTextWidget(
                        "A2 Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isA2,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsA2(value!)),
                    filterPopUpTextWidget(
                        "B1 Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isB1,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsB1(value!)),
                    filterPopUpTextWidget(
                      "B2 Kelimeler",
                      BlocProvider.of<WordFilterCubit>(context, listen: true)
                          .state
                          .isB2,
                      (value) => BlocProvider.of<WordFilterCubit>(context)
                          .ChangeIsB2(value!),
                    ),
                    filterPopUpTextWidget(
                        "C1 Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isC1,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsC1(value!)),
                    filterPopUpTextWidget(
                      "C2 Kelimeler",
                      BlocProvider.of<WordFilterCubit>(context, listen: true)
                          .state
                          .isC2,
                      (value) => BlocProvider.of<WordFilterCubit>(context)
                          .ChangeIsC2(value!),
                    ),
                    //
                    filterPopUpTextWidget(
                        "Türü İsim Olan Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isNoun,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsNoun(value!)),
                    filterPopUpTextWidget(
                        "Türü Fiil Olan Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isVerb,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsVerb(value!)),

                    filterPopUpTextWidget(
                        "Türü Sıfat Olan Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isAdjective,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsAdjective(value!)),

                    filterPopUpTextWidget(
                        "Türü Zarf Olan Kelimeler",
                        BlocProvider.of<WordFilterCubit>(context, listen: true)
                            .state
                            .isAdverb,
                        (value) => BlocProvider.of<WordFilterCubit>(context)
                            .ChangeIsAdverb(value!)),

                    filterPopUpTextWidget(
                      "Türü Edat Olan Kelimeler",
                      BlocProvider.of<WordFilterCubit>(context, listen: true)
                          .state
                          .isPreposition,
                      (value) => BlocProvider.of<WordFilterCubit>(context)
                          .ChangeIsPreposition(value!),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget popUpTextWidget(String key, String value) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      FittedBox(
        child: RichText(
          text: TextSpan(
            text: key,
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil.textScaleFactor * 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            // text: Text(
            //   "$key : $value",
            //   style: GoogleFonts.poppins(
            //     fontSize: ScreenUtil.textScaleFactor * 18,
            //     fontWeight: FontWeight.w600,
            //   ),
            // ),
            children: [
              TextSpan(
                text: " : $value",
                style: GoogleFonts.poppins(
                  fontSize: ScreenUtil.textScaleFactor * 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

String returnTypeText(String name) {
  switch (name) {
    case "verb":
      return "Fiil";
    case "noun":
      return "İsim";
    case "adjective":
      return "Sıfat";
    case "adverb":
      return "Zarf";
    case "preposition":
      return "Edat";
    case "conjunction":
      return "Bağlaç";
    case "pronoun":
      return "Zarf";
    case "interjection":
      return "İfade";
    default:
      return "";
  }
}

Widget filterPopUpTextWidget(
    String title, bool value, Function(bool?)? valueChanged) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      FittedBox(
        child: Text(
          title,
          style: GoogleFonts.roboto(
            fontSize: ScreenUtil.textScaleFactor * 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        fit: BoxFit.scaleDown,
      ),
      Checkbox(
        value: value,
        onChanged: valueChanged,
      ),
    ],
  );
}
