import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../Ad_Helper.dart';
import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';
import '../../../Data_Layer/data.dart';
import '../../Widgets/PlayGameBackground.dart';

class SoundGamePage extends StatefulWidget with PopUpMixin {
  const SoundGamePage({Key? key}) : super(key: key);

  @override
  State<SoundGamePage> createState() => _SoundGamePageState();
}

class _SoundGamePageState extends State<SoundGamePage>
    with TickerProviderStateMixin {
  Timer? timer;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  void StartTimer() {
    BlocProvider.of<TimerCubit>(context).ResetTime();
    if (_interstitialAd == null) {
      _createInterstitialAd();
    }
    startTimer();
    answerController.clear();

    // _controller.forward();,
    // _controller.stop();
    // _controller.reset();
  }

  startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) async {
        BlocProvider.of<TimerCubit>(context).DecreaseTime();
        if (BlocProvider.of<TimerCubit>(context).state.getRemainTime <= 0) {
          timer.cancel();
          print("end");
          // _showInterstitialAd();
          try {
            if (BlocProvider.of<QuestionCubit>(context).state.point >
                MainData.soundGameRecord!) {
              MainData.soundGameRecord =
                  BlocProvider.of<QuestionCubit>(context).state.point;
              widget.showAfterGameDialog(
                context,
                true,
                KeyUtils.soundGameRecordKey,
                () async {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  BlocProvider.of<QuestionCubit>(context).ResetState();
                  if (DateTime.now()
                          .difference(MainData.localData!.get(
                              KeyUtils.lastWatchedAdTime,
                              defaultValue: DateTime(1900)))
                          .inMinutes <
                      KeyUtils.adWatchVideoDelayMinute) {
                    // StartTimer();
                    BlocProvider.of<TimerCubit>(context).ResetTime();
                    await chechIsSoundableQuestion();
                  } else {
                    _showInterstitialAd();
                  }
                },
                () async {
                  _showInterstitialAd();
                },
              );
              if (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.isAnonymous == false) {
                FirebaseFirestore.instance
                    .collection(KeyUtils.usersCollectionKey)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  KeyUtils.gameRecordsMapKey +
                          "." +
                          KeyUtils.soundGameRecordKey:
                      BlocProvider.of<QuestionCubit>(context).state.point,
                }).then((value) {
                  MainData.localData!.put(KeyUtils.soundGameRecordKey,
                      BlocProvider.of<QuestionCubit>(context).state.point);
                });
              }

              if (await GamesServices.isSignedIn) {
                GamesServices.submitScore(
                  score: Score(
                    androidLeaderboardID: "CgkIiazqv7IFEAIQCA",
                    value: BlocProvider.of<QuestionCubit>(context).state.point,
                  ),
                );
              }
            } else {
              widget.showAfterGameDialog(
                context,
                false,
                KeyUtils.soundGameRecordKey,
                () async {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  BlocProvider.of<QuestionCubit>(context).ResetState();
                  // await chechIsSoundableQuestion();
                  if (DateTime.now()
                          .difference(MainData.localData!.get(
                              KeyUtils.lastWatchedAdTime,
                              defaultValue: DateTime(1900)))
                          .inMinutes <
                      KeyUtils.adWatchVideoDelayMinute) {
                    // StartTimer();
                    BlocProvider.of<TimerCubit>(context).ResetTime();
                    await chechIsSoundableQuestion();
                  } else {
                    _showInterstitialAd();
                  }
                },
                () async {
                  _showInterstitialAd();
                },
              );
            }
          } catch (e) {}

          //! puan ekranı
        }
      },
    );
  }

  stopTimer() {
    timer!.cancel();
  }

  @override
  initState() {
    super.initState();
    // BlocProvider.of<AnswerCubit>(context).ResetAnswer();
    BlocProvider.of<QuestionCubit>(context).ResetState();

    StartTimer();
    _controller.stop();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isAnimationPlaying = false;
        });
      }
    });
    chechIsSoundableQuestion();
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  bool isAnimationPlaying = false;
  bool isTrueAnswer = false;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isLoading = false;

  Future<void> chechIsSoundableQuestion() async {
    try {
      BlocProvider.of<QuestionCubit>(
              context) //! tipi kullanıcının seçtiği türden olacak
          .ChangeQuestion(type: QuestionType.english); //* ilk soruyu sordu
      stopTimer();
      String url = await getSoundUrl(
          BlocProvider.of<QuestionCubit>(context).state.data.english);
      if (url == "") {
        setState(() {
          isLoading = true;
        });
        print("degistiriliyor");
        BlocProvider.of<QuestionCubit>(context)
            .ChangeQuestion(type: QuestionType.english);
        chechIsSoundableQuestion();
        // return;
      } else {
        audioPlayer.play(UrlSource(url));
        setState(() {
          isLoading = false;
        });
        answerController.clear();
        startTimer();
      }
    } catch (e) {
      if (mounted) {
        widget.showCustomSnackbar(
            context, "Hata ! Lütfen İnternetinizi Kontrol Edin",
            color: Colors.red);
      }
    }
  }

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.soundPageInterstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() async {
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }

    if (DateTime.now()
            .difference(MainData.localData!
                .get(KeyUtils.lastWatchedAdTime, defaultValue: DateTime(1900)))
            .inMinutes <
        KeyUtils.adWatchVideoDelayMinute) {
      // print("need to 3 min to watch again Ad");
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdWillDismissFullScreenContent: (ad) {
        print("ad will dismiss");
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        StartTimer();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    await _interstitialAd!.show();
    await MainData.localData!.put(KeyUtils.lastWatchedAdTime, DateTime.now());
    // MainData.localData!.put(KeyUtils.canWatchVideoAdKey, false);
    print(KeyUtils.adWatchVideoDelayMinute.toString() + " dk bekleniyor");
    // await Workmanager().registerOneOffTask("3", KeyUtils.videoAdDelayWMKey,
    //     initialDelay: const Duration(minutes: 3));
    _interstitialAd = null;
  }

  TextEditingController answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("kapatiliyor");
        if (BlocProvider.of<TimerCubit>(context).state.getRemainTime < 45) {
          _showInterstitialAd();
        }
        Navigator.of(context).pop();
        return false;
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: cBackgroundColor,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height),
                child: Stack(
                  children: [
                    const PlayBackground(),
                    SafeArea(
                      child: Align(
                        alignment: const Alignment(0.9, -0.96),
                        child: Visibility(
                          child: ScaleTransition(
                            scale: _animation,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    //  isTrueAnswer
                                    //     ?
                                    Text(
                                  context
                                      .watch<QuestionCubit>()
                                      .state
                                      .point
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: ScreenUtil.textScaleFactor * 28,
                                    color: isTrueAnswer
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                )
                                // : const Text("-1",
                                //     style: TextStyle(fontSize: 30, color: Colors.red)),
                                ),
                          ),
                          visible: isAnimationPlaying,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil.width * 0.035,
                                top: ScreenUtil.height * 0.035,
                                right: ScreenUtil.width * 0.035,
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (BlocProvider.of<TimerCubit>(context)
                                              .state
                                              .getRemainTime <
                                          45) {
                                        _showInterstitialAd();
                                      }
                                      Navigator.of(context).pop();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      size: ScreenUtil.letterSpacing * 40,
                                      color: cBlueBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: ScreenUtil.height * 0.033),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(width: ScreenUtil.width * 0.06),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Seslerle İngilizce",
                                      style: GoogleFonts.poppins(
                                        fontSize: ScreenUtil.letterSpacing * 22,
                                        fontWeight: FontWeight.bold,
                                        color: cBlueBackground,
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                    Text(
                                      "İngilizce - Türkçe",
                                      style: GoogleFonts.poppins(
                                        fontSize: ScreenUtil.letterSpacing * 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0XFF4C51C6)
                                            .withOpacity(0.74),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: ScreenUtil.height * 0.027),
                            BlocBuilder<TimerCubit, TimerState>(
                              builder: (context, state) {
                                int count = 35;
                                double spacerWidth = (ScreenUtil.width / 100);
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        // padding: EdgeInsets.symmetric(
                                        //     horizontal: ScreenUtil.width * 0.015),
                                        height: ScreenUtil.height * 0.009,
                                        width: ScreenUtil.width,
                                        child: ListView.separated(
                                          reverse: true,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          // physics: const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            // print(ScreenUtil.width);
                                            // print(
                                            //     (ScreenUtil.width / 20).floorToDouble());
                                            return Container(
                                              width:
                                                  (ScreenUtil.width / count) -
                                                      spacerWidth,
                                              color: state.getRemainTime *
                                                          count /
                                                          75 <=
                                                      index
                                                  ? Colors.red
                                                  : Colors.blue,
                                            );
                                          },
                                          separatorBuilder: (context, indes) {
                                            return SizedBox(width: spacerWidth);
                                          },
                                          itemCount: count,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: spacerWidth / 2),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: ScreenUtil.height * 0.015),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: ScreenUtil.width * 0.025,
                                  top: ScreenUtil.height * 0.015),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  BlocBuilder<TimerCubit, TimerState>(
                                    builder: (context, state) {
                                      return Text(
                                        state.getRemainTime.toString(),
                                        style: GoogleFonts.poppins(
                                          fontSize:
                                              ScreenUtil.letterSpacing * 26,
                                          fontWeight: FontWeight.bold,
                                          // color: cBlueBackground,
                                          color: const Color.fromARGB(
                                              255, 143, 76, 198),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: ScreenUtil.height * 0.04),
                            GestureDetector(
                              onTap: () async {
                                String url = await getSoundUrl(
                                    BlocProvider.of<QuestionCubit>(context)
                                        .state
                                        .data
                                        .english);
                                if (url == "") {
                                  // widget.showCustomSnackbar(context, "Ses Bulunamadı");
                                  print("ses yok");
                                  chechIsSoundableQuestion();
                                  return;
                                }
                                await audioPlayer.play(UrlSource(url));
                              },
                              child: Image.asset(
                                "assets/images/SoundGameButton.png",
                                // width: ScreenUtil.width * 0.45,
                                height: ScreenUtil.height * 0.23,
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.only(
                                left: ScreenUtil.width * 0.1,
                                right: ScreenUtil.width * 0.1,
                              ),
                              child: TextField(
                                enableInteractiveSelection: false,
                                // readOnly: true,
                                autocorrect: false,

                                controller: answerController,
                                textAlign: TextAlign.center,
                                onChanged: (value) async {
                                  // BlocProvider.of<AnswerCubit>(context)
                                  //     .UpdateAnswer(value);
                                  if (value.length ==
                                      BlocProvider.of<QuestionCubit>(context)
                                          .state
                                          .data
                                          .english
                                          .length) {
                                    if (value.toLowerCase() ==
                                        BlocProvider.of<QuestionCubit>(context)
                                            .state
                                            .data
                                            .english
                                            .toLowerCase()) {
                                      print("dogru");
                                      setState(() {
                                        isAnimationPlaying = true;
                                        isTrueAnswer = true;
                                        _controller.forward(from: 0);
                                        if (MainData.isSoundOn) {
                                          audioPlayer.stop();
                                          audioPlayer.play(
                                              AssetSource("sounds/true.mp3"));
                                        }
                                      });
                                      await chechIsSoundableQuestion();
                                      BlocProvider.of<QuestionCubit>(context)
                                          .TrueAnswerEvent(150);
                                      answerController.clear();
                                    } else {
                                      setState(() {
                                        isAnimationPlaying = true;
                                        isTrueAnswer = false;
                                        _controller.forward(from: 0);
                                      });
                                      if (MainData.isSoundOn) {
                                        audioPlayer.stop();
                                        audioPlayer.play(
                                            AssetSource("sounds/false.mp3"));
                                      }

                                      print("yanlis");
                                      BlocProvider.of<QuestionCubit>(context)
                                          .FalseAnswerEvent(125);
                                      String url = await getSoundUrl(
                                          BlocProvider.of<QuestionCubit>(
                                                  context)
                                              .state
                                              .data
                                              .english);
                                      if (url == "") {
                                        // widget.showCustomSnackbar(context, "Ses Bulunamadı");
                                        print("ses yok");
                                        chechIsSoundableQuestion();
                                        return;
                                      }
                                      // await audioPlayer.play(UrlSource(url));
                                      await chechIsSoundableQuestion();
                                    }
                                  }
                                },
                                keyboardType: TextInputType.visiblePassword,
                                // enableSuggestions: false,
                                decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: cBlueBackground,
                                      width: 3,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: cBlueBackground,
                                      width: 3,
                                    ),
                                  ),
                                  disabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: cBlueBackground,
                                      width: 3,
                                    ),
                                  ),
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: cBlueBackground,
                                      width: 3,
                                    ),
                                  ),
                                ),
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil.textScaleFactor * 23,
                                  color: cBlueBackground,
                                  letterSpacing: ScreenUtil.letterSpacing * 2,
                                ),
                              ),
                            ),
                            // //!
                            // SizedBox(height: ScreenUtil.height * 0.1),
                            const Spacer(
                              flex: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      child: const Center(
                          child: CircularProgressIndicator(
                        strokeWidth: 5,
                        color: Colors.red,
                      )),
                      visible: isLoading == true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
