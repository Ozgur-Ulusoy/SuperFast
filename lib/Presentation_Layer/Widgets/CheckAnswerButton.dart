import 'package:engame2/Data_Layer/Mixins/PopUpMixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Business_Layer/cubit/question_cubit.dart';
import '../../Business_Layer/cubit/timer_cubit.dart';
import '../../Data_Layer/consts.dart';

class CheckAnswerButton extends StatelessWidget with PopUpMixin {
  VoidCallback callback;
  CheckAnswerButton({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCubit, QuestionState>(
      builder: (context, state) {
        return MaterialButton(
          minWidth: ScreenUtil.width * 0.82,
          height: ScreenUtil.height * 0.085,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          color: cBlueBackground,
          // color: const Color(0xff4C51C6),
          onPressed: () {
            callback();
          },
          child: Text(
            state.isAnswered ? "Sonraki Soru" : "Kontrol Et",
            style: GoogleFonts.poppins(
              fontSize: ScreenUtil.letterSpacing * 25,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
