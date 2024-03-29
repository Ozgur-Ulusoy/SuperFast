import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Ad_Helper.dart';
import 'package:engame2/Business_Layer/cubit/answer_cubit.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameBackground.dart';
import 'package:engame2/Presentation_Layer/Widgets/PlayGameUpSection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../Business_Layer/cubit/question_cubit.dart';
import '../../../Business_Layer/cubit/timer_cubit.dart';
import '../../../Data_Layer/consts.dart';
import '../../Widgets/BannerAdWidget.dart';

class WordGamePage extends StatefulWidget with PopUpMixin {
  const WordGamePage({Key? key}) : super(key: key);

  @override
  State<WordGamePage> createState() => _WordGamePageState();
}

class _WordGamePageState extends State<WordGamePage>
    with TickerProviderStateMixin {
  AudioPlayer audioPlayer = AudioPlayer();
  Timer? timer;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.fastOutSlowIn,
  );

  late final AnimationController _controller2 = AnimationController(
    lowerBound: 0.70,
    // upperBound: 1.0,
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<double> _animation2 = CurvedAnimation(
    parent: _controller2,
    curve: Curves.fastOutSlowIn,
  );

  void StartTimer() {
    BlocProvider.of<TimerCubit>(context).ResetTime();
    if (_interstitialAd == null) {
      _createInterstitialAd();
    }
    startTimer();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      BlocProvider.of<TimerCubit>(context).DecreaseTime();
      if (BlocProvider.of<TimerCubit>(context).state.getRemainTime <= 0) {
        timer.cancel();
        print("end");
        // _showInterstitialAd();
        // widget.showAfterGameDialog(context);
        try {
          if (BlocProvider.of<QuestionCubit>(context).state.point >
              MainData.letterGameRecord!) {
            MainData.letterGameRecord =
                BlocProvider.of<QuestionCubit>(context).state.point;
            await MainData.localData!.put(KeyUtils.letterGameRecordKey,
                BlocProvider.of<QuestionCubit>(context).state.point);
            widget.showAfterGameDialog(
                context, true, KeyUtils.letterGameRecordKey, () async {
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
                KeyUtils.gameRecordsMapKey + "." + KeyUtils.letterGameRecordKey:
                    BlocProvider.of<QuestionCubit>(context).state.point,
              });
              // .then((value) {
              //   MainData.localData!.put(KeyUtils.letterGameRecordKey,
              //       BlocProvider.of<QuestionCubit>(context).state.point);
              // });
            }
            if (await GamesServices.isSignedIn) {
              GamesServices.submitScore(
                score: Score(
                  androidLeaderboardID: "CgkIiazqv7IFEAIQAQ",
                  value: BlocProvider.of<QuestionCubit>(context).state.point,
                ),
              );
            }
          } else {
            widget.showAfterGameDialog(
              context,
              false,
              KeyUtils.letterGameRecordKey,
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
        } catch (e) {}

        //! puan ekranı
      }
    });
  }

  stopTimer() {
    timer!.cancel();
  }

  @override
  initState() {
    super.initState();
    // BlocProvider.of<AnswerCubit>(context).ResetAnswer();
    // BlocProvider.of<QuestionCubit>(context).ResetState();
    // BlocProvider.of<QuestionCubit>(
    //         context) //! tipi kullanıcının seçtiği türden olacak
    //     .ChangeQuestion(type: QuestionType.turkish); //* ilk soruyu sordu

    //* sayfa açıldığında ilk olarak eski cevap - soru ve şıkları resetler
    BlocProvider.of<AnswerCubit>(context)
        .ResetAnswer(); //* kullanıcnın cevabını resetledi
    BlocProvider.of<QuestionCubit>(context).ResetState();
    BlocProvider.of<QuestionCubit>(
            context) //! tipi kullanıcının seçtiği türden olacak
        .ChangeQuestion(type: QuestionType.turkish); //* ilk soruyu sordu
    StartTimer();

    _controller.stop();
    // _controller2.forward();
    // _controller2.stop();

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
    _controller2.dispose();
    audioPlayer.dispose();
    super.dispose();
    _textController.dispose();
  }

  final TextEditingController _textController = TextEditingController();

  bool isAnimationPlaying = false;
  bool isTrueAnswer = false;

  BannerAdWidget bannerAdWidget = BannerAdWidget(
    adId: AdHelper.letterPageBannerAdUnitId,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.letterPageInterstitialAdUnitId,
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
    _textController.text = context.watch<AnswerCubit>().state.answer;

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
                          //     ? const
                          Text(
                        context.watch<QuestionCubit>().state.point.toString(),
                        style: TextStyle(
                            fontSize: ScreenUtil.textScaleFactor * 28,
                            color: isTrueAnswer ? Colors.green : Colors.red),
                      ),
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
                      title: "Türkçe - İngilizce",
                      isLetterPage: true,
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
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil.width * 0.05),
                        child: TextField(
                          enableInteractiveSelection: false,
                          readOnly: true,
                          controller: _textController,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: () => BlocProvider.of<AnswerCubit>(context)
                                  .DeleteAnswer(),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
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
                            fontSize: ScreenUtil.textScaleFactor * 24,
                            fontWeight: FontWeight.bold,
                            color: cBlueBackground,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: ScreenUtil.height * 0.025),
                    Expanded(
                      flex: 12,
                      child: BlocBuilder<AnswerCubit, AnswerState>(
                        builder: (context, state) {
                          return BlocBuilder<QuestionCubit, QuestionState>(
                            builder: (context, state) {
                              return Padding(
                                padding:
                                    EdgeInsets.all(ScreenUtil.width * 0.025),
                                child: GridView.builder(
                                  physics: const BouncingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: state.letters!
                                      .length, //* şıklar kadar grid var
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    //* grid ayarları
                                    crossAxisCount:
                                        // state.letters!.length <= 9
                                        //     ? 3
                                        //     :
                                        state.letters!.length <= 12
                                            ? 4
                                            : state.letters!.length <= 16
                                                ? 5
                                                : 6,

                                    // state.letters!.length > 8
                                    //     ? state.letters!.length ~/ 2.55
                                    //     : state.letters!.length ~/ 1.75,
                                    // crossAxisSpacing: ScreenUtil.width * 0.0,
                                    mainAxisExtent: ScreenUtil.width * 0.15,
                                  ),
                                  itemBuilder: (__, index) {
                                    //* Eğer şık seçilmişse şık butonunu kapar ( yerine boş bir sizedbox gösterir )
                                    return ScaleTransition(
                                      scale: _animation2,
                                      child: GestureDetector(
                                        // onLongPress: () => setState(() {
                                        //   _controller2.forward();
                                        //   print("a");
                                        // }),
                                        // onLongPressUp: () => setState(() {
                                        //   _controller2.reverse();
                                        //   print("b");
                                        // }),
                                        child: SizedBox.expand(
                                          child: FittedBox(
                                            child: MaterialButton(
                                              minWidth: ScreenUtil.width * 0.12,
                                              color: const Color(0XFFb9bee7),
                                              onPressed: () {
                                                //* şıkka basıldığı zaman kullanıcının cevabına bu şıkkı ekler

                                                BlocProvider.of<AnswerCubit>(
                                                        context)
                                                    .ChangeAnswer(
                                                        state.letters![index],
                                                        index);

                                                //* kullanıcının eklediği şık sayısı ( kullanıcının cevabı ) cevabın harf sayısına eşitse bu duruma bakar
                                                if (BlocProvider.of<
                                                                AnswerCubit>(
                                                            context)
                                                        .state
                                                        .answerList
                                                        .length ==
                                                    state
                                                        .answer
                                                        // .replaceAll(" ", "")
                                                        .length) {
                                                  String res =
                                                      ""; //* kullanıcıının seçtiği şıkları ( harfler ) tek bir stringte birleştirir ( örn : a , d , a , m  şıklarını => adam kelimesine çevirir )
                                                  for (var element
                                                      in BlocProvider.of<
                                                                  AnswerCubit>(
                                                              context)
                                                          .state
                                                          .answerList) {
                                                    res += element.answer!;
                                                  }

                                                  //* eğer kullanıcının cevabı sorunun cevabına eşitse doğrudur ve soru-cevap-şık resetlemesi yaptıktan sonra ekrana yeni bir soru getirir
                                                  if (
                                                      // res.replaceAll(" ", "") ==
                                                      res == state.answer
                                                      // .replaceAll(" ", "")
                                                      ) {
                                                    print("Dogru");
                                                    BlocProvider.of<
                                                                AnswerCubit>(
                                                            context)
                                                        .ResetAnswer();
                                                    BlocProvider.of<
                                                                QuestionCubit>(
                                                            context)
                                                        .TrueAnswerEvent(150);
                                                    BlocProvider.of<
                                                                QuestionCubit>(
                                                            context)
                                                        .ChangeQuestion(
                                                            type: QuestionType
                                                                .turkish);
                                                    setState(() {
                                                      isAnimationPlaying = true;
                                                      isTrueAnswer = true;
                                                      _controller.forward(
                                                          from: 0);
                                                    });
                                                    if (MainData.isSoundOn) {
                                                      audioPlayer.stop();
                                                      audioPlayer.play(
                                                          AssetSource(
                                                              "sounds/true.mp3"));
                                                    }
                                                  }
                                                  //* kullanıcının ve sorunun cevabı eşleşmiyorsa ( yanlışsa ) sadece seçili şıkları ve kullanıcı cevap kısmını resetler - ekran soru ilk geldiği ekran gibi olur
                                                  else {
                                                    print("Yanlis");
                                                    BlocProvider.of<
                                                                AnswerCubit>(
                                                            context)
                                                        .ResetAnswer();

                                                    BlocProvider.of<
                                                                QuestionCubit>(
                                                            context)
                                                        .FalseAnswerEvent(125);
                                                    BlocProvider.of<
                                                                QuestionCubit>(
                                                            context)
                                                        .ChangeQuestion(
                                                            type: QuestionType
                                                                .turkish);
                                                    setState(() {
                                                      isAnimationPlaying = true;
                                                      isTrueAnswer = false;
                                                      _controller.forward(
                                                          from: 0);
                                                      if (MainData.isSoundOn) {
                                                        audioPlayer.stop();
                                                        audioPlayer.play(
                                                            AssetSource(
                                                                "sounds/false.mp3"));
                                                      }
                                                    });
                                                  }
                                                }
                                              },
                                              child: Text(
                                                BlocProvider.of<QuestionCubit>(
                                                        context)
                                                    .state
                                                    .letters![index],
                                                style: TextStyle(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.bold,
                                                    color: BlocProvider.of<
                                                                    AnswerCubit>(
                                                                context)
                                                            .state
                                                            .answerList
                                                            .where((element) =>
                                                                element.id ==
                                                                index)
                                                            .isNotEmpty
                                                        ? cBlueBackground
                                                        : cBackgroundColor),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                              // return Text(state.answer);
                            },
                          );
                        },
                      ),
                    ),

                    // const Spacer(),
                    // CheckAnswerButton(
                    //   callback: () {
                    //     BlocProvider.of<AnswerCubit>(context).ResetAnswer();
                    //   },
                    // ),
                    //!
                    // SizedBox(height: ScreenUtil.height * 0.1),
                    // const Spacer(flex: 2),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: bannerAdWidget,
                    ),
                    SizedBox(height: ScreenUtil.height * 0.015),
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
