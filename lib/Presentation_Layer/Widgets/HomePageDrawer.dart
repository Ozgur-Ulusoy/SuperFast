import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class HomePageDrawer extends StatefulWidget with PopUpMixin {
  VoidCallback callback;

  HomePageDrawer({Key? key, required this.callback}) : super(key: key);

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.width,
      height: ScreenUtil.height,
      color: cBlueBackground,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: ScreenUtil.height * 0.015),
                Row(
                  children: [
                    SizedBox(width: ScreenUtil.width * 0.015),
                    IconButton(
                      onPressed: () => widget.callback(),
                      icon: Icon(
                        MdiIcons.close,
                        color: Colors.white,
                        size: ScreenUtil.textScaleFactor * 55,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil.height * 0.025,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: ScreenUtil.height * 0.6,
                        width: ScreenUtil.width * 0.88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Spacer(
                              flex: 2,
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(KeyUtils.profilePageKey);
                                  widget.callback();
                                },
                                child: Text(
                                  "HESABIM",
                                  style: GoogleFonts.bebasNeue(
                                    color: cBlueBackground,
                                    fontSize: ScreenUtil.textScaleFactor * 32,
                                    letterSpacing: ScreenUtil.letterSpacing * 3,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                // Navigator.of(context)
                                //     .pushNamed(KeyUtils.settingsPageKey);
                                // widget.callback();
                                if (await GamesServices.isSignedIn &&
                                    MainData.isGoogleGamesSigned) {
                                  await GamesServices.showLeaderboards();
                                } else {
                                  widget.callback();
                                  widget.showCustomSnackbar(context,
                                      "Google Hesabınız İle Giriş yapın",
                                      duration: 1000);
                                }
                              },
                              child: Text(
                                "LİDERLİK TABLOSU",
                                style: GoogleFonts.bebasNeue(
                                  color: cBlueBackground,
                                  fontSize: ScreenUtil.textScaleFactor * 32,
                                  letterSpacing: ScreenUtil.letterSpacing * 3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                // ! Play Store Linkine Gitme
                                // if (await canLaunchUrlString(
                                //     "https://play.google.com/store/apps/details?id=com.ozgurulusoy.superfastenglish")) {
                                //   await launchUrlString(
                                //       "https://play.google.com/store/apps/details?id=com.ozgurulusoy.superfastenglish",
                                //       mode: LaunchMode.externalApplication);
                                // }
                                if (await InAppReview.instance.isAvailable()) {
                                  print("yes");
                                  widget.callback();
                                  InAppReview.instance.openStoreListing();
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    InAppReview.instance.requestReview();
                                  });
                                  // InAppReview.instance.openStoreListing();
                                } else {
                                  InAppReview.instance.openStoreListing();
                                }
                              },
                              child: Text(
                                "UYGULAMAYA OY VER",
                                style: GoogleFonts.bebasNeue(
                                  color: cBlueBackground,
                                  fontSize: ScreenUtil.textScaleFactor * 32,
                                  letterSpacing: ScreenUtil.letterSpacing * 3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                widget.callback();
                                if (MainData.dailyData != null) {
                                  BlocProvider.of<HomePageSelectedWordCubit>(
                                          context)
                                      .changeCurrentData(MainData.dailyData!);
                                  widget.openDailyWordPopUp(context,
                                      MainData.dailyData!, AudioPlayer());
                                }
                              },
                              child: Text(
                                "GÜNÜN KELİMESİ",
                                style: GoogleFonts.bebasNeue(
                                  color: cBlueBackground,
                                  fontSize: ScreenUtil.textScaleFactor * 32,
                                  letterSpacing: ScreenUtil.letterSpacing * 3,
                                ),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed(KeyUtils.settingsPageKey);
                                widget.callback();
                              },
                              child: Text(
                                "AYARLAR",
                                style: GoogleFonts.bebasNeue(
                                  color: cBlueBackground,
                                  fontSize: ScreenUtil.textScaleFactor * 32,
                                  letterSpacing: ScreenUtil.letterSpacing * 3,
                                ),
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenUtil.width * 0.8,
                  height: ScreenUtil.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        if (FirebaseAuth.instance.currentUser != null &&
                            FirebaseAuth.instance.currentUser!.isAnonymous ==
                                false) {
                          if (MainData.isFavListChanged == true) {
                            await FirebaseFirestore.instance
                                .collection(KeyUtils.usersCollectionKey)
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'favList': MainData.favList});
                            MainData.isFavListChanged = false;
                          }
                          if (MainData.isLearnedListChanged == true) {
                            await FirebaseFirestore.instance
                                .collection(KeyUtils.usersCollectionKey)
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .update({'learnedList': MainData.learnedList});
                            MainData.isLearnedListChanged = false;
                          }
                        }

                        BlocProvider.of<HomePageSelectedWordCubit>(context)
                            .StateBuild();
                        await FirebaseAuth.instance
                            .signOut()
                            .whenComplete(() async {
                          if (FirebaseAuth.instance.currentUser == null) {
                            await fResetData(context: context);
                            if (await GamesServices.isSignedIn) {
                              // try {
                              await GoogleSignIn.games().disconnect();
                              await GamesServices.signOut();
                              // } catch (e) {
                              //   // await Navigator.of(context)
                              //   //     .pushNamedAndRemoveUntil(
                              //   //         KeyUtils.loginPageKey,
                              //   //         (Route<dynamic> route) => false);
                              // }
                            }
                          }
                        });
                      } catch (e) {
                        // await Navigator.of(context).pushNamedAndRemoveUntil(
                        //     KeyUtils.loginPageKey,
                        //     (Route<dynamic> route) => false);
                      } finally {
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                            KeyUtils.loginPageKey,
                            (Route<dynamic> route) => false);
                        setState(() {});
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffbff453a)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        const Spacer(),
                        Text(
                          "Çıkış Yap",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil.textScaleFactor * 21,
                          ),
                        ),
                        const Spacer(),
                        const Icon(MdiIcons.logout),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Align(
              alignment: const Alignment(0, -0.78),
              child: Container(
                decoration: BoxDecoration(
                  color: cBlueBackground,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil.width * 0.015),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: FirebaseAuth.instance.currentUser == null
                        ? Image.asset(
                            "assets/images/profilepic.png",
                            color: Colors.white,
                          ).image
                        : FirebaseAuth.instance.currentUser!.photoURL != null
                            ? Image.network(
                                // FirebaseAuth.instance.currentUser!.photoURL ??
                                //     "http://cdn.onlinewebfonts.com/svg/img_181369.png",
                                FirebaseAuth.instance.currentUser!.photoURL!,
                                fit: BoxFit.contain,
                              ).image
                            : Image.asset(
                                "assets/images/profilepic.png",
                                color: Colors.white,
                              ).image,
                    radius: ScreenUtil.height * 0.06,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
