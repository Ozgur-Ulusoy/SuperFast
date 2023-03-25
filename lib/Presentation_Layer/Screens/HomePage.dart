import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_start_flutter/auto_start_flutter.dart';
import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Business_Layer/cubit/homepage_notifi_alert_cubit.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/BannerAdWidget.dart';
import 'package:engame2/Presentation_Layer/Widgets/HomePageDrawer.dart';
import 'package:engame2/Presentation_Layer/Widgets/HomePageWordSelectButton.dart';
import 'package:engame2/Presentation_Layer/Widgets/MainPageGameCard.dart';
import 'package:engame2/Presentation_Layer/Widgets/MyWordsWidget.dart';
import 'package:engame2/Presentation_Layer/Widgets/TabButtonWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../Ad_Helper.dart';
import '../../Data_Layer/data.dart';

// GlobalKey<_HomePageState> createKey() => GlobalKey<_HomePageState>();

class HomePage extends StatefulWidget with PopUpMixin {
  HomePage({Key? key}) : super(key: key);
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

extension WidgetAKeyExt on GlobalKey<_HomePageState> {
  void getRandomDailyWordd() => currentState?.getRandomDailyWord();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  ScrollController scrollController = ScrollController();

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    lowerBound: 0.25,
    upperBound: 1,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refleshData();
    BlocProvider.of<HomePageSelectedWordCubit>(context)
        .ChangeState(WordSelectedStateEnums.learnedWordState);
    getRandomDailyWord();
    setFirebaseNotifications();
  }

  Future<void> setFirebaseNotifications() async {
    try {
      if (MainData.getNotification) {
        await FirebaseMessaging.instance
            .subscribeToTopic(KeyUtils.notificationTopicKey);
      } else {
        await FirebaseMessaging.instance
            .unsubscribeFromTopic(KeyUtils.notificationTopicKey);
      }
    } catch (e) {}
  }

  Future<void> getRandomDailyWord() async {
    int? randomIndex =
        await MainData.localData!.get(KeyUtils.dailyWordIdKey, defaultValue: 1);

    print("---- " + randomIndex.toString());
    if (randomIndex != null &&
        MainData.showAlwaysDailyWord &&
        MainData.isShowedDailyWord == false) {
      BlocProvider.of<HomePageSelectedWordCubit>(context).changeCurrentData(
        MainData.dailyData!,
      );
      widget.openDailyWordPopUp(context, MainData.dailyData!, _audioPlayer);
      MainData.isShowedDailyWord = true;
    }
  }

