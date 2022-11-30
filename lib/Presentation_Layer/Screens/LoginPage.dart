import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../Data_Layer/consts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future GoogleLogin() async {
    final googleUser = await GoogleSignIn(signInOption: SignInOption.standard
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: ScreenUtil.height * 0.025),
              Flexible(
                child: Text(
                  "Super Fast",
                  textAlign: TextAlign.center,
                  textScaleFactor: ScreenUtil.textScaleFactor,
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.blueAccent,
                    wordSpacing: ScreenUtil.wordSpacing,
                    letterSpacing: 5.5,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await GoogleLogin();
                },
                child: Container(
                  width: ScreenUtil.height * 0.27,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Lottie.asset(
                    'assets/anothers/123835-fast-red.json',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
