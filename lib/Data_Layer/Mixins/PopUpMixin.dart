import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

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
              padding: EdgeInsets.only(left: ScreenUtil.width * 0.04),
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
                  SizedBox(height: ScreenUtil.height * 0.015),
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
                        GestureDetector(
                          onTap: () async {
                            await audioPlayer.play(UrlSource(data.mediaLinkTr));
                          },
                          child: Container(
                            width: ScreenUtil.width * 0.35,
                            height: ScreenUtil.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const Text(
                                    "Türkçe Telafuz",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                      "assets/images/playSoundIcon.svg"),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await audioPlayer.play(UrlSource(data.mediaLink));
                          },
                          child: Container(
                            width: ScreenUtil.width * 0.35,
                            height: ScreenUtil.height * 0.05,
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Center(
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Spacer(),
                                  const Text(
                                    "İngilizce Telafuz",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Spacer(),
                                  SvgPicture.asset(
                                      "assets/images/playSoundIcon.svg"),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: ScreenUtil.height * 0.025),
                  GestureDetector(
                    onTap: () {
                      launchUrl(Uri.parse(data
                          .link)); // https://www.google.com gibi linl https:// ile baslamalı
                      // launchUrl(Uri.parse("https://www.google.com"));
                    },
                    child: Flexible(
                      child: Text(
                        data.link,
                        style: TextStyle(
                          fontSize: ScreenUtil.textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: data.favType != WordFavType.learned,
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil.height * 0.01),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomePageSelectedWordCubit>(context)
                                .updateState(data, "Learned", context);
                            Navigator.pop(context);
                          },
                          child: Flexible(
                            child: Text(
                              "Bildiğim Kelimelere Ekle",
                              style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: data.favType != WordFavType.nlearned,
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil.height * 0.01),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomePageSelectedWordCubit>(context)
                                .updateState(data, "NotLearned", context);
                            Navigator.pop(context);
                          },
                          child: Flexible(
                            child: Text(
                              "Bilmediğim Kelimelere Ekle",
                              style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: data.isFav == false,
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil.height * 0.01),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomePageSelectedWordCubit>(context)
                                .updateState(data, "Fav", context);
                            Navigator.pop(context);
                          },
                          child: Flexible(
                            child: Text(
                              "Favori Kelimelere Ekle",
                              style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: data.isFav == true,
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil.height * 0.01),
                        GestureDetector(
                          onTap: () {
                            BlocProvider.of<HomePageSelectedWordCubit>(context)
                                .updateState(data, "UnFav", context);
                            Navigator.pop(context);
                          },
                          child: Flexible(
                            child: Text(
                              "Favorilerden Çıkar",
                              style: TextStyle(
                                fontSize: ScreenUtil.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
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