  Future<void> refleshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      print("refleshed");
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
    // ticker
  }

  //! AutoStart - izin alma
  Future<void> initAutoStart() async {
    try {
      //check auto-start availability.
      var test = await (isAutoStartAvailable as FutureOr<bool>);
      print(test);
      //if available then navigate to auto-start setting page.
      if (test) await getAutoStartPermission();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  BannerAdWidget bannerAdWidget =
      BannerAdWidget(adId: AdHelper.homePageBannerAdUnitId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: widget.scaffoldKey,
      drawer: HomePageDrawer(
        callback: () => widget.scaffoldKey.currentState!.closeDrawer(),
      ),
      backgroundColor: cBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: RotatedBox(
                quarterTurns: 2,
                child: SvgPicture.asset(
                  "assets/images/Group 7.svg",
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                  left: ScreenUtil.width * 0.035,
                  top: ScreenUtil.height * 0.035,
                  right: ScreenUtil.width * 0.035,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TabButtonWidget(
                          height: ScreenUtil.height * 0.04,
                          callback: () =>
                              widget.scaffoldKey.currentState!.openDrawer(),
                        ),
                        const Spacer(),
                        Visibility(
                          visible: context
                                  .watch<HomepageNotifiAlertCubit>()
                                  .state
                                  .isNotifiAlert &&
                              (MainData.isBatteryOptimizeDisabled == false ||
                                  MainData.isAutoRestartEnabledForBackground ==
                                      false),
                          child: ScaleTransition(
                            scale: _animation,
                            child: GestureDetector(
                              onTap: () async {
                                widget.showPopUpForBackgroundHandles(
                                  context,
                                  () async {
                                    //? Battery optimize
                                    if (await Permission
                                        .ignoreBatteryOptimizations.isGranted) {
                                      widget.showCustomSnackbar(context,
                                          "Zaten izin verilmiş durumda");
                                      return;
                                    }

                                    final PermissionStatus permissionStatus =
                                        await Permission
                                            .ignoreBatteryOptimizations
                                            .request();

                                    if (permissionStatus.isGranted) {
                                      setState(() {
                                        MainData.isBatteryOptimizeDisabled =
                                            true;
                                        print("setstated - " +
                                            MainData.isBatteryOptimizeDisabled
                                                .toString());
                                      });
                                      MainData.localData!.put(
                                          KeyUtils.isBatteryOptimizeDisabledKey,
                                          true);
                                      Navigator.pop(context);
                                    }
                                  },
                                  //? Autorestart
                                  () async {
                                    if (await isAutoStartAvailable == true) {
                                      print("true");
                                      await getAutoStartPermission();
                                    } else {
                                      print("false");
                                    }
                                  },
                                );
                              },
                              child: Icon(
                                MainData.isBatteryOptimizeDisabled == false
                                    ? Icons.battery_alert
                                    : Icons.restart_alt,
                                color: Colors.red,
                                size: ScreenUtil.textScaleFactor * 30,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
                    Row(
                      children: [
                        Flexible(
                          child: RichText(
                            text: TextSpan(
                              text: "Hello ,\n",
                              style: GoogleFonts.fredoka(
                                color: cBlueBackground,
                                fontSize: ScreenUtil.textScaleFactor * 35,
                                fontWeight: FontWeight.w500,
                              ),
                              children: [
                                TextSpan(
                                  text: FirebaseAuth
                                          .instance.currentUser!.displayName ??
                                      MainData.username,
                                  style: GoogleFonts.fredoka(
                                    color: cBlueBackground,
                                    fontSize: ScreenUtil.textScaleFactor * 35,
                                    fontWeight: FontWeight.w300,
                                  ),
                                )
                              ],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.0125),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Oyunlar",
                          style: GoogleFonts.poppins(
                            color: cBlueBackground,
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     // TODO
                        //   },
                        //   child: Text(
                        //     "Tümünü Gör",
                        //     style: GoogleFonts.roboto(
                        //       color: cBlueBackground,
                        //       fontSize: ScreenUtil.textScaleFactor * 18,
                        //       decoration: TextDecoration.underline,
                        //       fontWeight: FontWeight.w400,
                        //     ),
                        //   ),
                        // )
                        const SizedBox(), //! şimdilik
                      ],
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(5),
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 2.4,
                      children: [
                        PlayGameCard(
                          imagePath: "assets/images/firstplayphoto.svg",
                          firstColor: Colors.pink,
                          secondColor: Colors.pink[300]!,
                          text: "Test Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(
                                context, KeyUtils.testGamePageKey);
                          },
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/secondplayphoto.svg",
                          firstColor: Colors.blue,
                          secondColor: Colors.blueAccent,
                          text: "Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(
                                context, KeyUtils.letterGamePageKey);
                          },
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/thirdplayphoto.svg",
                          firstColor: Colors.purple[300]!,
                          secondColor: Colors.purpleAccent,
                          text: "Sesli Kelime Oyunu",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            Navigator.pushNamed(
                                context, KeyUtils.soundGamePageKey);
                          },
                        ),
                        PlayGameCard(
                          imagePath: "assets/images/fourthplayphoto.svg",
                          firstColor: Colors.purple,
                          secondColor: Colors.deepPurpleAccent,
                          text: "Yakında...",
                          iconPath: "assets/images/gamepadicon.svg",
                          func: () {
                            widget.showCustomSnackbar(context, "Çok Yakında !");
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Kelimelerim",
                          style: GoogleFonts.poppins(
                            color: cBlueBackground,
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO
                            Navigator.of(context)
                                .pushNamed(KeyUtils.wordsPageKey);
                          },
                          child: Text(
                            "Tümünü Gör",
                            style: GoogleFonts.roboto(
                              color: cBlueBackground,
                              fontSize: ScreenUtil.textScaleFactor * 18,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                    //

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        WordCardSelectButton(
                          type: WordSelectedStateEnums.learnedWordState,
                          baslik: "Bildiğim Kelimeler",
                          callback: () => scrollController.animateTo(
                            0,
                            duration: const Duration(
                                milliseconds: 400), //duration of scroll
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                        WordCardSelectButton(
                          type: WordSelectedStateEnums.notLearnedWordState,
                          baslik: "Bilmediğim Kelimeler",
                          callback: () => scrollController.animateTo(
                            0,
                            duration: const Duration(
                                milliseconds: 400), //duration of scroll
                            curve: Curves.fastOutSlowIn,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: ScreenUtil.height * 0.015),
                    // CustomPaint(
                    //   painter: DrawDottedhorizontalline(),
                    // ),
                    MyWordsWidget(
                      scrollController: scrollController,
                      audioPlayer: _audioPlayer,
                      dataList: BlocProvider.of<HomePageSelectedWordCubit>(
                              context,
                              listen: true)
                          .returnDataList(),
                      // lastItemHeight: bannerAdWidget.height,
                    ),
                    //!
                    // const Expanded(flex: 8, child: Placeholder()),
                    // Align(
                    //     alignment: const Alignment(0, 0.99),
                    //     child: bannerAdWidget),
                    SizedBox(height: ScreenUtil.height * 0.025),
                    // const Spacer(),

                    //
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: bannerAdWidget,
                    ),
                    // const Spacer(),
                    SizedBox(height: ScreenUtil.height * 0.02),
                  ],
                ),
              ),
            ),
          ),
          // SafeArea(
          //   child: Align(
          //       alignment: const Alignment(0, 0.99), child: bannerAdWidget),
          // ),
        ],
      ),
    );
  }
}
