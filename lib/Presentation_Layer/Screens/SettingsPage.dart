import 'package:engame2/Data_Layer/consts.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
            Padding(
              padding: EdgeInsets.only(
                left: ScreenUtil.width * 0.05,
              ),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      "Ayarlar",
                      style: GoogleFonts.poppins(
                        fontSize: ScreenUtil.letterSpacing * 28,
                        fontWeight: FontWeight.bold,
                        color: cBlueBackground,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
