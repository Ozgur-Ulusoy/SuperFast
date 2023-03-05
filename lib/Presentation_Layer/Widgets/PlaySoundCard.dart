import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_svg/svg.dart';

import '../../Data_Layer/consts.dart';

class PlaySoundCard extends StatelessWidget {
  AudioPlayer audioPlayer;
  String urlSource;
  Color color;
  String title;
  PlaySoundCard({
    Key? key,
    required this.audioPlayer,
    required this.urlSource,
    required this.color,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await audioPlayer.play(UrlSource(urlSource));
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
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              FittedBox(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              SvgPicture.asset("assets/images/playSoundIcon.svg"),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
