import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Screens/HomePage.dart';
import 'package:engame2/Presentation_Layer/Screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // FirebaseAuth mAuth = FirebaseAuth.instance;
  // User? currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // BlocProvider.of<UserCubit>(context).();
    // currentUser = mAuth.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    try {
      print(FirebaseAuth.instance.currentUser!.displayName);
      print(FirebaseAuth.instance.currentUser!.email);
      print(FirebaseAuth.instance.currentUser!.emailVerified);
      print(FirebaseAuth.instance.currentUser!.photoURL);
    } catch (e) {
      print("user null");
    }

    ScreenUtil.init(context);
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return const HomePage();
          } else if (snapshot.hasError) {
            return const Center(
              child: Center(child: Text("Error !")),
            );
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}