import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Business_Layer/cubit/login_page_cubit.dart';
import 'package:engame2/Data_Layer/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class LoginPage extends StatefulWidget {
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
      await FirebaseAuth.instance.signInWithCredential(credential);
      saveSkipFirstOpen();
    }
  }

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    userNameController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  flex: 6,
                  child: Container(
                    color: cBlueBackground,
                  ),
                ),
                Expanded(
                  flex: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: cBlueBackground,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(1500),
                      ),
                    ),
                  ),
                ),
                const Expanded(flex: 2, child: SizedBox()),
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
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/homePage', (Route<dynamic> route) => false);
                            saveSkipFirstOpen();
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
              alignment: const Alignment(0.6, 0.825),
              child: GoArrowButton(
                toDo: () async {
                  try {
                    //
                    String username = userNameController.text.trim();
                    String password = passwordController.text.trim();

                    if (userNameController.text.isEmpty) {
                      print("Kullanıcı Adı Boş Olamaz");
                    } else if (passwordController.text.isEmpty) {
                      print("Şifre Boş Olamaz");
                    } else {
                      if (BlocProvider.of<LoginPageCubit>(context)
                          .state
                          .isSignInUsername) {
                        var userRef = await FirebaseFirestore.instance
                            .collection('Users')
                            .where('username', isEqualTo: username)
                            .get();

                        if (userRef.size == 0) {
                          print("Kullanıcı Bulunamadı");
                          return;
                        }

                        await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: userRef.docs[0]['email'],
                                password: password)
                            .whenComplete(() {
                          if (FirebaseAuth.instance.currentUser != null) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/homePage', (Route<dynamic> route) => false);
                            saveSkipFirstOpen();
                            print("giris yapildi");
                          }
                        });
                      } else {
                        FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: username, password: password);
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    print(e.code);
                    if (e.code == "wrong-password") {
                      print("Şifre Hatalı");
                    } else {
                      print("Hata !");
                    }
                  }
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
                                disabledBorder: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    flex: 8,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // path.moveTo(size.width, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    // path.addArc(Rect.largest, 15, 45);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => true;
}
