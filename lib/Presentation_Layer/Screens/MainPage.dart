import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:engame2/Presentation_Layer/Screens/HomePage.dart';
import 'package:engame2/Presentation_Layer/Screens/FirstPage.dart';
import 'package:engame2/Presentation_Layer/Screens/LoginPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        print("resume");
        //Execute the code here when user come back the app.
        //In my case, I needed to show if user active or not,
        // FirebaseMethods().updateLiveStatus(_authInstance.currentUser.uid, true);
        break;
      case AppLifecycleState.paused:
        print("pause");
        //Execute the code the when user leave the app
        // FirebaseMethods()
        //     .updateLiveStatus(_authInstance.currentUser.uid, false);
        break;

      case AppLifecycleState.inactive:
        print("inactive");
        if (FirebaseAuth.instance.currentUser != null &&
            MainData.isFavListChanged == true) {
          await FirebaseFirestore.instance
              .collection("Users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({'favList': MainData.favList});
          print("bitti");
          MainData.isFavListChanged = false;
        }
        break;

      case AppLifecycleState.detached:
        print("detached");

        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return FirebaseAuth.instance.currentUser != null
        ? const HomePage()
        : MainData.isFirstOpen == true
            ? const FirstOpenPage()
            : const LoginPage();
    // Scaffold(
    //   body: StreamBuilder(
    //     stream: FirebaseAuth.instance.authStateChanges(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       } else if (snapshot.hasData) {
    //         return const HomePage();
    //       } else if (snapshot.hasError) {
    //         return const Center(
    //           child: Center(child: Text("Error !")),
    //         );
    //       } else {
    //         return MainData.isFirstOpen == true
    //             ? const FirstOpenPage()
    //             : const LoginPage();
    //       }
    //     },
    //   ),
    // );
  }
}
