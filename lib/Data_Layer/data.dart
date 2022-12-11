import 'package:hive_flutter/hive_flutter.dart';

class Data {
  String english; //? ingilizce hali
  String turkish; //? turkce hali
  WordType type; //? tip'i ( isim zamir fiil vb. )
  WordLevel level; //? ingilizce level seviyesi
  String mediaLink; //? ses dosyasi linki
  WordFavType favType;

  Data({
    required this.english,
    required this.turkish,
    required this.level,
    required this.type,
    required this.mediaLink,
    this.favType = WordFavType.nlearned,
  });
}

Future<void> fLoadData() async {
  await Hive.initFlutter();
  MainData.localData = await Hive.openBox("SuperFastBox");

  if (MainData.localData!.get("isFirstOpen") == null) {
    MainData.localData!.put("isFirstOpen", true);
  }
  MainData.isFirstOpen = MainData.localData!.get("isFirstOpen");
}

Future<void> saveSkipFirstOpen() async {
  MainData.localData!.put("isFirstOpen", false);
  MainData.isFirstOpen = false;
}

class MainData {
  static Box? localData;
  static bool? isFirstOpen = true;
}

enum WordLevel {
  a1,
  a2,
  b1,
  b2,
  c1,
  c2,
}

enum WordType {
  verb, //* fiil
  noun, //* isim
  adjective, //* sıfat
  adverb, //* zarf
  preposition //* edat
}

enum WordFavType {
  learned,
  learning,
  nlearned,
}

