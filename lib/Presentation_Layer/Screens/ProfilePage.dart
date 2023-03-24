import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:engame2/Data_Layer/consts.dart';
import 'package:engame2/Presentation_Layer/Widgets/ProgressingContainer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/data.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.width * 0.035,
                top: ScreenUtil.height * 0.035,
                right: ScreenUtil.width * 0.035,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      size: ScreenUtil.letterSpacing * 40,
                      color: cBlueBackground,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            //!
            // const Spacer(),
            Text(
              "Rekorlar",
              style: GoogleFonts.poppins(
                fontSize: ScreenUtil.textScaleFactor * 28,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.0125),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil.width * 0.1),
              child: Row(
                children: [
                  SizedBox(
                    // width: ScreenUtil.width * 0.85,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Test Oyunu : " + MainData.engameGameRecord.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: cBlueBackground,
                          fontSize: ScreenUtil.textScaleFactor * 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil.width * 0.1),
              child: Row(
                children: [
                  SizedBox(
                    // width: ScreenUtil.width * 0.85,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Kelime Oyunu : " +
                            MainData.letterGameRecord.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: cBlueBackground,
                          fontSize: ScreenUtil.textScaleFactor * 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.015),
            Padding(
              padding: EdgeInsets.only(left: ScreenUtil.width * 0.1),
              child: Row(
                children: [
                  SizedBox(
                    // width: ScreenUtil.width * 0.85,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Sesli Kelime Oyunu : " +
                            MainData.soundGameRecord.toString(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: cBlueBackground,
                          fontSize: ScreenUtil.textScaleFactor * 25,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ScreenUtil.height * 0.045),
            //
            // const Spacer(),
            //
            Text(
              "Kelimeler",
              style: GoogleFonts.poppins(
                fontSize: ScreenUtil.textScaleFactor * 28,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            SizedBox(height: ScreenUtil.height * 0.0125),
            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return SizedBox(
                  width: ScreenUtil.width * 0.85,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Bildiğin Kelimeler (${state.learnedWordsList.length})",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: cBlueBackground,
                        fontSize: ScreenUtil.textScaleFactor * 25,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.015),
            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return ProgressingContainer(
                  dividingCount: state.learnedWordsList.length,
                  totalCount: questionData.length,
                  color: Colors.green,
                );
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            //
            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return SizedBox(
                  width: ScreenUtil.width * 0.85,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Bilmediğin Kelimeler (${state.notLearnedWordsList.length})",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: cBlueBackground,
                        fontSize: ScreenUtil.textScaleFactor * 25,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.015),
            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return ProgressingContainer(
                  dividingCount: state.notLearnedWordsList.length,
                  totalCount: questionData.length,
                  color: Colors.red,
                );
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.025),
            //

            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return SizedBox(
                  width: ScreenUtil.width * 0.85,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Favori Kelimeler (${state.favWordsList.length})",
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil.textScaleFactor * 25,
                        fontWeight: FontWeight.bold,
                        color: cBlueBackground,
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: ScreenUtil.height * 0.015),
            BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
              builder: (context, state) {
                return ProgressingContainer(
                  dividingCount: state.favWordsList.length,
                  totalCount: questionData.length,
                  color: Colors.blue,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
