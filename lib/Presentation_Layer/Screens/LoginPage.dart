import 'package:engame2/Data_Layer/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Data_Layer/consts.dart';

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
      backgroundColor: const Color.fromRGBO(233, 244, 255, 1),
      resizeToAvoidBottomInset: false,
      // backgroundColor: cBackgroundColor,
      body: Stack(
        children: [
          Container(
            height: ScreenUtil.height,
            width: ScreenUtil.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/Login.png"),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              height: ScreenUtil.height,
              width: ScreenUtil.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("assets/images/Login.png"),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: const Alignment(-0.975, 0.935),
              child: GestureDetector(
                onTap: () {
                  //TODO
                },
                child: Text(
                  "Register",
                  style: GoogleFonts.fredoka(
                    fontSize: ScreenUtil.textScaleFactor * 29,
                    fontWeight: FontWeight.w500,
                    color: const Color.fromRGBO(76, 81, 198, 1),
                  ),
                ),
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
                      //!
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
                toDo: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return const LoginPage();
                    }),
                  );
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
                    flex: 1,
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
                  Flexible(
                    child: Text(
                      "  Kullanıcı adı",
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil.textScaleFactor * 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            width: 2,
                            color: const Color.fromRGBO(96, 127, 242, 1)),
                      ),
                      child: TextField(
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
                    ),
                  ),
                  const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                            width: 2,
                            color: const Color.fromRGBO(96, 127, 242, 1)),
                      ),
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
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //!
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
                                          "assets/images/d89d897deab62ea991727abe5e8f963e.png")),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  flex: 4,
                                  child: FittedBox(
                                    child: Text(
                                      "Mail ile kayıt ol",
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
                                      "Google ile kayıt ol",
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
                    flex: 3,
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
