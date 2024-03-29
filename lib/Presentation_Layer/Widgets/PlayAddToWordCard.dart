import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Data_Layer/consts.dart';
import '../../Data_Layer/data.dart';

class AddToWordCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color color;
  double width;
  AddToWordCard({
    Key? key,
    required this.title,
    required this.onPressed,
    required this.color,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed();
      },
      child: Container(
        width: width,
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
                child: FittedBox(
                  child: Text(
                    title,
                    style: GoogleFonts.robotoSlab(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      textStyle: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                  ),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String getAddToCardTypeTitle(WordFavType wordFavType) {
  switch (wordFavType) {
    case WordFavType.learned:
      return "Bilmediklerime Ekle";
    case WordFavType.nlearned:
      return "Bildiklerime Ekle";
    default:
      return "";
  }
}

String getAddToCardTypeSnackbarTitle(WordFavType wordFavType) {
  switch (wordFavType) {
    case WordFavType.learned:
      return "Bildiklerime Eklendi";
    case WordFavType.nlearned:
      return "Bilmediklerime Eklendi";
    default:
      return "";
  }
}

String getAddToCardFavTitle(bool isFav) {
  if (isFav == true) {
    return "Favorilerden Çıkar";
  } else {
    return "Favorilere Ekle";
  }
}

String getAddToCardTypeFuncType(WordFavType wordFavType) {
  switch (wordFavType) {
    case WordFavType.learned:
      return "NotLearned";
    case WordFavType.nlearned:
      return "Learned";
    default:
      return "";
  }
}

String getAddToCardFavFuncType(bool isFav) {
  if (isFav == true) {
    return "UnFav";
  } else {
    return "Fav";
  }
}
