import 'package:engame2/Data_Layer/consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Business_Layer/cubit/question_cubit.dart';

class ChoiceCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final int id;

  const ChoiceCard({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (BlocProvider.of<QuestionCubit>(context).state.isAnswered == false) {
          onPressed();
        }
      },
      child: Container(
        // width: ScreenUtil.width*0.35
        decoration: BoxDecoration(
          color: returnCardColor(context, id),
          borderRadius: BorderRadius.circular(10),
          border: returnCardBorder(context, id),
        ),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: returnCardTitleColor(context, id),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color returnCardColor(BuildContext context, int id) {
  if (BlocProvider.of<QuestionCubit>(context).state.isAnswered == false) {
    return const Color(0xff4C51C6).withOpacity(0.31);
  } else {
    if (id == BlocProvider.of<QuestionCubit>(context).state.data.id) {
      return const Color(0xffCBE896).withOpacity(0.31);
    } else if (id == BlocProvider.of<QuestionCubit>(context).state.selectedId) {
      return const Color(0xffFF1B1C).withOpacity(0.31);
    } else {
      return const Color(0xff4C51C6).withOpacity(0.31);
    }
  }
}

Color returnCardTitleColor(BuildContext context, int id) {
  if (BlocProvider.of<QuestionCubit>(context).state.isAnswered == false) {
    return cBlueBackground;
  } else {
    if (id == BlocProvider.of<QuestionCubit>(context).state.data.id) {
      return cBlueBackground.withOpacity(0.61);
    } else if (id == BlocProvider.of<QuestionCubit>(context).state.selectedId) {
      return const Color.fromARGB(255, 164, 82, 220);
    } else {
      return cBlueBackground;
    }
  }
}

Border? returnCardBorder(BuildContext context, int id) {
  if (BlocProvider.of<QuestionCubit>(context).state.isAnswered == false) {
    if (id != BlocProvider.of<QuestionCubit>(context).state.selectedId) {
      return null;
    } else {
      return Border.all(color: const Color(0xff607FF2), width: 2);
    }
  } else {
    if (id == BlocProvider.of<QuestionCubit>(context).state.data.id) {
      return Border.all(color: const Color(0xffCBE896), width: 2);
    } else if (id == BlocProvider.of<QuestionCubit>(context).state.selectedId) {
      return Border.all(color: const Color(0xffFF1B1C), width: 2);
    } else {
      return null;
    }
  }
}
