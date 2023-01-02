import 'package:flutter/material.dart';

extension StringExtension on String {
  //* Türkçe kelimeleri türkçede Büyük harfe çevirir
  String ToUpperTurkish() {
    String res = this;
    for (var i = 0; i < res.length; i++) {
      if (res[i] == "i") {
        res = res.replaceRange(i, i + 1, "İ");
      } else if (res[i] == "ç") {
        res = res.replaceRange(i, i + 1, "Ç");
      } else if (res[i] == "ö") {
        res = res.replaceRange(i, i + 1, "Ö");
      } else if (res[i] == "ş") {
        res = res.replaceRange(i, i + 1, "Ş");
      } else if (res[i] == "ü") {
        res = res.replaceRange(i, i + 1, "Ü");
      } else if (res[i] == "ğ") {
        res = res.replaceRange(i, i + 1, "Ğ");
      } else {
        res = res.replaceRange(i, i + 1, res[i].toUpperCase());
      }
    }
    return res;
  }
}
