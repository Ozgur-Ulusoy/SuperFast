import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Widgets/GoArrowButtonWidget.dart';
import '../Widgets/LogoWidget.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  Future singUpWithEmail(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        return FirebaseFirestore.instance
            .collection("Users")
            .doc(value.user!.uid)
            .set({
          'username': usernameController.text.trim(),
          'email': value.user!.email,
          'favList': "",
          'learnedList': "",
        });
      }).whenComplete(
        () async {
          //TODO
          //! Ana Sayfaya Git
          if (FirebaseAuth.instance.currentUser != null) {
            saveSkipFirstOpen(
                haveUsername: true,
                username: usernameController.text.trim(),
                context: context);
            await fLoadData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/homePage', (Route<dynamic> route) => false);
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(233, 244, 255, 1),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                const Expanded(flex: 6, child: SizedBox()),
                Expanded(
                  flex: 8,
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: ClipPath(
                      clipper: TriangleClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                            color: cBlueBackground,
                            // border: Border.all(
                            //   color: cBlueBackground,
                            // ),
                            border: Border.all(
                              width: 0,
                              color: cBlueBackground,
                            )
                            // borderRadius: const BorderRadius.only(
                            //   bottomLeft: Radius.circular(1500),
                            // ),
                            ),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   height: 50,
                //   decoration: BoxDecoration(
                //       color: cBlueBackground,
                //       border: Border.all(
                //         color: cBlueBackground,
                //       )),
                // ),
                Expanded(
                  flex: 12,
                  child: Container(
                    decoration: BoxDecoration(
                        color: cBlueBackground,
                        border: Border.all(
                          width: 0,
                          color: cBlueBackground,
                        )),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: ScreenUtil.width * 0.25,
                        height: ScreenUtil.width * 0.25,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(76, 81, 198, 1),
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: ScreenUtil.width * 0.025,
                              top: ScreenUtil.height * 0.02),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: LogoWidget(w: ScreenUtil.width * 0.12),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        //
                      },
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            width: ScreenUtil.width * 0.3,
                            height: ScreenUtil.width * 0.3,
                            decoration: const BoxDecoration(
                              // color: Color.fromRGBO(233, 244, 255, 1),
                              color: Color.fromRGBO(76, 81, 198, 1),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              //
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: ScreenUtil.width * 0.285,
                              height: ScreenUtil.width * 0.285,
                              decoration: const BoxDecoration(
                                // color: Color.fromRGBO(233, 244, 255, 1),
                                color: Color.fromRGBO(233, 244, 255, 1),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil.height * 0.02,
                                  left: ScreenUtil.width * 0.02,
                                ),
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: GoogleFonts.fredoka(
                                      color:
                                          const Color.fromRGBO(76, 81, 198, 1),
                                      fontSize: ScreenUtil.textScaleFactor * 29,
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
                  ],
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.topCenter,
          //   child: Container(
          //     width: ScreenUtil.width,
          //     height: MediaQuery.of(context).padding.top,
          //     color: const Color.fromRGBO(233, 244, 255, 1),
          //   ),
          // ),
          SafeArea(
            child: Align(
              alignment: const Alignment(-0.4, -0.40),
              child: GoArrowButton(
                toDo: () async {
                  await singUpWithEmail(emailController.text.trim(),
                      passwordController.text.trim());
                  // Navigator.pushNamed(
                  //   context,
                  //   '/loginPage',
                  // );
                },
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: ScreenUtil.width * 0.035),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 30, child: SizedBox()),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Register",
                          style: GoogleFonts.fredoka(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              fontSize: ScreenUtil.textScaleFactor * 48),
                        ),
                      ),
                    ],
                  ),

                  Expanded(flex: 2, child: Container()),

                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          "Kullanıcı Adı",
                          style: GoogleFonts.poppins(
                            fontSize: ScreenUtil.textScaleFactor * 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.1),
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
                          keyboardType: TextInputType.name,
                          controller: usernameController,
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
                  ),
                  // const SizedBox(),
                  // const Spacer(),
                  const Expanded(flex: 3, child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.1),
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
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "Email",
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
                  const Expanded(flex: 3, child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(right: ScreenUtil.width * 0.1),
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
                  const Expanded(flex: 5, child: SizedBox()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
