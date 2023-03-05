import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlaySoundCard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../Presentation_Layer/Screens/WebviewPage.dart';
import '../../Presentation_Layer/Widgets/PlayAddToWordCard.dart';

mixin PopUpMixin {
  void OpenWordPopUp(BuildContext context, Data data, AudioPlayer audioPlayer) {
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
                                    getAddToCardTypeTitle(
                                            state.currentData!.favType) +
                                        "ndi",
                                    duration: 1);
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
                                    duration: 1);
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
                  popUpTextWidget("Örnek Cümle", data.exampleSentence),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  popUpTextWidget("Türü", returnTypeText(data.type.name)),
                  SizedBox(height: ScreenUtil.height * 0.015),
                  popUpTextWidget(
                      "Seviyesi", data.level.name.toString().toUpperCase()),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.04),
                    child: Row(
                      children: [
                        PlaySoundCard(
                            audioPlayer: audioPlayer,
                            urlSource: data.mediaLinkTr,
                            color: const Color(0XFFFD830D),
                            title: "Türkçe Telafuz"),
                        const Spacer(),
                        PlaySoundCard(
                            audioPlayer: audioPlayer,
                            urlSource: data.mediaLink,
                            color: const Color(0XFF607FF2),
                            title: "İngilizce Telafuz"),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        //* Webview
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WebViewPage(
                              url: data.link,
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
                ],
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
      {int duration = 2, Color color = const Color.fromRGBO(76, 81, 198, 1)}) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          // isOpaque ? cBlueBackground.withOpacity(0.80) : cBlueBackground,
          action: SnackBarAction(
            textColor: Colors.white,
            label: "Kapat",
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
          duration: Duration(seconds: duration),
        ),
      );
  }

  void showAfterEngameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
            width: ScreenUtil.width * 0.65,
            height: ScreenUtil.height * 0.65,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: const [],
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
      Flexible(
        child: Text(
          "$key : $value",
          style: TextStyle(
            fontSize: ScreenUtil.textScaleFactor * 18,
            fontWeight: FontWeight.bold,
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
