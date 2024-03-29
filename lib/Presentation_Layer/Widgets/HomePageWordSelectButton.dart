import 'package:engame2/Business_Layer/cubit/home_page_selected_word_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';

class WordCardSelectButton extends StatefulWidget {
  WordSelectedStateEnums type;
  String baslik;
  VoidCallback callback;
  bool isMyWordsPage;
  WordCardSelectButton({
    Key? key,
    required this.type,
    required this.baslik,
    required this.callback,
    this.isMyWordsPage = false,
  }) : super(key: key);

  @override
  State<WordCardSelectButton> createState() => _WordCardSelectButtonState();
}

class _WordCardSelectButtonState extends State<WordCardSelectButton> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageSelectedWordCubit, HomePageSelectedWordState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            BlocProvider.of<HomePageSelectedWordCubit>(context)
                .ChangeState(widget.type);
            widget.callback();
          },
          child: Container(
            width: ScreenUtil.width * 0.42,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: widget.isMyWordsPage && state.type == widget.type
                    ? Border.all(
                        color: cBlueBackground,
                        width: ScreenUtil.textScaleFactor * 1.25,
                      )
                    : null),
            child: Center(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ScreenUtil.width * 0.01),
                child: FittedBox(
                  child: Text(
                    widget.baslik,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      color: widget.isMyWordsPage
                          ? (widget.type == state.type
                              ? cBlueBackground
                              : const Color.fromRGBO(34, 35, 39, 1))
                          : (widget.type == state.type
                              ? const Color.fromRGBO(34, 35, 39, 1)
                              : const Color.fromRGBO(34, 35, 39, 1)
                                  .withOpacity(0.5)),
                      fontSize: ScreenUtil.textScaleFactor * 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
