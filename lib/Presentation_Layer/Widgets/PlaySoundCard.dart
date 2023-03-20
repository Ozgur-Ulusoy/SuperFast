import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:engame2/Data_Layer/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../Data_Layer/consts.dart';

class PlaySoundCard extends StatelessWidget with PopUpMixin {
  AudioPlayer audioPlayer;
  // String urlSource;
  String wordEn;
  Color color;
  String title;
  PlaySoundCard({
    Key? key,
    required this.audioPlayer,
    // required this.urlSource,
    required this.wordEn,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // await audioPlayer.play(UrlSource(urlSource));
        String url = await getSoundUrl(wordEn);
        if (url == "") {
          showCustomSnackbar(context, "Ses Bulunamadı");
          return;
        }
        await audioPlayer.play(UrlSource(url));
      },
      child: Container(
        width: ScreenUtil.width * 0.35,
        height: ScreenUtil.height * 0.06,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Spacer(),
              FittedBox(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // const Spacer(
              //   flex: 2,
              // ),
              SizedBox(width: ScreenUtil.width * 0.05),
              SvgPicture.asset("assets/images/playSoundIcon.svg"),
              // const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