List<Data> questionData = [
  Data(
    english: "Abolish",
    turkish: "Son Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1X7KSD2WwdBUIkLxrGzgq_zjYtKr2Ur86",
    // favType: WordFavType.learned,
  ),
  Data(
    english: "Abortion",
    turkish: "Kürtaj",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1CHxmAMSOcJsjAuHBm-40gi4pG8Ui5KK9",
  ),
  Data(
    english: "Absence",
    turkish: "Olmayış",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1wwsuFtGZnI2KXD3DOJA0pu_NDF3v_4Sp",
  ),
  Data(
      english: "Absent",
      turkish: "Yok",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1GNutnkX1g8cD5WUDyJFR0XhjO1lJhM-Y"),
  Data(
    english: "Absorb",
    turkish: "Emmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1o5k-rnTmoSNUsZTmY5OK7Lu885vk3O70",
  ),
  Data(
    english: "Abstract",
    turkish: "Soyut",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Q4Gchr5afLUDmsbV2XzVbgKC0oslM_nW",
  ),
  Data(
    english: "Absurd",
    turkish: "Saçma",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YDYkuxd_8y94TU_RrSoQbPFrCqT9Hp7r",
  ),
  Data(
    english: "Abuse",
    turkish: "İstismar",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
  ),
  Data(
    english: "Abuse",
    turkish: "Kötüye Kullanma",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
  ),
  Data(
    english: "Academy",
    turkish: "Akademi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hIvdev2HHiakazWoS6UA65hmREsrXMr0",
  ),
  Data(
    english: "Accelerate",
    turkish: "Hızlanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Ra16GiSp9n3rrttHJobtWR-WpJCsnElI",
  ),
  Data(
    english: "Accent",
    turkish: "Aksan",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1m5wqpGWRhLCXn7O66Bl33Hv9yBIgJkGP",
  ),
  Data(
    english: "Acceptance",
    turkish: "Kabul",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Bmq_8d3kvFMFpmIKJsDVxdshBWPKDJxA",
  ),
  Data(
    english: "Accessible",
    turkish: "Ulaşılabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-72_Pu_AUPMV5h4siys4A3l-09IH7mrH",
  ),
  Data(
    english: "Accidentally",
    turkish: "Tesadüfen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xrrGiLDkdsoDgCp4ijQy6WVNLaffU38n",
  ),
  Data(
    english: "Accommodate",
    turkish: "Tedarik Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ypwijSBPabhOmn-8ALNegNOkaX5XNxox",
  ),
  Data(
    english: "Accommodation",
    turkish: "İkametgah",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hfijJd1ApLg1TMiumodpVrEdoE-DQRis",
  ),
  Data(
    english: "Accomplish",
    turkish: "Başarmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1GzezRpMPo0Iwyj8SFRrmmnfv8K53ido9",
  ),
  Data(
    english: "Accomplishment",
    turkish: "Başarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Bc_K94nj0I1IIxnxufS7GjBr_sRtWjF0",
  ),
  Data(
    english: "Accordingly",
    turkish: "Buna Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1C3DyZth-MhYDGWRySDuliSvDGIfzqfUo",
  ),
  Data(
    english: "Accountability",
    turkish: "Sorumluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15G27ZqvSUEtuSItNl4q-7XVek-Iem5E_",
  ),
  Data(
    english: "Accountable",
    turkish: "Sorumlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eSDIPzkxJSVMalfwo3Gskd-eor2UyGQR",
  ),
  Data(
    english: "Accountant",
    turkish: "Muhasebeci",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1eAkmvWcHtNP9xqpFtfWlx0umOd-OCnCk",
  ),
  Data(
    english: "Accumulate",
    turkish: "Biriktirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LpFhq0HI1wdSwCmYAWTBa2mI9KrMTzZE",
  ),
  Data(
    english: "Accumulation",
    turkish: "Birikme",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VgbjS_XKhsZsLCBfX49ZPyKzgo1RhGSl",
  ),
  Data(
    english: "Accuracy",
    turkish: "Doğruluk",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FBiO3RDQFmw1tRqJcq5I94SitQbpEHNX",
  ),
  Data(
    english: "Accurately",
    turkish: "Tam Olarak",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qbXNoaWCYyrOlnIZdK0_f9l6OlZcqtNP",
  ),
  Data(
    english: "Accusation",
    turkish: "Suçlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1iAc5RkzrduuKu_s_XTW1bM5AFL20V8Wr",
  ),
  Data(
    english: "Accused",
    turkish: "Sanık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=1SlZXy2Mu-_QgdLGSui4F7JjEbcElm1Y-",
  ),
  Data(
    english: "Acid",
    turkish: "Asit",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
  ),
  Data(
    english: "Acid",
    turkish: "Asitli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
  ),
  Data(
    english: "Acquisition",
    turkish: "Edinim",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1prYxOsYe-XNeIT1OPg-gqG86HKCmnzG_",
  ),
  Data(
    english: "Acre",
    turkish: "Hektar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LhMM1VMEBL3YyC0AIz0sK9v1H5KMwbtM",
  ),
  Data(
    english: "Activate",
    turkish: "Çalıştırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1H75OoLMtU-5upOBjtTtaa95hqetJzz3T",
  ),
  Data(
    english: "Activation",
    turkish: "Aktifleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mn2sxnJLpEPDmVjqwLpHOoHHBRWC23mW",
  ),
  Data(
    english: "Activist",
    turkish: "Savunucu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ohSi-FEdObYcuY49nkyUpYyLTwXQ5Otx",
  ),
  Data(
    english: "Acute",
    turkish: "Şiddetli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=168F98_OljdKFjbDtKh2I2cutZx1pfGAD",
  ),
  Data(
    english: "Adaptation",
    turkish: "Uyarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1tZbzbHhXvk0mamiVTEjLN_pLoLUhBHCW",
  ),
  Data(
    english: "Addiction",
    turkish: "Bağımlılık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xHozXnoUsjdJWYE4hXQj_14uWHl9zgN8",
  ),
  Data(
    english: "Additionally",
    turkish: "İlaveten",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13Y7NwMnvDdrUMui1T2z8UydujTtj0tdL",
  ),
  Data(
    english: "Adequate",
    turkish: "Yeterli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1V6oAqPDm5RPAFPaKbszffdyDcPiEUV3y",
  ),
  Data(
    english: "Adequately",
    turkish: "Yeterince",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1D04jd4kM9LTrQg1KFRI4Hug9RG6-QDr1",
  ),
  Data(
    english: "Adhere",
    turkish: "Yapışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=1f1DBUI-SxdqtGqbYXN4mxizkMgZL7Csc",
  ),
  Data(
    english: "Adjacent",
    turkish: "Bitişik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PMipKnVa3Y_FXvc8DQIckNHe-jD7eg-R",
  ),
  Data(
    english: "Adjust",
    turkish: "Ayarlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1rhwwdcigtutgbNWRCfi2JeWOHC0EGdT8",
  ),
  Data(
    english: "Adjustment",
    turkish: "Ayarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1gB5EPbCnsX74H3YtfMsfBJPotMS9tyG5",
  ),
  Data(
    english: "Administer",
    turkish: "İdare Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XcWpvDY7CQsqfyMLE9-w7Ed2WczIzGD2",
  ),
  Data(
    english: "Administrative",
    turkish: "İdari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Sox3D78HFO0H77epmq7A0lEDSXlLeBnV",
  ),
  Data(
    english: "Administrator",
    turkish: "Yönetici",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BL1X1vrqO8CR4kthwE42CmtSpdnJc06f",
  ),
  Data(
    english: "Admission",
    turkish: "İtiraf",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k9ya9G5pDWS4j_f3IPTyOsjUz3vCZncp",
  ),
  Data(
    english: "Adolescent",
    turkish: "Ergen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1UUp7XeVJEnjhummmy7eMa6Xdfru-V0h6",
  ),
  Data(
    english: "Adoption",
    turkish: "Benimseme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13cdOhE8QuBr_pJQ_frlfFqajXQ5BFmEO",
  ),
  Data(
    english: "Adverse",
    turkish: "Karşıt",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16ZNzFiIiyFxHYyErutkt--FH_Nbm75WJ",
  ),
  Data(
    english: "Advocate",
    turkish: "Desteklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
  ),
  Data(
    english: "Advocate",
    turkish: "Destekleyen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
  ),
  Data(
    english: "Aesthetic",
    turkish: "Estetik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1DC4pM41-90ox15wAKGdzUYIXihQU6-7N",
  ),
  Data(
    english: "Affection",
    turkish: "Sevgi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1f8YaqvHRZDg7m26yzgUYBcDGIvtvSAlN",
  ),
  Data(
    english: "Affordable",
    turkish: "Alınabilir",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1V2wABU3iARv7GyLbSs_DZpNPWYQxmpE2",
  ),
  Data(
    english: "Aftermath",
    turkish: "Sonrası",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1OKXTDV-xF4_4jsMqVo4tSHhHzc4GPZ1T",
  ),
  Data(
    english: "Aged",
    turkish: "Yaşlanmış",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=182lMlz4Vyom8jEL1PzsudHeZz4DwBT5M",
  ),
  Data(
    english: "Aggression",
    turkish: "Saldırganlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1h5L8fvCdHnx4YGCfq42omdZhjE0KM26W",
  ),
  Data(
    english: "Agricultural",
    turkish: "Tarımsal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ROVqgV8WRKQmwn4VEsGyaGvoNy8cJ3fy",
  ),
  Data(
    english: "Agriculture",
    turkish: "Ziraat",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZnvEe3iYgzFYZh7TCsSvjkdzNlHLfr76",
  ),
  Data(
    english: "Aide",
    turkish: "Yardımcı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15qvk9g--wN3QXQVylRf4V9ZE7DcfmTsu",
  ),
  //!
  Data(
    english: "Alert",
    turkish: "Uyarmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alert",
    turkish: "Uyarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alert",
    turkish: "Dikkatli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alien",
    turkish: "Uzaylı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
  ),
  Data(
    english: "Alien",
    turkish: "Acayip",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
  ),
  Data(
    english: "Align",
    turkish: "Hizalamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zpK5ui7GZLOxpFcANQKE8swLW8neEP4B",
  ),
  Data(
    english: "Alignment",
    turkish: "Aynı Hizaya Getirmek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fOuPeaY5sWJmXoBcABL4cpZlQW_K_POr",
  ),
  Data(
    english: "Alike",
    turkish: "Aynı Şekilde",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
  ),
  Data(
    english: "Alike",
    turkish: "Benzer",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
  ),
  Data(
    english: "Allegation",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1LTG1M64j9ALtGklxnGMg8T5Uh-I0Fvzd",
  ),
  Data(
    english: "Allege",
    turkish: "İddia Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dxfYHqVfsbE0XkcrHp1yFPMeFWfUonP9",
  ),
  Data(
    english: "Allegedly",
    turkish: "İddiaya Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1rntCt1x7f5OcCPcvuVUQiBJgBE_xzSZA",
  ),
  Data(
    english: "Alliance",
    turkish: "İttifak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T9Kp-Js7mtMVXZMDxXcF0gXN9fMuMdQg",
  ),
  Data(
    english: "Allocate",
    turkish: "Ayırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_3kU1xneTzG50yEiCZbnnKOZ3Dn6t_nB",
  ),
  Data(
    english: "Allocation",
    turkish: "Tahsisat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13lo2tqgcOjOJsP7b4WnhvmJ97nSDZuDl",
  ),
  Data(
    english: "Allowance",
    turkish: "Ödenek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dLZbvPVfwDvp9yLDySVrmzy8BG_XyUUR",
  ),
  Data(
    english: "Ally",
    turkish: "Müttefik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1A_YqDbxN7L8AfPcz6ZvW_GUdpbeuzrQo",
  ),
  Data(
    english: "Alongside",
    turkish: "Yanıbaşında",
    level: WordLevel.b2,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YMuOiThlK4Kf-vn7QLSRvz_VxfuXkBxX",
  ),
  Data(
    english: "Altogether",
    turkish: "Tamamen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AjCqR-hgZ7-sMvGg3LGwZ4L4rIQEidjG",
  ),
  Data(
    english: "Aluminium",
    turkish: "Aliminyum",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1fycLOL_C_AzK7bPYMQGUV_kqHqb3VFBv",
  ),
  Data(
    english: "Amateur",
    turkish: "Amatörce",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
  ),
  Data(
    english: "Amateur",
    turkish: "Acemi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
  ),
  Data(
    english: "Ambassador",
    turkish: "Büyükelçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1xozLYMpGOGv2Wa4I-EhOOg7nexTPKpIz",
  ),
  Data(
    english: "Ambitious",
    turkish: "Hırslı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1pHYdjJjNDpVMBtQ9sJLHPDyfV4xlVqvB",
  ),
  Data(
    english: "Amend",
    turkish: "Değiştirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1n16wyhtAGvuIZLmvBW8veIyIRRsO6Yak",
  ),
  Data(
    english: "Amendment",
    turkish: "Değişiklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1YOvEeZ0RGgrLjiflJdsOwHcZzj0VTPCK",
  ),
  Data(
    english: "Amid",
    turkish: "Ortasında",
    level: WordLevel.c1,
    type: WordType.preposition,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1QFssgpduG_0qwNL0ADASEH_tnx6jhs1y",
  ),
  Data(
    english: "Amusing",
    turkish: "Eğlendirici",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k7wrMxxH48E5m9j84nu5zs6vfmlJpPn_",
  ),
  Data(
    english: "Analogy",
    turkish: "Benzeşme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1uGfT5U92x4PfrglX0c00IUNweuhsphLX",
  ),
  Data(
    english: "Analyst",
    turkish: "Analist",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1_FQJZGmHmZHe-dAOcAp-SLHdDopX-Pd1",
  ),
  Data(
    english: "Ancestor",
    turkish: "Ata",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=12-FsuaH4vqncRlEsmuqahVfus1Em7t5f",
  ),
  Data(
    english: "Anchor",
    turkish: "Çapa",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1peTLfu16JGq3Y9hF9JhgKhI-8XkyJnCb",
  ),
  Data(
    english: "Angel",
    turkish: "Melek",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1o_On2Clok7-BDKVAcnxKVLnUr2MEUvwF",
  ),
  Data(
    english: "Animation",
    turkish: "Canlandırma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ZSdgENrjyH98VsjNoiX-OLWZ-KCIu7bE",
  ),
  Data(
    english: "Annually",
    turkish: "Her Sene",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1EKUV_be5EcpFhsyv9bwo0HxbOXwA0xxm",
  ),
  Data(
    english: "Anonymous",
    turkish: "Anonim",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Hljw6RhLCtz1S1nJ4QCB7Plh5caquDa-",
  ),
  Data(
    english: "Anticipate",
    turkish: "Ummak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ACDE4mpbzVOCmHCxLyrAu2zMwp0HrgFi",
  ),
  Data(
    english: "Anxiety",
    turkish: "Endişe",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1phLgaKB3dHEw8TDBPFH5fMqfM30S8Qoa",
  ),
  //! ingilizce level düzeyine cambridge'in kendi sitesinden bakmaya başladım
  Data(
    english: "Apology",
    turkish: "Özür",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HuJ9WcnSuebEabzWoAMSXoJ7nqthukSq",
  ),
  Data(
    english: "Apparatus",
    turkish: "Aygıt",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1aND-uPcx1raQoE8DJF0x-XpHLO-yp0ia",
  ),
  Data(
    english: "Apparel",
    turkish: "Kıyafet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hFVXuVJY7raQtV_SM54Eqsd8cUqqmMll",
  ),
  Data(
    english: "Appealing",
    turkish: "Çekici",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1n6HJ7SF7H1B-ziNWBLLxwcgFrGPiXu71",
  ),
  Data(
    english: "Appetite",
    turkish: "İştah",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1WO2bDldAFTgOn645WCvzSXbwvL4oiY-6",
  ),
  Data(
    english: "Applaud",
    turkish: "Alkışlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BBnzqOiUANESwnykryoi0VZCuTxyu8yn",
  ),
  Data(
    english: "Applicable",
    turkish: "Uygulanabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Spv5bi8hHPtwaq1zv-2C8kWWramiSEsQ",
  ),
  Data(
    english: "Applicant",
    turkish: "Başvuran",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=19hQ7Sbvbe11BxccGrVWb4ibrMLOYfhzc",
  ),
  Data(
    english: "Appoint",
    turkish: "Atamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1PCqWAzZt-KBgLL6my_hbVEv_vgDwOcIn",
  ),
  Data(
    english: "Appreciation",
    turkish: "Takdir",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1HhHktkmzHC9eRYAmQ6llSvODuXUJ84Nv",
  ),
  Data(
    english: "Appropriately",
    turkish: "Uygun Şekilde",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1-hp-FZ9bi30BVaN1hDZfCIf77CgrMkZ2",
  ),
  Data(
    english: "Arbitrary",
    turkish: "Keyfi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1hsCjBqiVMPBaZbxcINYc1REn0YTfqp5n",
  ),
  Data(
    english: "Architectural",
    turkish: "Mimari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13r9EUlQWtFkZ68B0GzEvixHAzI-klS5V",
  ),
  Data(
    english: "Archive",
    turkish: "Arşiv",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1dtZ6j4_TVLa_UNjbclXy-hql2YC0m7Ld",
  ),
  Data(
    english: "Arm",
    turkish: "Silahlandırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1cq0pDz5zr-oo5XEy5ViPvBlcg_CYkcVg",
  ),
  Data(
    english: "Array",
    turkish: "Dizi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VAvDm46kcoUjQ6eyEkQRxci6fg4q8J5R",
  ),
  Data(
    english: "Arrow",
    turkish: "Ok",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TEuieWo5C8zZRDGikpKQWH8wmsdiZw_g",
  ),
  Data(
    english: "Articulate",
    turkish: "Açıklamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ezW-Vw5jsfte3PBjfJgxGjx8_IhNP6fF",
  ),
  Data(
    english: "Artwork",
    turkish: "Sanat Eseri",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=14FlMtv-T7Tt0lsxAXy4qmZK6Df_NlUXo",
  ),
  Data(
    english: "Ash",
    turkish: "Kül",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Am7f_8h-f_3HpaUn0UrZ5T4RvKr0SQqo",
  ),
  Data(
    english: "Aspiration",
    turkish: "Özlem",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1XN5qB-SgN4kWtZpLpU-bQ4e9K0Iz62r-",
  ),
  Data(
    english: "Aspire",
    turkish: "Çok İstemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=15Q8yhkxuBSuKe95daTsVtINoKzWZhueQ",
  ),
  Data(
    english: "Assassination",
    turkish: "Suikast",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1J4IzZUSPdpXBCmjRGGbuMGr2Q6-G__cn",
  ),
  Data(
    english: "Assault",
    turkish: "Saldırı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
  ),
  Data(
    english: "Assault",
    turkish: "Saldırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
  ),
  Data(
    english: "Assemble",
    turkish: "Toplanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1TjFaY1LJPWbCTwh6zhwtPVdrixTGSRPJ",
  ),
  Data(
    english: "Assembly",
    turkish: "Toplantı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1C85ELyCBaAKGtDl6xfSJwGE98vhDH_f7",
  ),
  Data(
    english: "Assert",
    turkish: "Beyan Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1a47KOAJA70ew7Fv9HvQd7b7GX8AVjIdj",
  ),
  Data(
    english: "Assertion",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1k7KdPEJlEIVoTwSee2HApW-A4kURVPOb",
  ),
  Data(
    english: "Asset",
    turkish: "Servet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1MbrZgHLiEnHe0QP00zHljf4N-2IsPso2",
  ),
  Data(
    english: "Assign",
    turkish: "Görevlendirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1WgOKt7npiqZt8VS8UKYiNql2zTJGeO5Y",
  ),
  Data(
    english: "Assistance",
    turkish: "Yardım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zug94ZYx1Kc9CgNbGVO0Ijtf87M6yNPn",
  ),
  Data(
    english: "Assumption",
    turkish: "Varsayım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1VoWsL86obLAUZTkfKPFd56gPD56o95L1",
  ),
  Data(
    english: "Assurance",
    turkish: "Teminat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1w9A_ikkFG5NMlDvXGS8MoaZ8wiVICyWn",
  ),
  Data(
    english: "Assure",
    turkish: "Garanti Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zv_Ji4vSnXCerkuNOyYlft_fa2Keze1m",
  ),
  Data(
    english: "Astonishing",
    turkish: "Şaşırtıcı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1zaks5mQ1spJloAcZ0DFfEOe_qmF6_pyw",
  ),
  Data(
    english: "Asylum",
    turkish: "Akıl Hastanesi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1v34CSyrDtRE6ZMu1Ubw4NZmjjrjNGzzb",
  ),
  Data(
    english: "Athletic",
    turkish: "Atletik",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1aVtGw4z_UNmqYf3kCzkEa054DEpzJWxO",
  ),
  Data(
    english: "Atrocity",
    turkish: "Vahşet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13Cp8MJxNTysi3_pN6iNXPvWMoSsjWdVg",
  ),
  Data(
    english: "Attachment",
    turkish: "Eklenti",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1Fo5mcb-kYxAeP4gk6WIRVn4JutfU0fzT",
  ),
  Data(
    english: "Attain",
    turkish: "Erişmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1BaHO1wIrj6WR2Hyws1rdpYyI5g9QO46K",
  ),
  Data(
    english: "Attendance",
    turkish: "Katılım",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1qTcCy0KXcnuCt3KpS3J2UMc7wSVBGj4W",
  ),
  Data(
    english: "Attribute",
    turkish: "Özellik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1W7Di_rIEnIMEPByA9WdfUr3x9tahcxEU",
  ),
  Data(
    english: "Auction",
    turkish: "Açık Arttırma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=18rpDDws732iFAqx29co_nTBqjBFS-nNF",
  ),
  Data(
    english: "Audit",
    turkish: "Denetçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=13svznKutHbDQNvAuwKpg2JYY7ARB0zMo",
  ),
  Data(
    english: "Authentic",
    turkish: "Orijinal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1ENFuuwaMYb5Nx-V-MF1ZEKuLb9tqaKMa",
  ),
  Data(
    english: "Authorize",
    turkish: "Yetki Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1wR3ouN0bZd3ZRSTJnqoOaaPgTsNAi04i",
  ),
  Data(
    english: "Autonomy",
    turkish: "Özerklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1enIXA1voM-rJt75LGv57_outmpZBkWOr",
  ),
  Data(
    english: "Autumn",
    turkish: "Sonbahar",
    level: WordLevel.a2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mIgLfPpRD3BHuaovORHpgIpD_0YrDe6w",
  ),
  Data(
    english: "Availability",
    turkish: "Mevcut Olma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1A2ZVhBYPJmvGSSGkjrIc7ZAm0gcxFJfT",
  ),
  Data(
    english: "Await",
    turkish: "Beklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AN5yPFczD-Wo6_WtuSWi7SbQ6DIE27pe",
  ),
  Data(
    english: "Awareness",
    turkish: "Farkındalık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1gbf38_w59c-cIRaIhc-1atVl06T4fPLg",
  ),
  Data(
    english: "Awkward",
    turkish: "Beceriksiz",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1akY2mbfG57S-0aeNklfH-GE5vddQIZ9z",
  ),
  Data(
    english: "Backing",
    turkish: "Destekleme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1T8-Pi3T88_cNE-SrnODNwi-1_6YI3I5_",
  ),
  Data(
    english: "Backup",
    turkish: "Destek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1mXH78sHGyQE_cwJuwKH2MOCR7CwA4sjx",
  ),
  Data(
    english: "Badge",
    turkish: "Rozet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1kvvk41tQO57XZlSU-NCXaAR7XwgHvpps",
  ),
  Data(
    english: "Bail",
    turkish: "Kefalet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=1AN_mXG7e-2DU280dJ8yGFyT9XS5ll4K3",
  ),
  Data(
    english: "Balanced",
    turkish: "Dengeli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "https://drive.google.com/uc?export=download&id=142dSdyRz19B5GkKK0QiEkhiRXAmRes25",
  ),
  Data(
      english: "Ballot",
      turkish: "Oylama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1YDsXUR62WUIJcjT_NbjxOOidGRqcJgRp"),
  Data(
      english: "Bankruptcy",
      turkish: "İflas",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ZlzSqUKr69hEvlciDajq4BCFZg6Ahyd2"),
  Data(
      english: "Banner",
      turkish: "Sancak",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1vEK42YgDlG0sON0s8Mw-4xaPUG1wNj-N"),
  Data(
      english: "Bare",
      turkish: "Çorak",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1tqeLYnjaqXyP_D0O2kVumop0ZW2QYsbY"),
  Data(
      english: "Barely",
      turkish: "Ancak",
      level: WordLevel.b2,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1PdIm1DWGwn58yJW26Pd-Vh-heO3rE8EZ"),
  Data(
      english: "Bargain",
      turkish: "Pazarlık",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1vE3nzAOGyj3MQv9zXAw9xg05aAlT1rAz"),
  Data(
      english: "Barrel",
      turkish: "Namlu",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1u-GnhRJoONz_ylv5KzuFUXI5J59zSIYn"),
  Data(
      english: "Basement",
      turkish: "Bodrum",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1fLPg5mKqVFUFI_Fpfl70TcfSxb5Ij_Lv"),
  Data(
      english: "Basket",
      turkish: "Sepet",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1EpVDX70QTmBfucAKk-fwSMlYjfD95xCb"),
  Data(
      english: "Bat",
      turkish: "Yarasa",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1btyry_kKS0nrJe5YGu856aYzJgOXW9JR"),
  Data(
      english: "Battlefield",
      turkish: "Savaş Alanı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1pyqlIlbrUNxO5XIWlS1VugI8gHaFvo6X"),
  Data(
      english: "Bay",
      turkish: "Körfez",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1yEME9Rs_M-N3nGiyVSuFS60dlvx94TWh"),
  Data(
      english: "Beam",
      turkish: "Işın",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1LDklALd36Ag8k6bOTVEvtww5dGetsmSx"),
  Data(
      english: "Beast",
      turkish: "Hınzır",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1O0mbOrOFGDmwmMNx962CXL7rBmpM8blK"),
  Data(
      english: "Behalf",
      turkish: "Temsilen",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1BIrdCmTau5MM7EKHnJdtz5wVjfhvyxU0"),
  Data(
      english: "Behavioral",
      turkish: "Davranışsal",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1eVah5H0KnXnXExscxXzOKv2f5s2PGqjj"),
  Data(
      english: "Beloved",
      turkish: "Sevgili",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1PmnPpKagQIxy70yuLji-GYHV9hEZ1jP4"),
  Data(
      english: "Bench",
      turkish: "Bank",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Qj8zQM_I8iSwjmoKIPRgXUHbd1blvr8y"),
  Data(
      english: "Benchmark",
      turkish: "Kalite Seviyesi",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1J_2BkCzE8sGRNvwVkiPj92mfbNSjmF-u"),
  Data(
      english: "Beneath",
      turkish: "Altında",
      level: WordLevel.b1,
      type: WordType.preposition,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ron8lMD18loLTPt57hp-YUl2zABmVoZE"),
  Data(
      english: "Beneficial",
      turkish: "Faydalı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=17GynwUAA0hnSVvMPlFyJFl-G8HB2wY0d"),
  Data(
      english: "Beneficiary",
      turkish: "Yardıma Muhtaç",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ue7dmF5c37Pm-oi6ls104i5GIo0nqPHX"),
  Data(
      english: "Beside",
      turkish: "Yanında",
      level: WordLevel.a2,
      type: WordType.preposition,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1xaPuqb7FudoToTcTG3VfZASfA5IwET0e"),
  Data(
      english: "Besides",
      turkish: "Ayrıca",
      level: WordLevel.b1,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1bKXcqSi1vp7xTaDeS45AIZKnNXUbbe5F"),
  Data(
      english: "Betray",
      turkish: "İhanet Etmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Kzfs5KCrLKXv4FuZvSP52zprA2hKry_8"),
  Data(
      english: "Beverage",
      turkish: "İçecek",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1lzSEhGP0OGJ-P5PH3sFxcw_tMQQL1WmQ"),
  Data(
      english: "Bias",
      turkish: "Önyargı",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1lwIyX8hpcRubZnL1rctA4GWyvfi_UJzI"),
  Data(
      english: "Bid",
      turkish: "Girişim",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1gkOrmbF_VvtJBFu3N_uHvHyfFuT3CRjc"),
  Data(
      english: "Bind",
      turkish: "Bağlamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=173GFX-VU7wrEKTfvwqQA7huiATdds8vj"),
  Data(
      english: "Biological",
      turkish: "Biyolojik",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1wAXjQJmoLLMNYBebqToIgLXwoO0cVWIQ"),
  Data(
      english: "Bishop",
      turkish: "Piskopos",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=13SlPmJaiAKgwDAr5ZN4vfr37FObJVZgD"),
  Data(
      english: "Bizarre",
      turkish: "Acayip",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1HTBL2gqYybW0Y-6JvI5Q_L4Tjt8lPVLQ"),
  Data(
      english: "Blade",
      turkish: "Bıçak Ağzı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1d0qiUlpm-HP59HEOexQ5R2ZaRcLQzQ7x"),
  Data(
      english: "Blanket",
      turkish: "Battaniye",
      level: WordLevel.a2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1GODnPAtsu3Hwfc0fH8bCR-Uobqi06z4_"),
  Data(
      english: "Blast",
      turkish: "Büyük Patlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1iFYYcm4vOknprC3fQE131-VLdso5f2ha"),
  Data(
      english: "Bleed",
      turkish: "Kanamak",
      level: WordLevel.b1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1YTY7uve0-cp6QBbFJAyp3rXKkAvlN34m"),
  Data(
      english: "Blend",
      turkish: "Karıştırmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv"),
  Data(
      english: "Blend",
      turkish: "Karışım",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv"),
  Data(
      english: "Bless",
      turkish: "Kutsamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1MkufwyLGV5VsnbGbEXLhaVvipAD015Rh"),
  Data(
      english: "Blessing",
      turkish: "Nimet",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1hCvEMqn5jP1YOYjGloh-YW0ilf3V_YDD"),
  Data(
      english: "Blow",
      turkish: "Üflemek",
      level: WordLevel.b1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1l0aH9e-Y9uKXVpZCxxIiWjUNh1A8UdRV"),
  Data(
      english: "Boast",
      turkish: "Övünme",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1HQ6AoQ01KhiHtlmVVF6veiDDoOldx22v"),
  Data(
      english: "Bold",
      turkish: "Cesur",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1uYbm9tntPs_5bUlSplx9brJhD1kwIk1P"),
  Data(
      english: "Booking",
      turkish: "Rezervasyon",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ZLoEgrEfWZPsPfpjJYh63QemGkYpne2T"),
  Data(
      english: "Boom",
      turkish: "Patlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1BgeD8Iqa54x2sbM8JUpidZhNpVhhJqjp"),
  Data(
      english: "Boost",
      turkish: "Desteklemek",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7"),
  Data(
      english: "Boost",
      turkish: "Geliştirmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7"),
  Data(
      english: "Bounce",
      turkish: "Zıplamak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1fTOhd6bAqsIg4XIlTxCWcs1rq33uvtI0"),
  Data(
      english: "Bound",
      turkish: "Sorumlu",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Jq6jD5WwrLp5Ia_aVs2L0Vb-a8NY785h"),
  Data(
      english: "Boundary",
      turkish: "Sınır",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1JCX2lhRZ6c9SPr4pP9exH20PCmz_MWxu"),
  Data(
      english: "Bow",
      turkish: "Selamlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1yKQ3KKeppIJ7LX8nkyMK8DmXbpbd824T"),
  Data(
      english: "Breach",
      turkish: "İhlal",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc"),
  Data(
      english: "Breach",
      turkish: "İhlal Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc"),
  Data(
      english: "Breakdown",
      turkish: "Zihinsel Çöküntü",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=13T3nVaPk39JNeRcvPEYftKc0xPYFnMVD"),
  Data(
      english: "Breakthrough",
      turkish: "Önemli Buluş",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1yvM-81xf2hBrH4B17dXdAIL46ovYv1Xa"),
  Data(
      english: "Breed",
      turkish: "Yavrulamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4"),
  Data(
      english: "Breed",
      turkish: "Hayvan Cinsi",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4"),
  Data(
      english: "Brick",
      turkish: "Tuğla",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ycw3b3MBcQlQ3NvbYkIyfnH_P_CVyBp4"),
  Data(
      english: "Briefly",
      turkish: "Kısaca",
      level: WordLevel.b1,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ikXHbX1SUmQnNFqr821vH_sGqwK6YNLr"),
  Data(
      english: "Broadband",
      turkish: "Geniş Bant",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1UIk5OwyIgtXZIbooC7sm5pZzrmz3u3xs"),
  Data(
      english: "Broadcaster",
      turkish: "Yayıncı",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=19unVvGq4AgcBxrRfm6Dn_jQ1cxZ4G-Yx"),
  Data(
      english: "Broadly",
      turkish: "Genel Anlamda",
      level: WordLevel.b2,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1xIhBnQw9Uz8RurMgGXAj8K8Kjl7Xj9QA"),
  Data(
      english: "Browser",
      turkish: "Tarayıcı",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1IDSqeHaCS0Iiw1q6pJ4gNIDVle6kh8dj"),
  Data(
      english: "Brutal",
      turkish: "Vahşi",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=13D_5oiScD4K7RcU9DWuTNeGj6RZUH9xF"),
  Data(
      english: "Buck",
      turkish: "Dolar",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1KFUNLfJKmIRZMZQ4ECk94FfZoHJTVtU7"),
  Data(
      english: "Buddy",
      turkish: "Ahbap",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1sgEfnpoxSLFdWabuoMT1gXKCintZDBuK"),
  Data(
      english: "Buffer",
      turkish: "Tampon",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1es76q0tNqKrobQS8ecUwrLFTc0t6hi1b"),
  Data(
      english: "Bug",
      turkish: "Hata",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14ppKaOzDRJY6QYLmD6NwddzkbnlIpvEA"),
  Data(
      english: "Bulk",
      turkish: "Çok Miktarda",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1bQwd7s1Hj9mPaxnodLT4QhwYaLy7XFbI"),
  Data(
      english: "Burden",
      turkish: "Sorumluluk",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_sTORdaVQZqw6lW48v2XsEV8bRX2Mc78"),
  Data(
      english: "Bureaucracy",
      turkish: "Bürokrasi",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1w8txOnMGcBgKic4SYhiKOCsGEuJkbNK_"),
  Data(
      english: "Burial",
      turkish: "Defin",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1vwjx3fVB9hWpdjeU2PJSxvRdxdg0kjFT"),
  Data(
      english: "Burst",
      turkish: "İnfilak Etmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ToTR1IcAfFSTFdpxr3nJL8jsi6D6baJo"),
  Data(
      english: "Cabinet",
      turkish: "Kabine",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1CpWGPwOwRULUOLm6ezwjmV4OWbh5bkva"),
  Data(
      english: "Calculation",
      turkish: "Hesaplama",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14bsKLxrxSkKNQRXk_4LxoWFgtISzlyun"),
  Data(
      english: "Candle",
      turkish: "Mum",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=106ZzBefaicJ44yqjxqBKjYHcB-MtKlg6"),
  Data(
      english: "Canvas",
      turkish: "Tuval",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1MBozCbLV0r2pnH0BEsLIFqPYwAC2vNm7"),
  Data(
      english: "Capability",
      turkish: "Kabiliyet",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1P3bZd0a7mg4Ays4iThpfNDAd61D53lLb"),
  Data(
      english: "Carriage",
      turkish: "Vagon",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=12_AJ4ZYDSguG67TuzkqSlonv6heNay74"),

  Data(
      english: "Carve",
      turkish: "Yontmak",
      level: WordLevel.c2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1GueweJ0OQSQKRLGMflT2bLCktcfYMTjV"),
  Data(
      english: "Casino",
      turkish: "Kumarhane",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TALxbkbBqZz-PcsL3DOgMH7IU3md5V_1"),
  Data(
      english: "Castle",
      turkish: "Kale",
      level: WordLevel.a2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1i9oVMHdPxXQWS8vmlJ4LcB-vZ0l6Kj6W"),
  Data(
      english: "Casual",
      turkish: "Tesadüfi",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ukLwk-tHprUsDQkKzcwq-4KAD3oFxV-I"),
  Data(
      english: "Casualty",
      turkish: "Zayiat",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1deznVgkqf1CHzDnVpRMLcKGs8XE1Y2mB"),
  Data(
      english: "Cater",
      turkish: "Yemek Servisi Yapmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_mpsIAe_MvBdIrsPSFdtiKtX9AlstqLv"),
  Data(
      english: "Cattle",
      turkish: "Sığır",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1upY1nNg15YNbeOeI4_oKlsWKxV6iSavO"),
  Data(
      english: "Caution",
      turkish: "Uyarı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1QnxjgVpmyulLN_forHNhP3yDENCx4w4u"),
  Data(
      english: "Cautious",
      turkish: "Dikkatli",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TiX8xba2sfPMZypjJHqvlhz2mXrOoNAX"),
  Data(
      english: "Cave",
      turkish: "Mağara",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1W2-P4ijx7RKIgmr7d9il7xJJZXh1unAf"),
  Data(
      english: "Cease",
      turkish: "Durdurmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14ssnSeHVXu6i2N_HafSFHoXSoAWOZuY0"),
  Data(
      english: "Cemetery",
      turkish: "Mezarlık",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=16TCbCkr6Gv_sKgMBx3ql4Og6q93ZRJYx"),
  Data(
      english: "Certainty",
      turkish: "Kesinlik",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1DqozJ3_ahkuCcwzOzO-96pLYFlIEISfX"),
  Data(
      english: "Certificate",
      turkish: "Sertifika",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ykjyNWbR78lTgsCfVQWM8NLBTlBeXtb6"),
  Data(
      english: "Challenging",
      turkish: "Zorlayan",
      level: WordLevel.b1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1hdHidp6l3aLrTPOubRsdzVPKTRs6z18l"),
  Data(
      english: "Chamber",
      turkish: "Oda",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1T6WaN-G_tNYTyQFGhWsYgr9nW4jrGnNM"),
  Data(
      english: "Championship",
      turkish: "Şampiyonluk",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zardrzj5CY6kNtpp4sR1_sWXOF4Xu7c0"),
  Data(
      english: "Chaos",
      turkish: "Kaos",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=18TZV1n_JvJfddNKvMYQj78dpUPR_8oy2"),
  Data(
      english: "Characterize",
      turkish: "Nitelendirmek",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14RkBJC_XNw5veno832jXcRb4C2FEcFes"),
  Data(
      english: "Charm",
      turkish: "Sevimlilik",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1N6A_GE4h1Qj9J8vHR0kIxlGcr5cfeelU"),
  Data(
      english: "Charming",
      turkish: "Cazibeli",
      level: WordLevel.b1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=17rYaeM1q9cfS1_pmy4t627dYl8lRPg-N"),
  Data(
      english: "Charter",
      turkish: "Tüzük",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1PKs64frj_R_Nov3fDCagiXAOCcMti8YT"),
  Data(
      english: "Chase",
      turkish: "Kovalamak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1H2SxxmJ3_Qe1AKYXiKJnj33-gpLHqPaB"),
  Data(
      english: "Chase",
      turkish: "Takip",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1H2SxxmJ3_Qe1AKYXiKJnj33-gpLHqPaB"),
  Data(
      english: "Cheek",
      turkish: "Yanak",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_EEQdDOqQF5Dx6wQdsbGZX2orOTzfqZM"),
  Data(
      english: "Cheer",
      turkish: "Alkışlamak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1qoxfXDGuNl6gXTrBp38NnZGYsU7fr24o"),
  Data(
      english: "Choir",
      turkish: "Koro",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1x-kbgDWyCFzGv2P3REeUUqN08hC_3iCP"),
  Data(
      english: "Chop",
      turkish: "Doğramak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14-5GkstfmVlJ6-_FWI2QlFFZMw8TU2qW"),
  Data(
      english: "Chronic",
      turkish: "Kronik",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1jxIef5Qqt-h_isy2-0-eQjhnBa22VD1G"),
  Data(
      english: "Chunk",
      turkish: "Büyük Parça",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_lrEwPB8UomuTC9w2_nPAq332PK_dZeG"),
  Data(
      english: "Circuit",
      turkish: "Devre",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1SDUKEETat8T6uC9Wzam7Rddyvd90r-BR"),
  Data(
      english: "Circulate",
      turkish: "Duyurmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1aY9V5IIjOxON84UNB0Lkc0VFIByZmB4A"),
  Data(
      english: "Circulation",
      turkish: "Dolaşım",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1inU8YD8cR1_bj0WaCWcBWqqNliVvfNGN"),
  Data(
      english: "Citizenship",
      turkish: "Vatandaşlık",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1upWlsotAmMJZlyGmDZA98LLLuZ2cPPnT"),
  Data(
      english: "Civic",
      turkish: "Kentsel",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1g4Yz7wI1a78eXMtkQ__OlUFQt9QrQR9i"),
  Data(
      english: "Civilian",
      turkish: "Sivil",
      level: WordLevel.c2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1b_krKp9zx_EV4duXyjFcuG8BCbLjk6XX"),
  Data(
      english: "Civilization",
      turkish: "Medeniyet",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TaDYiHZJpqGh9p1oTAT-Cz8OUC6Mj0f-"),
  Data(
      english: "Clarify",
      turkish: "Açıklamak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1__fkVwqNbdwoc-XTuQdfgPCCnla1PWag"),
  Data(
      english: "Clarity",
      turkish: "Açıklık",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1OfDKuJP5ehHqI8VeUsvvnNuYxdSyVMCm"),
  Data(
      english: "Clash",
      turkish: "Çarpışmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1mAecLRHqsf9VBq5VPKk1Q91_2xCRXuuV"),
  Data(
      english: "Classification",
      turkish: "Sınıflandırma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1f5I5nB3lvONU_pT5W6Z_QgoMVr-Yux-2"),
  Data(
      english: "Classify",
      turkish: "Sınıflandırmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=11GPg3TVwSftJQ_tZrk7i2LL5RRvtT1Gm"),
  Data(
      english: "Cliff",
      turkish: "Yamaç",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14Erwyxld537br9Ih3HZnF5eEz7oo4zbx"),
  Data(
      english: "Cling",
      turkish: "Tutunmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1QlVDVRfQmI09e1RPRH-HXq-gAGksECVZ"),
  Data(
      english: "Clinic",
      turkish: "Klinik",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1lC2K1pCdPi_6cFVJkz4xWRwdrglYtgAc"),
  Data(
      english: "Clip",
      turkish: "Toka",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=10xFCQPNDvOEPeVSC7NKH0igVk-ZiH-Rz"),

  Data(
      english: "Closure",
      turkish: "Kapanma",
      level: WordLevel.c2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1lDBqugYtvwIh4_YD_cPA_lqT0wvId63p"),
  Data(
      english: "Cluster",
      turkish: "Küme",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1NDH96T9DugwTsk8cMPHUAlSzOxy6dEsl"),
  Data(
      english: "Coalition",
      turkish: "Koalisyon",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1W9ibqdNUHlB79JWXXUgJ49RpheZrl0Ej"),
  Data(
      english: "Coastal",
      turkish: "Kıyı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1hO9oFgO1qwlzxYm5nnk_gA48w3QTf2m8"),
  Data(
      english: "Cognitive",
      turkish: "Anlama",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1p-jOoA9lhuWJwjuUHkHLdqniG-9gqOwl"),
  Data(
      english: "Coincide",
      turkish: "Denk Gelmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1xzluMKAWxgCbDD5dlDfZWerNC3lu46rg"),
  Data(
      english: "Coincidence",
      turkish: "Tesadüf",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TuddkBhATi5wjb6ibLwY8gNWDEIQ7LGK"),
  Data(
      english: "collaborate",
      turkish: "İşbirliği Yapmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=10KaQuCJVFC-Iy9IG71yc8tCtVw_PxL_Z"),
  Data(
      english: "Collaboration",
      turkish: "İşbirliği",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zZYQwtxTwKoS9AEvt9_F9AjOJH_OQNwm"),
  Data(
      english: "Collective",
      turkish: "Toplu",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1N-X1-AHVAOjx9JgFLkgZSdsu1ac4NGrj"),
  Data(
      english: "Collector",
      turkish: "Toplayıcı",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1XMBdmpZC8aZucynYdfgGKql9q4Jn1uOB"),
  Data(
      english: "Collision",
      turkish: "Çarpışma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_9_PC8iNnKrZuJt4-xgh9Nzn-XFa5w8T"),
  Data(
      english: "Colonial",
      turkish: "Sömürgeci",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1oM4otn5-piG3v0xVfez9U4Y1kG0FUz0z"),
  Data(
      english: "Colony",
      turkish: "Sömürge",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1MUK4KgMCH-Md9DEisFYuHCUKiCLDi3He"),
  Data(
      english: "Colorful",
      turkish: "Renkli",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Z0mDBz8nQezBGF4g8r1mRi6pM9N1SNV4"),
  Data(
      english: "Columnist",
      turkish: "Köşe Yazarı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1LO_d20DcyIMBaOdI4Uda655sTorxbRsm"),
  Data(
      english: "Combat",
      turkish: "Savaş",
      level: WordLevel.c2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14fJ2qrRWNH7K0i3SLNX_OIQvQ29VQHQ5"),
  Data(
      english: "Combat",
      turkish: "Savaşmak",
      level: WordLevel.c2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14fJ2qrRWNH7K0i3SLNX_OIQvQ29VQHQ5"),
  Data(
      english: "Comic",
      turkish: "Komik",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TlBQ4_vgoohO492KbtwPxDZRpAvpwQX5"),
  Data(
      english: "Commander",
      turkish: "Komutan",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=12ZI6W0NTJkrUaK22M98YCrFOUjDbB6mV"),
  Data(
      english: "Commence",
      turkish: "Başlamak",
      level: WordLevel.c2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=12aHLsSyG4vNVgZBt_-x5CPoz0ryFjz2U"),
  Data(
      english: "Commentary",
      turkish: "Yorum",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1IbL-hjEWH47BmqrGqoJJBVea1BzzuDDm"),
  Data(
      english: "Commentator",
      turkish: "Yorumcu",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1z0HwW8UgLPp3cHOkGTrb8cQtLj2MmHDt"),
  Data(
      english: "Commerce",
      turkish: "Ticaret",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ZNgFDx6LIo942FrvSlGAGq3DNMdmTu_B"),
  Data(
      english: "Commissioner",
      turkish: "Komisyon Üyesi",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1S4WLSFCN2IweTq-HoXjut_I94okqaeWK"),
  Data(
      english: "Commodity",
      turkish: "Ürün",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1iv6Umo7ijL_Cj9bjzB0nmGcuiOyAZRzi"),
  Data(
      english: "Companion",
      turkish: "Ahbap",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ax1FH2Xg0oTN0YmScGAfk8p2ftxntFhp"),
  Data(
      english: "Comparable",
      turkish: "Kıyaslanabilir",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ZaOzpWoEKFGf_T_3Zajs8CQEohcKm3kf"),
  Data(
      english: "Comparative",
      turkish: "Karşılaştırmalı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1BA1K_YSnkdxR3LORap9z7rUfu503cNI7"),
  Data(
      english: "Compassion",
      turkish: "Merhamet",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1tGc6vQI3j0yuVX4qS-Ic6ZNH8nmQjtVU"),
  Data(
      english: "Compel",
      turkish: "Zorlamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1OzUvMsuf1I5zmTGHy1HDm7VIJVGZoq0e"),
  Data(
      english: "Compelling",
      turkish: "Zorlayıcı",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1HhhjR6CMruVInORq_8h7lPRCaWg4cYU8"),
  Data(
      english: "Compensate",
      turkish: "Telafi Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1kbxQDaRDxlmjLWlSH8ZWXw7O6xGaNga2"),
  Data(
      english: "Compensation",
      turkish: "Tazminat",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=17DBuLievLiAdO9EwL46P9ziHhBGQqSJa"),
  Data(
      english: "Competence",
      turkish: "Ustalık",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Gmn-5mgzP1KFId6oOW6L3E6ikNukuIhH"),
  Data(
      english: "Competent",
      turkish: "Usta",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1FvnCas1aXygW06rCco85zVZgJdEoKFKj"),
  Data(
      english: "Compile",
      turkish: "Derlemek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1YnpmWaxLY3ixiqbbwWef61YjK4h0Cpy3"),
  Data(
      english: "Complement",
      turkish: "Tamamlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1QYiEYwKTZKB9Ic_ANFNbmGhi_eC-TStE"),
  Data(
      english: "Completion",
      turkish: "Bitme",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zrpi8E3dMv0G_i6t02BB-BMRSpza3unn"),
  Data(
      english: "Complexity",
      turkish: "Karmaşıklık",
      level: WordLevel.c2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1vYfaoH7BTjNKo9G0J--wuX_LccXoK7QN"),
  Data(
      english: "Compliance",
      turkish: "Rıza",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1p5Em7uxgBlfMbeWRsiKjKvMw_5B9BwLU"),
  Data(
      english: "Complication",
      turkish: "Zorluk",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1YD1YErX61SIU1_vAmWP0RrCZU2SQGeIJ"),
  Data(
      english: "Comply",
      turkish: "Uymak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1-eFkGrRy5mhxkuxKdgqHWMT8ceb8OjyM"),
  Data(
      english: "Compose",
      turkish: "Oluşturmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zB72GGBUr4Ne0fdNPWDUHa5XLCd6IWjt"),
  Data(
      english: "Composer",
      turkish: "Besteci",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1YkBHe-olIOoVVSHVvzp6Tq3LVN3r98jW"),
  Data(
      english: "Composition",
      turkish: "Beste",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1CFK0O515kFyTnZT-qAcuiuy7ojB5vQ5m"),
  Data(
      english: "Compound",
      turkish: "Bileşim",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1FRce3ycAEqzFYMQvwuksLucjc_MCAr8e"),
  Data(
      english: "Comprehensive",
      turkish: "Kapsamlı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=19Fm8GQDfc6rpJB283-vkjlzpWF5mClcT"),

  Data(
      english: "Comprise",
      turkish: "Meydana Gelmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ecF_i1s2aukhufjeL4XY9oPemKDGtA7j"),
  Data(
      english: "Compromise",
      turkish: "Uzlaşma",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1tlFiJQHxT2JHX8Xozxz-x9SFmiF0wU0C"),
  Data(
      english: "Compulsory",
      turkish: "Zorunlu",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1PaRTrv7gMjxQdRDXmCCX_sW6Th5jOMEX"),
  Data(
      english: "Compute",
      turkish: "Hesaplamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1KI4DZM4pHVmOtnWbu0J_DjGNK0J7IQJH"),
  Data(
      english: "Conceal",
      turkish: "Gizlemek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ye68Ljer6cRiCo_7XWxSo4iT2ypc_BKB"),
  Data(
      english: "Concede",
      turkish: "Kabul Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1uhyMtyxxq0aB2Asp9EmJnmkNA7SDcx1y"),
  Data(
      english: "Conceive",
      turkish: "Gebe Kalmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14fwxudDKq9ZjsgYdPlW4Yyp0Umtnkc9f"),
  Data(
      english: "Conception",
      turkish: "Düşünce",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1i7MlABYnc76HmyDZgeGru_jMsCte-sEv"),
  Data(
      english: "Concession",
      turkish: "Taviz",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1esmFppZ0NTgU9sy2kMB0Y2t3dB-ffji2"),
  Data(
      english: "Concrete",
      turkish: "Beton",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1QyVEK7qHFzQFxFZUuFrZB9LoxLmzk7-k"),
  Data(
      english: "Concrete",
      turkish: "Somut",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1QyVEK7qHFzQFxFZUuFrZB9LoxLmzk7-k"),
  Data(
      english: "Condemn",
      turkish: "Kınamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1GqNvrucAcLj3X3U6h8d9Sq2c_IEx3OYw"),
  Data(
      english: "Confer",
      turkish: "Görüşmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1lSlYytOsVTOeU98y5t2HCuHy35CDO2Yb"),
  Data(
      english: "Confess",
      turkish: "İtiraf Etmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1PP8hDLZa4XpkxOC6Csg4D39hPDcU4f9h"),
  Data(
      english: "Confession",
      turkish: "İtiraf",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1FyxPyNWOJ6a733fLTqINd0FqBxJZqXje"),
  Data(
      english: "Configuration",
      turkish: "Yapılandırma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1TZXveBDo--OH1v5tRYlICU5YoTNKAL4C"),
  Data(
      english: "Confine",
      turkish: "Sınırlamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ha3k5tDUx9bPQOjpYxs8vVAIYFIXe24G"),
  Data(
      english: "Confirmation",
      turkish: "Doğrulama",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1d_2_fmtHAfZZeZsBJtWazMi35_7qUM5m"),
  Data(
      english: "Confront",
      turkish: "Karşılaşmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1RqpJrAw52_dBvc7wffNjjpaZVR7cTPtx"),
  Data(
      english: "Confrontation",
      turkish: "Tartışma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zrPTIy52lv2YgEdSUfC-JIgaCUA0MpL8"),
  Data(
      english: "Confusion",
      turkish: "Karışıklık",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=15yZxLlBXcYuD-P3EK2MZRnj4kH7JOj3c"),
  Data(
      english: "Congratulate",
      turkish: "Tebrik Etmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1_pvqN1-8b25aJaTe0Bf0G4TC970TEwVI"),
  Data(
      english: "Congregation",
      turkish: "Cemaat",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Ymnpr6Cw2ZTLSWldulxtblNTHxeYRbdS"),
  Data(
      english: "Conquer",
      turkish: "Fethetmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1c1mw9Bxq9MBPxQHAUY_0rVDm-sJUrbYo"),
  Data(
      english: "Conscience",
      turkish: "Vicdan",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zFseFrAWuj91dqv4oXO_DQRV8gLG5trA"),
  Data(
      english: "Consciousness",
      turkish: "Bilinç",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=14q1h9vElWgen-BF6q0KlYoi2DMMvmX5b"),
  Data(
      english: "Consecutive",
      turkish: "Ardışık",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1y2jQIyh0Yk_EBgAiyp22gVTwhNl16eJg"),
  Data(
      english: "Consensus",
      turkish: "Uzlaşma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1kh1lj8s93uEGybyGaTB0RB5fZdtNEp7R"),
  Data(
      english: "Consent",
      turkish: "Razı Olmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1HAO6BozTVCZeZQ4_E8Fx9FyUTdmJOeqz"),
  Data(
      english: "Consequently",
      turkish: "Bu Nedenle",
      level: WordLevel.b2,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Fm-qmphQIffX42dS8beY02HzGP80VdCP"),
  Data(
      english: "Conservation",
      turkish: "Koruma",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1BQSMXeoxtAO8y-owUqqE1QpDuL4WOOIz"),
  Data(
      english: "Conserve",
      turkish: "Korumak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=12CIHnbEN6wPE_6tjKMwawpRWvOduIBG1"),
  Data(
      english: "Considerable",
      turkish: "Önemli",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1hfb_UMgHalUixqXlM8ZqAwFGjwiClA-Z"),
  Data(
      english: "Considerably",
      turkish: "Epeyce",
      level: WordLevel.b2,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1az_TxxEGKYLddxYHBpnfNsK2frpZZT8b"),
  Data(
      english: "Consistency",
      turkish: "Tutarlılık",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1VJ7kTE_BTQXBa2hY6gerZg_hcBiK1TBU"),
  Data(
      english: "Consistently",
      turkish: "Sürekli Olarak",
      level: WordLevel.c2,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1FOHe7ryu8qgbvfgFO5w3WskhDc5j7XYY"),
  Data(
      english: "Consolidate",
      turkish: "Takviye Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1zevQBl5eqoF9ht9Gk6GIS8iewL_w4C-b"),
  Data(
      english: "Conspiracy",
      turkish: "Komplo",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1rTL9M1xOcenAY7nWrcvwJd6TWtAOa6LV"),
  Data(
      english: "Constitute",
      turkish: "Oluşturmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1-rKIotNRiUA_cgrkLMBnqnZnndpU11q9"),
  Data(
      english: "Constitution",
      turkish: "Anayasa",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=176AGMCvghPUPM7YNkjHT3oS9XgAkZKHN"),
  Data(
      english: "Constitutional",
      turkish: "Anayasal",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1-eP7Fm7lvXRDpTPX64MzBN2hym2QQDN6"),
  Data(
      english: "Constraint",
      turkish: "Kısıtlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=133PnzCu5E8o1dnnD_ejAn_IxRsh0kPPA"),
  Data(
      english: "Consult",
      turkish: "Danışmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=11qibIGE5TxoovfkwblKPxTIEPKcem2jV"),
  Data(
      english: "Consultant",
      turkish: "Danışman",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ekH1i4u0NiMFtt97oFrPeKX96PHDQPlN"),
  Data(
      english: "Consultation",
      turkish: "Danışma",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=16LSztL75AY63_hKVvh2d4SJCgHhB-Wqi"),
  Data(
      english: "Consumption",
      turkish: "Tüketim",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=13a_tW9wBRWEKkJ7A-elZ6P6QGxX6gOoy"),
  Data(
      english: "Contemplate",
      turkish: "Düşünmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1z1miwThO4FpcWgjy2imhnPXOJBnOGn9I"),
  Data(
      english: "Contempt",
      turkish: "Küçümseme",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1q4eewQjezcszZOAkj2TvMxVOFs4ZqIe2"),
  Data(
      english: "Contend",
      turkish: "İddia Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1o6d1sWicMEqla3qxyaflwbODPxIbI5AQ"),
  Data(
      english: "Contender",
      turkish: "Yarışmacı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1f9SRK6IQ08zPDkAz4R0VHzb-wnwTc9Rd"),
  Data(
      english: "Content",
      turkish: "İçerik",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1xQxTid5Kyo2OknAFHZTaRbPw9sZ27AKb"),
  Data(
      english: "Contention",
      turkish: "Çekişme",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1MSp9F-wt7M45Qi0C82EttSWcUhi8zcCY"),
  Data(
      english: "Continually",
      turkish: "Sürekli Olarak",
      level: WordLevel.c1,
      type: WordType.adverb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1G57p2xWiz2_stUyDy70AFVN4p81qdTL9"),
  Data(
      english: "Contractor",
      turkish: "Müteahhit",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=13HbUjmJZDp42GEpBqYOMlzHFuWTEJePJ"),
  Data(
      english: "Contradiction",
      turkish: "Çelişki",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1qCYN4wJ9Rd17Qe0c8y-0d5cnkHxtvyad"),
  Data(
      english: "Contrary",
      turkish: "Zıt",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1evN3PccW7s9lrVvyArDZSX7WQ-jvHnZa"),
  Data(
      english: "Contrary",
      turkish: "Aksine",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1evN3PccW7s9lrVvyArDZSX7WQ-jvHnZa"),
  Data(
      english: "Contributor",
      turkish: "Destekçi",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Y4QHQjaD-brNc05v9gPETDMX2Nhtzo6c"),
  Data(
      english: "Controversial",
      turkish: "Tartışmalı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1eXquZ5dWVzx9Jh3yoG7VA5OyMKiZUgQc"),
  Data(
      english: "Controversy",
      turkish: "Tartışma",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1coH7EsUG7jINutuZdQGT20el-LcEG4Vq"),
  Data(
      english: "Convenience",
      turkish: "Kolaylık",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1AuRkdqRM4agifn-qg2kCHxrZoi-taV26"),
  Data(
      english: "Convention",
      turkish: "Gelenek",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1nn5Xy1ICMtKYvlF3ukJ7gHJVX0TNT4SD"),
  Data(
      english: "Conventional",
      turkish: "Geleneksel",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1bZsjAK4bBm4Uwr6kcIXH6zBtI82ebKbV"),
  Data(
      english: "Conversion",
      turkish: "Dönüşüm",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1glUX2-DpE9JFJdLOm7rK2R0RZPtj29Gr"),
  Data(
      english: "Convey",
      turkish: "Nakletmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1EHDJC8BkOXOQzWcWinyhNx29vCXfqSZY"),
  Data(
      english: "Convict",
      turkish: "Suçlu Bulmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1tD-twmKQYRPBjPyNBqPaht_6J9su5h2b"),
  Data(
      english: "Convict",
      turkish: "Suçlu",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1tD-twmKQYRPBjPyNBqPaht_6J9su5h2b"),
  Data(
      english: "Conviction",
      turkish: "Mahkumiyet",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1RbwMM6gDPdvh26N23BvnkeUe6SPHX-Ta"),
  Data(
      english: "Convincing",
      turkish: "İkna Edici",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=15pc_v-RqUegDtRHs34b9l9mVxk5xibOm"),
  Data(
      english: "Cooperate",
      turkish: "İşbirliği Yapmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1X2dMrh92NZdsebDshSrpkVymjCoO7EMT"),
  Data(
      english: "Cooperative",
      turkish: "Ortak Çalışmak",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1EfRhbr6daV5lPN47JQptkWnkuj1AzIFI"),
  Data(
      english: "Coordinate",
      turkish: "Koordine Etmek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1xuDBC3Z_8zvd9n_apbsJV0eevwUYpKGN"),
  Data(
      english: "Coordination",
      turkish: "Kordinasyon",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1XzCopKpAW7CZr7bzAKm38ms6-8D4iGQP"),
  Data(
      english: "Cop",
      turkish: "Polis",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1ijub-xHVjF09OVVL-buLDJkTDOjfYlHw"),
  Data(
      english: "Cope",
      turkish: "Başa Çıkmak",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1Wzs4wgSNQFijfpiiYxxn0yDoPebYqihp"),
  Data(
      english: "Copper",
      turkish: "Bakır",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=19ZZ4lXEqzcaOVy8XzLSPlh3iPkJJpYqN"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
  Data(
      english: "EN",
      turkish: "TR",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink: "https://"),
];
