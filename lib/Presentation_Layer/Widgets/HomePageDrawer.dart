import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class HomePageDrawer extends StatefulWidget {
  VoidCallback callback;

  HomePageDrawer({Key? key, required this.callback}) : super(key: key);

  @override
  State<HomePageDrawer> createState() => _HomePageDrawerState();
}

class _HomePageDrawerState extends State<HomePageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.width,
      height: ScreenUtil.height,
      color: cBlueBackground,
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: ScreenUtil.height * 0.015),
                Row(
                  children: [
                    SizedBox(width: ScreenUtil.width * 0.015),
                    IconButton(
                      onPressed: () => widget.callback(),
                      icon: Icon(
                        MdiIcons.close,
                        color: Colors.white,
                        size: ScreenUtil.textScaleFactor * 55,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(
                    top: ScreenUtil.height * 0.025,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: ScreenUtil.height * 0.6,
                        width: ScreenUtil.width * 0.88,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: ScreenUtil.width * 0.8,
                  height: ScreenUtil.height * 0.06,
                  child: ElevatedButton(
                    onPressed: () async {
                      FirebaseAuth.instance.signOut().whenComplete(() async {
                        if (FirebaseAuth.instance.currentUser == null) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/loginPage', (Route<dynamic> route) => false);
                          await fResetData(context: context);
                        }
                      });
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color(0xffbff453a)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          // side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(),
                        const Spacer(),
                        Text(
                          "Çıkış Yap",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: ScreenUtil.textScaleFactor * 21,
                          ),
                        ),
                        const Spacer(),
                        const Icon(MdiIcons.logout),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Align(
              alignment: const Alignment(0, -0.78),
              child: Container(
                decoration: BoxDecoration(
                  color: cBlueBackground,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Padding(
                  padding: EdgeInsets.all(ScreenUtil.width * 0.015),
                  child: CircleAvatar(
                    backgroundImage: Image.network(
                      FirebaseAuth.instance.currentUser!.photoURL ??
                          "http://cdn.onlinewebfonts.com/svg/img_181369.png",
                      fit: BoxFit.contain,
                    ).image,
                    radius: ScreenUtil.height * 0.06,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
