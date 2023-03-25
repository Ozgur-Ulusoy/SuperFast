import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/CheckAnswerButton.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameBackground.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameUpSection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../Ad_Helper.dart';
import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';

import '../../../Data_Layer/data.dart';
import '../../Widgets/BannerAdWidget.dart';
import '../../Widgets/ChoiceCard.dart';

// GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class EngamePage extends StatefulWidget with PopUpMixin {
  const EngamePage({Key? key}) : super(key: key);

  @override
  State<EngamePage> createState() => _EngamePageState();
}

class _EngamePageState extends State<EngamePage> with TickerProviderStateMixin {
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
    // _controller.forward();,
    // _controller.stop();
    // _controller.reset();
  }

  startTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        BlocProvider.of<TimerCubit>(context).DecreaseTime();
        if (BlocProvider.of<TimerCubit>(context).state.getRemainTime <= 0) {
          timer.cancel();
          print("end");
          try {
            if (BlocProvider.of<QuestionCubit>(context).state.point >
                MainData.engameGameRecord!) {
              MainData.localData!.put(KeyUtils.engameGameRecordKey,
                  BlocProvider.of<QuestionCubit>(context).state.point);
              MainData.engameGameRecord =
                  BlocProvider.of<QuestionCubit>(context).state.point;
              widget.showAfterGameDialog(
                  context, true, KeyUtils.engameGameRecordKey, () async {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                BlocProvider.of<QuestionCubit>(context).ResetState();
                BlocProvider.of<QuestionCubit>(
                        context) //! tipi kullanıcının seçtiği türden olacak
                    .ChangeQuestion(
                        type: QuestionType.english); //* ilk soruyu sordu
                if (DateTime.now()
                        .difference(MainData.localData!.get(
                            KeyUtils.lastWatchedAdTime,
                            defaultValue: DateTime(1900)))
                        .inMinutes <
                    KeyUtils.adWatchVideoDelayMinute) {
                  StartTimer();
                } else {
                  _showInterstitialAd();
                }
              }, () async {
                _showInterstitialAd();
              });
              if (FirebaseAuth.instance.currentUser != null &&
                  FirebaseAuth.instance.currentUser!.isAnonymous == false) {
                FirebaseFirestore.instance
                    .collection(KeyUtils.usersCollectionKey)
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .update({
                  KeyUtils.gameRecordsMapKey +
                          "." +
                          KeyUtils.engameGameRecordKey:
                      BlocProvider.of<QuestionCubit>(context).state.point,
                });
              }
            } else {
              widget.showAfterGameDialog(
                context,
                false,
                KeyUtils.engameGameRecordKey,
                () async {
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                  BlocProvider.of<QuestionCubit>(context).ResetState();
                  BlocProvider.of<QuestionCubit>(
                          context) //! tipi kullanıcının seçtiği türden olacak
                      .ChangeQuestion(
                          type: QuestionType.english); //* ilk soruyu sordu
                  if (DateTime.now()
                          .difference(MainData.localData!.get(
                              KeyUtils.lastWatchedAdTime,
                              defaultValue: DateTime(1900)))
                          .inMinutes <
                      KeyUtils.adWatchVideoDelayMinute) {
                    StartTimer();
                  } else {
                    _showInterstitialAd();
                  }
                },
                () async {
                  _showInterstitialAd();
                },
              );
            }

            // _showInterstitialAd();
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
    BlocProvider.of<QuestionCubit>(
            context) //! tipi kullanıcının seçtiği türden olacak
        .ChangeQuestion(type: QuestionType.english); //* ilk soruyu sordu
    StartTimer();
    _controller.stop();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          isAnimationPlaying = false;
        });
      }
    });
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

  BannerAdWidget bannerAdWidget = BannerAdWidget(
    adId: AdHelper.testPageBannerAdUnitId,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.testPageInterstitialAdUnitId,
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
        _createInterstitialAd();
        StartTimer();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    await MainData.localData!.put(KeyUtils.lastWatchedAdTime, DateTime.now());
    // MainData.localData!.put(KeyUtils.canWatchVideoAdKey, false);
    print(KeyUtils.adWatchVideoDelayMinute.toString() + " dk bekleniyor");
    // await Workmanager().registerOneOffTask("3", KeyUtils.videoAdDelayWMKey,
    //     initialDelay: const Duration(minutes: 3));
    _interstitialAd = null;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("Kapatiliyor");
        if (BlocProvider.of<TimerCubit>(context).state.getRemainTime < 45) {
          _showInterstitialAd();
        }
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: cBackgroundColor,
        // key: scaffoldKey,
        body: Stack(
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
                          context.watch<QuestionCubit>().state.point.toString(),
                          style: TextStyle(
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            color: isTrueAnswer ? Colors.green : Colors.red,
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
                    PlayGameUpSelection(
                      title: "İngilizce - Türkçe",
                      goBackCaller: () {
                        if (BlocProvider.of<TimerCubit>(context)
                                .state
                                .getRemainTime <
                            45) {
                          _showInterstitialAd();
                        }
                        Navigator.of(context).pop();
                      },
                    ),
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: ScreenUtil.width * 0.08),
                      crossAxisCount: 2,
                      crossAxisSpacing: ScreenUtil.width * 0.11,
                      mainAxisSpacing: ScreenUtil.height * 0.025,
                      childAspectRatio: 2.65,
                      shrinkWrap: true,
                      children: [
                        BlocBuilder<QuestionCubit, QuestionState>(
                          builder: (context, state) {
                            return ChoiceCard(
                              id: state.choices![0].id,
                              title: state.choices![0].turkish,
                              onPressed: () {
                                BlocProvider.of<QuestionCubit>(context)
                                    .ChangeSelectedId(state.choices![0].id);
                              },
                            );
                          },
                        ),
                        BlocBuilder<QuestionCubit, QuestionState>(
                          builder: (context, state) {
                            return ChoiceCard(
                              id: state.choices![1].id,
                              title: state.choices![1].turkish,
                              onPressed: () {
                                BlocProvider.of<QuestionCubit>(context)
                                    .ChangeSelectedId(state.choices![1].id);
                              },
                            );
                          },
                        ),
                        BlocBuilder<QuestionCubit, QuestionState>(
                          builder: (context, state) {
                            return ChoiceCard(
                              id: state.choices![2].id,
                              title: state.choices![2].turkish,
                              onPressed: () {
                                BlocProvider.of<QuestionCubit>(context)
                                    .ChangeSelectedId(state.choices![2].id);
                              },
                            );
                          },
                        ),
                        BlocBuilder<QuestionCubit, QuestionState>(
                          builder: (context, state) {
                            return ChoiceCard(
                              id: state.choices![3].id,
                              title: state.choices![3].turkish,
                              onPressed: () {
                                BlocProvider.of<QuestionCubit>(context)
                                    .ChangeSelectedId(state.choices![3].id);
                              },
                            );
                          },
                        ),
                      ],
                    ),
                    // SizedBox(height: ScreenUtil.height * 0.02),
                    const Spacer(),
                    CheckAnswerButton(
                      callback: () {
                        final int time = BlocProvider.of<TimerCubit>(context)
                            .state
                            .getRemainTime;
                        if (time <= 0) return;
                        if (BlocProvider.of<QuestionCubit>(context)
                                .state
                                .isAnswered &&
                            MainData.removeControlButtonEngame == false) {
                          BlocProvider.of<QuestionCubit>(context)
                              .ChangeQuestion();
                          // startTimer();
                          startTimer();
                        } else if (BlocProvider.of<QuestionCubit>(context)
                                    .state
                                    .isAnswered ==
                                false &&
                            BlocProvider.of<QuestionCubit>(context)
                                    .state
                                    .selectedId !=
                                -1) {
                          BlocProvider.of<QuestionCubit>(context).CheckAnswer(
                            () {
                              //? true
                              setState(() {
                                isAnimationPlaying = true;
                                isTrueAnswer = true;
                                _controller.forward(from: 0);
                                if (MainData.isSoundOn) {
                                  audioPlayer.stop();
                                  audioPlayer
                                      .play(AssetSource("sounds/true.mp3"));
                                }
                              });
                            },
                            () {
                              //? false
                              setState(() {
                                isAnimationPlaying = true;
                                isTrueAnswer = false;
                                _controller.forward(from: 0);
                              });
                              if (MainData.isSoundOn) {
                                audioPlayer.stop();
                                audioPlayer
                                    .play(AssetSource("sounds/false.mp3"));
                              }
                            },
                          );
                          if (MainData.removeControlButtonEngame == true) {
                            BlocProvider.of<QuestionCubit>(context)
                                .ChangeQuestion();
                            return;
                          }
                          stopTimer();
                        }
                        // else {
                        //   widget.showCustomSnackbar(
                        //       context, "Lütfen Bir Cevap Seçiniz",
                        //       duration: 100);
                        // }
                      },
                    ),
                    //!
                    // SizedBox(height: ScreenUtil.height * 0.1),
                    const Spacer(),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: bannerAdWidget,
                    ),
                    SizedBox(height: ScreenUtil.height * 0.02),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
