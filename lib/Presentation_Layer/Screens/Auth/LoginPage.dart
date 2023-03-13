import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final googleUser = await GoogleSignIn(
            // signInOption: SignInOption.games,
            // serverClientId:
            //     "185354327561-2d876edbfppficjjt2h04b2el0hf8n8l.apps.googleusercontent.com",
            )
        .signIn();

    final googleAuth = await googleUser?.authentication;

    if (googleAuth != null) {
      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      var result = await FirebaseAuth.instance.signInWithCredential(credential);
      //     .whenComplete(() async {
      //   // await saveSkipFirstOpen(context: context);
      //   // BlocProvider.of<HomePageSelectedWordCubit>(context).StateBuild();

      // });

      print("a");
      if (result.additionalUserInfo!.isNewUser) {
        print("yeni giris");
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
      MainData.isFirstOpen = false;
      await MainData.localData!.put(KeyUtils.isFirstOpenKey, false);
      MainData.localData!
          .put(KeyUtils.userUIDKey, FirebaseAuth.instance.currentUser!.uid);
      MainData.userUID = FirebaseAuth.instance.currentUser!.uid;
      await fLoadData(context: context);
      BlocProvider.of<HomePageSelectedWordCubit>(context).StateBuild();
      Navigator.of(context).pushNamedAndRemoveUntil(
          '/homePage', (Route<dynamic> route) => false);
    }
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
                        Navigator.pushNamed(context, '/registerPage');
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
                                  '/homePage', (Route<dynamic> route) => false);
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
                      //
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
                          var userRef = await FirebaseFirestore.instance
                              .collection('Users')
                              .where('username', isEqualTo: username)
                              .get();

                          if (userRef.size == 0) {
                            print("Kullanıcı Bulunamadı");
                            widget.showCustomSnackbar(
                              context,
                              "Kullanıcı Bulunamadı",
                            );
                            setState(() {
                              isLoading = false;
                            });
                            return;
                          }

                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: userRef.docs[0]['email'],
                                  password: password)
                              .whenComplete(() async {
                            if (FirebaseAuth.instance.currentUser != null) {
                              // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              await saveSkipFirstOpen(
                                haveUsername: true,
                                username: userNameController.text.trim(),
                                context: context,
                              );
                              BlocProvider.of<HomePageSelectedWordCubit>(
                                      context)
                                  .StateBuild();

                              // state build

                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/homePage', (Route<dynamic> route) => false);

                              print("giris yapildi");
                              print(MainData.learnedList);
                            }
                          });
                        } else {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: username, password: password);
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            //!
                            BlocProvider.of<LoginPageCubit>(context)
                                .ChangeSignInMethod();
                          },
                          child: BlocBuilder<LoginPageCubit, LoginPageState>(
                            builder: (context, state) {
                              return Container(
                                width: ScreenUtil.width * 0.4,
                                height: ScreenUtil.height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
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
                                                "assets/images/d89d897deab62ea991727abe5e8f963e.png")),
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        flex: 4,
                                        child: FittedBox(
                                          child: Text(
                                            state.isSignInUsername
                                                ? "Mail ile giriş"
                                                : "Kullanıcı adı ile giriş",
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            //!
                            try {
                              await GoogleLogin();
                            } catch (e) {
                              print(e.toString());
                            }
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
