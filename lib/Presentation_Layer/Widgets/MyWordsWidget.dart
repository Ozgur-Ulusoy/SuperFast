import 'package:audioplayers/audioplayers.dart';
import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../Business_Layer/cubit/home_page_selected_word_cubit.dart';
import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class MyWordsWidget extends StatefulWidget with PopUpMixin {
  ScrollController scrollController;
  AudioPlayer audioPlayer;
  double lastItemHeight;
  List<Data> dataList;
  MyWordsWidget({
    Key? key,
    required this.scrollController,
    required this.audioPlayer,
    this.lastItemHeight = 0,
    required this.dataList,
  }) : super(key: key);

  @override
  State<MyWordsWidget> createState() => _MyWordsWidgetState();
}

class _MyWordsWidgetState extends State<MyWordsWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45),
            topRight: Radius.circular(45),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: ScreenUtil.height * 0.045,
            left: ScreenUtil.width * 0.02,
            right: ScreenUtil.width * 0.02,
          ),
          child: ClipRRect(
            child: BlocBuilder<HomePageSelectedWordCubit,
                HomePageSelectedWordState>(
              builder: (context, state) {
                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  controller: widget.scrollController,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    //
                    return index < widget.dataList.length
                        ? GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              BlocProvider.of<HomePageSelectedWordCubit>(
                                      context)
                                  .changeCurrentData(
                                widget.dataList[index],
                              );
                              widget.openWordPopUp(context,
                                  widget.dataList[index], widget.audioPlayer);
                            },
                            child: SizedBox(
                              height: 50,
                              width: ScreenUtil.width,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  // Flexible(
                                  //   child: GestureDetector(
                                  //     behavior: HitTestBehavior.translucent,
                                  //     onTap: () => widget.OpenWordPopUp(context),
                                  //     child: Container(
                                  //       width: 500,
                                  //     ),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    width: ScreenUtil.width * 0.18,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: FittedBox(
                                            child: Text(
                                              widget.dataList[index].english,
                                              style: const TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: ScreenUtil.width * 0.05,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            widget.dataList[index].level.name
                                                .toUpperCase(),
                                            // "dsaşdsaşdsdadsasd",
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () async {
                                      //
                                      String url = await getSoundUrl(
                                          widget.dataList[index].english);
                                      if (url == "") {
                                        widget.showCustomSnackbar(
                                            context, "Ses Bulunamadı");
                                        return;
                                      }
                                      await widget.audioPlayer
                                          .play(UrlSource(url));
                                    },
                                    child: SvgPicture.asset(
                                      "assets/images/playSoundVector.svg",
                                      // fit: BoxFit.contain,
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    width: ScreenUtil.width * 0.15,
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.dataList[index].turkish,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(
                            height: widget.lastItemHeight,
                          );
                  },
                  separatorBuilder: (context, index) {
                    return index < widget.dataList.length - 1
                        ? CustomPaint(painter: DrawDottedhorizontalline())
                        : const SizedBox();
                  },
                  // itemCount: state.learnedWordsList.length,
                  itemCount: widget.dataList.length + 1,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class DrawDottedhorizontalline extends CustomPainter {
  Paint _paint = Paint();
  DrawDottedhorizontalline() {
    _paint = Paint();
    _paint.color = const Color.fromRGBO(76, 81, 198, 0.46); //dots color
    _paint.strokeWidth = 2; //dots thickness
    _paint.strokeCap = StrokeCap.square; //dots corner edges
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (double i = -ScreenUtil.width; i < ScreenUtil.width; i = i + 15) {
      // 15 is space between dots
      // if (i % 3 == 0) {
      canvas.drawLine(Offset(i, 0.0), Offset(i + 10, 0.0), _paint);
      // }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
