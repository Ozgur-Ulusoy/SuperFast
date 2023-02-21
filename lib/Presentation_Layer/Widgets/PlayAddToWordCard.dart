import 'package:engame2/Business_Layer/cubit/question_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';

class AddToWordCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  const AddToWordCard({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: ScreenUtil.width * 0.41,
        height: ScreenUtil.height * 0.055,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: FittedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: GoogleFonts.robotoSlab(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
