import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../../Data_Layer/consts.dart';
import '../../../Data_Layer/data.dart';
import '../../Widgets/GoArrowButtonWidget.dart';
import '../../Widgets/LogoWidget.dart';

class LoginPage extends StatefulWidget with PopUpMixin {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future GoogleLogin() async {
    if (isLoading == true) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      try {
        print(FirebaseAuth.instance.currentUser);
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.signOut();
        }
      } catch (e) {}

      try {
        if (await GamesServices.isSignedIn) {
          await GoogleSignIn.games().disconnect();
          await GamesServices.signOut();
        }
      } catch (e) {}

      final GoogleSignIn googleSignIn = GoogleSignIn(
        signInOption: SignInOption.standard,
        // serverClientId:
        //     "185354327561-2d876edbfppficjjt2h04b2el0hf8n8l.apps.googleusercontent.com",
        // scopes: ['email'],
      );
      // if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
      // }
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signIn().catchError((error) async {
        print('Failed to sign in with Google Play Account: $error');
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.signOut();
        }
        setState(() {
          isLoading = false;
        });
      });

      if (googleUser == null) {
        print('Failed to sign in with Google Play Games.');
        if (FirebaseAuth.instance.currentUser != null) {
          await FirebaseAuth.instance.signOut();
        }
        setState(() {
          isLoading = false;
        });
        return Future.value(null);
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      if (result.additionalUserInfo!.isNewUser) {
        print("yeni kullanıcı");
        await FirebaseFirestore.instance
            .collection(KeyUtils.usersCollectionKey)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'favList': "",
          'learnedList': "",
          'GameRecors': {
            'engameGameRecord': 0,
            'soundGameRecord': 0,
            'wordleGameRecord': 0,
            'letterGameRecord': 0,
          }
        });
      }
      // await GoogleSignIn.games().disconnect();
      // await GamesServices.signOut();
      // GamesServices.signIn();
      // await fLoadData(context: context);
      await MainData.localData!
          .put(KeyUtils.userUIDKey, FirebaseAuth.instance.currentUser!.uid);
      MainData.userUID = FirebaseAuth.instance.currentUser!.uid;
      setState(() {
        isLoading = false;
      });
      // await GamesServices.signIn().then((value) async {
      //   await GamesServices.signOut();
      // });
      // await GoogleSignIn.games().signInSilently();
      await GamesServices.signIn().then((value) async {
        // print(await GamesServices.getPlayerID());
        MainData.isGoogleGamesSigned = true;
        await MainData.localData!.put(KeyUtils.isGoogleGamesSignedInKey, true);
        await saveSkipFirstOpen(
          context: context,
          haveUsername: false,
          isGoogleGamesSigned: true,
          isNewUser: result.additionalUserInfo?.isNewUser ?? false,
        );
        await Navigator.of(context).pushNamedAndRemoveUntil(
            KeyUtils.homePageKey, (Route<dynamic> route) => false);
      }).onError((error, stackTrace) {
        print("games servislerine giriş yapılamadı");
        if (FirebaseAuth.instance.currentUser != null) {
          FirebaseAuth.instance.signOut();
        }
      });

      // await GamesServices.signIn().then((value) async {
      //   print("games servislerine giriş yapıldı");
      //   await saveSkipFirstOpen(context: context, haveUsername: true);
      //   await Navigator.of(context).pushNamedAndRemoveUntil(
      //       KeyUtils.homePageKey, (Route<dynamic> route) => false);
      // }).catchError((e) async {
      //   print("games servislerine giriş yapılamadı");
      //   if (FirebaseAuth.instance.currentUser != null) {
      //     await FirebaseAuth.instance.signOut();
      //   }
      // });
      BlocProvider.of<HomePageSelectedWordCubit>(context).StateBuild();
    } catch (e) {
      if (FirebaseAuth.instance.currentUser != null) {
        await FirebaseAuth.instance.signOut();
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print(e.toString());
        widget.showCustomSnackbar(context, "Hata !", color: Colors.red);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: cBackgroundColor,
        resizeToAvoidBottomInset: false,
        // backgroundColor: cBackgroundColor,
        body: Stack(
          children: [
            Container(
              width: ScreenUtil.width,
              height: MediaQuery.of(context).padding.top,
              alignment: Alignment.topCenter,
              color: cBlueBackground,
            ),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 14,
                    child: Container(
                      decoration: BoxDecoration(
                        color: cBlueBackground,
                        border: Border.all(
                          width: 0,
                          color: cBlueBackground,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: cBlueBackground,
                          border: Border.all(
                            width: 0,
                            color: cBlueBackground,
                          ),
                          // borderRadius: const BorderRadius.only(
                          //   bottomLeft: Radius.circular(1500),
                          // ),
                        ),
                      ),
                    ),
                  ),
                  const Expanded(flex: 3, child: SizedBox()),
                ],
              ),
            ),
            SafeArea(
              child: Align(
                alignment: const Alignment(-1, 1),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: ScreenUtil.width * 0.32,
                      height: ScreenUtil.width * 0.25,
                      decoration: const BoxDecoration(
                        // color: Color.fromRGBO(233, 244, 255, 1),
                        color: Color.fromRGBO(76, 81, 198, 1),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(100),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                        Navigator.pushNamed(context, KeyUtils.registerPageKey);
                      },
                      child: Container(
                        width: ScreenUtil.width * 0.3075,
                        height: ScreenUtil.width * 0.2375,
                        decoration: const BoxDecoration(
                          // color: Color.fromRGBO(233, 244, 255, 1),
                          color: Color.fromRGBO(233, 244, 255, 1),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            // top: ScreenUtil.height * 0.02,
                            right: ScreenUtil.width * 0.035,
                          ),
                          child: Center(
                            child: Text(
                              "Register",
                              style: GoogleFonts.fredoka(
                                color: const Color.fromRGBO(76, 81, 198, 1),
                                fontSize: ScreenUtil.textScaleFactor * 26,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(
                  top: ScreenUtil.height * 0.02,
                  right: ScreenUtil.width * 0.03,
                  left: ScreenUtil.width * 0.03,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        //! Anonymous Giriş
                        setState(() {
                          FirebaseAuth.instance
                              .signInAnonymously()
                              .whenComplete(() async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              await saveSkipFirstOpen(context: context);
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  KeyUtils.homePageKey,
                                  (Route<dynamic> route) => false);
                            }
                          });
                        });
                      },
                      child: Text(
                        "Kayıt olmadan devam et",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil.textScaleFactor * 18,
                        ),
                      ),
                    ),
                    LogoWidget(w: ScreenUtil.height * 0.065),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: const Alignment(0.5, 0.67),
                child: GoArrowButton(
                  toDo: () async {
                    try {
                      if (FirebaseAuth.instance.currentUser != null) {
                        await FirebaseAuth.instance.signOut();
                      }
                      //
                      // print(FirebaseAuth.instance.currentUser!);
                      String username = userNameController.text.trim();
                      String password = passwordController.text;

                      if (username.isEmpty) {
                        widget.showCustomSnackbar(
                          context,
                          BlocProvider.of<LoginPageCubit>(context)
                                  .state
                                  .signInKey +
                              " Boş Olamaz",
                          color: Colors.red,
                        );
                        return;
                      } else if (password.isEmpty) {
                        widget.showCustomSnackbar(
                          context,
                          "Şifre Boş Olamaz",
                          color: Colors.red,
                        );
                        return;
                      } else {
                        setState(() {
                          isLoading = true;
                        });

                        if (BlocProvider.of<LoginPageCubit>(context)
                            .state
                            .isSignInUsername) {
                          // var userRef = await FirebaseFirestore.instance
                          //     .collection('Users')
                          //     .where('username', isEqualTo: username)
                          //     .get();

                          // if (userRef.size == 0) {
                          //   print("Kullanıcı Bulunamadı");
                          //   widget.showCustomSnackbar(
                          //     context,
                          //     "Kullanıcı Bulunamadı",
                          //   );
                          //   setState(() {
                          //     isLoading = false;
                          //   });
                          //   return;
                          // }

                          // await FirebaseAuth.instance
                          //     .signInWithEmailAndPassword(
                          //         email: userRef.docs[0]['email'],
                          //         password: password)
                          //     .whenComplete(() async {
                          //   if (FirebaseAuth.instance.currentUser != null) {
                          //     // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          //     await saveSkipFirstOpen(
                          //       haveUsername: true,
                          //       username: userNameController.text.trim(),
                          //       context: context,
                          //     );
                          //     BlocProvider.of<HomePageSelectedWordCubit>(
                          //             context)
                          //         .StateBuild();

                          //     // state build

                          //     Navigator.of(context).pushNamedAndRemoveUntil(
                          //         KeyUtils.homePageKey,
                          //         (Route<dynamic> route) => false);

                          //     print("giris yapildi");
                          //     print(MainData.learnedList);
                          //   }
                          // });
                        } else {
                          var result = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: username, password: password);
                          if (FirebaseAuth.instance.currentUser != null) {
                            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            await saveSkipFirstOpen(
                              haveUsername: true,
                              username:
                                  userNameController.text.split("@").isEmpty
                                      ? ""
                                      : userNameController.text.split("@")[0],
                              isNewUser:
                                  result.additionalUserInfo?.isNewUser ?? false,
                              context: context,
                            );
                            // BlocProvider.of<HomePageSelectedWordCubit>(context)
                            //     .StateBuild();
                            // state build
                            await Navigator.of(context).pushNamedAndRemoveUntil(
                                KeyUtils.homePageKey,
                                (Route<dynamic> route) => false);

                            print("giris yapildi");
                            print(MainData.learnedList);
                          }
                        }
                      }
                    } on FirebaseAuthException catch (e) {
                      print(e.code);
                      if (e.code == "wrong-password") {
                        print("Şifre Hatalı");
                        widget.showCustomSnackbar(
                          context,
                          "Şifre Hatalı",
                          color: Colors.red,
                        );
                        // return;
                      } else {
                        print("Hata !");
                        widget.showCustomSnackbar(
                          context,
                          "Hata !",
                          color: Colors.red,
                        );
                        // return;
                      }
                    }

                    setState(() {
                      isLoading = false;
                    });
                  },
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: ScreenUtil.width * 0.05),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(
                      flex: 3,
                    ),
                    Text(
                      "Login",
                      style: GoogleFonts.fredoka(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: ScreenUtil.textScaleFactor * 48,
                        letterSpacing: ScreenUtil.textScaleFactor * 4,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.height * 0.02,
                    ),
                    Flexible(
                      child: BlocBuilder<LoginPageCubit, LoginPageState>(
                        builder: (context, state) {
                          return Text(
                            state.signInKey,
                            style: GoogleFonts.poppins(
                              fontSize: ScreenUtil.textScaleFactor * 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil.width * 0.05),
                      child: Container(
                        height: ScreenUtil.height * 0.085,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              width: 2,
                              color: const Color.fromRGBO(96, 127, 242, 1)),
                        ),
                        child: BlocBuilder<LoginPageCubit, LoginPageState>(
                          builder: (context, state) {
                            return Center(
                              child: TextField(
                                keyboardType: state.isSignInUsername == true
                                    ? TextInputType.name
                                    : TextInputType.emailAddress,
                                controller: userNameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                    left: 15,
                                    bottom: 11,
                                    top: 11,
                                    right: 15,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // const SizedBox(),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil.width * 0.05),
                      child: Container(
                        height: ScreenUtil.height * 0.085,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              width: 2,
                              color: const Color.fromRGBO(96, 127, 242, 1)),
                        ),
                        child: Center(
                          child: TextField(
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Kullanıcı Şifresi",
                              hintStyle: GoogleFonts.poppins(
                                fontSize: ScreenUtil.textScaleFactor * 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: ScreenUtil.textScaleFactor * 1.5,
                              ),
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // const SizedBox(),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil.width * 0.055),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // GestureDetector(
                          //   onTap: () {
                          //     //!
                          //     BlocProvider.of<LoginPageCubit>(context)
                          //         .ChangeSignInMethod();
                          //   },
                          //   child: BlocBuilder<LoginPageCubit, LoginPageState>(
                          //     builder: (context, state) {
                          //       return Container(
                          //         width: ScreenUtil.width * 0.4,
                          //         height: ScreenUtil.height * 0.05,
                          //         decoration: BoxDecoration(
                          //           borderRadius: const BorderRadius.all(
                          //               Radius.circular(10)),
                          //           border: Border.all(
                          //             color: Colors.white,
                          //             width: 2,
                          //           ),
                          //         ),
                          //         child: Padding(
                          //           padding: const EdgeInsets.all(5),
                          //           child: Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceEvenly,
                          //             children: [
                          //               const Expanded(
                          //                 child: Image(
                          //                     image: AssetImage(
                          //                         "assets/images/d89d897deab62ea991727abe5e8f963e.png")),
                          //               ),
                          //               const SizedBox(width: 5),
                          //               Expanded(
                          //                 flex: 4,
                          //                 child: FittedBox(
                          //                   child: Text(
                          //                     state.isSignInUsername
                          //                         ? "Mail ile giriş"
                          //                         : "Kullanıcı adı ile giriş",
                          //                     style: GoogleFonts.poppins(
                          //                       color: Colors.white,
                          //                       fontWeight: FontWeight.bold,
                          //                     ),
                          //                     maxLines: 1,
                          //                   ),
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       );
                          //     },
                          //   ),
                          // ),

                          //?
                          GestureDetector(
                            onTap: () async {
                              //!
                              // print("object");
                              // if (await GamesServices.isSignedIn) {
                              //   if (FirebaseAuth.instance.currentUser != null) {
                              //     await FirebaseAuth.instance.signOut();
                              //   }
                              //   try {
                              //     await GoogleSignIn.games().disconnect();
                              //     await GamesServices.signOut();
                              //   } catch (e) {
                              //     setState(() {
                              //       isLoading = false;
                              //     });
                              //   }
                              //   // print("anaınsikm");
                              // }
                              await GoogleLogin();
                              // GamesServices.signIn();
                              // pri
                            },
                            child: Container(
                              width: ScreenUtil.width * 0.4,
                              height: ScreenUtil.height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const Expanded(
                                      child: Image(
                                          image: AssetImage(
                                              "assets/images/a425df6d0df9ed03d7521b884e7f8366.png")),
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      flex: 4,
                                      child: FittedBox(
                                        child: Text(
                                          "Google ile giriş",
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: ScreenUtil.height * 0.02),
                    Padding(
                      padding: EdgeInsets.only(right: ScreenUtil.width * 0.085),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              if (BlocProvider.of<LoginPageCubit>(context)
                                          .state
                                          .isSignInUsername ==
                                      true ||
                                  userNameController.text.isEmpty) {
                                widget.showCustomSnackbar(
                                    context, "Lütfen Mail Adresinizi Giriniz",
                                    color: Colors.red);
                                return;
                              }
                              // if(userNameController.text.)
                              try {
                                await FirebaseAuth.instance
                                    .sendPasswordResetEmail(
                                        email: userNameController.text);
                                widget.showCustomSnackbar(
                                    context, "Şifre Sıfırlama Maili Gönderildi",
                                    color: Colors.green);
                              } catch (e) {
                                print(e.toString());
                                widget.showCustomSnackbar(context,
                                    "Lütfen Mail Adresinizi Kontrol Ediniz",
                                    color: Colors.red);
                              }
                            },
                            child: Text(
                              "Şifremi Unuttum",
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 10,
                    ),
                  ],
                ),
              ),
            ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 66, 241, 72),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
