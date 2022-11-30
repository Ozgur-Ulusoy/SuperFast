class Data {
  String english; //? ingilizce hali
  String turkish; //? turkce hali
  WordType type; //? tip'i ( isim zamir fiil vb. )
  WordLevel level; //? ingilizce level seviyesii
  String mediaLink; //? ses dosyasi yolu

  Data(
      {required this.english,
      required this.turkish,
      required this.level,
      required this.type,
      required this.mediaLink});
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

List<Data> questionData = [
  Data(
      english: "Abolish",
      turkish: "Son Vermek",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "https://drive.google.com/uc?export=download&id=1X7KSD2WwdBUIkLxrGzgq_zjYtKr2Ur86"),
  Data(
    english: "Abortion",
    turkish: "Kürtaj",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1CHxmAMSOcJsjAuHBm-40gi4pG8Ui5KK9",
  ),
  Data(
    english: "Absence",
    turkish: "Olmayış",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1wwsuFtGZnI2KXD3DOJA0pu_NDF3v_4Sp",
  ),
  Data(
      english: "Absent",
      turkish: "Yok",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=1GNutnkX1g8cD5WUDyJFR0XhjO1lJhM-Y"),
  Data(
    english: "Absorb",
    turkish: "Emmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1o5k-rnTmoSNUsZTmY5OK7Lu885vk3O70",
  ),
  Data(
    english: "Abstract",
    turkish: "Soyut",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Q4Gchr5afLUDmsbV2XzVbgKC0oslM_nW",
  ),
  Data(
    english: "Absurd",
    turkish: "Saçma",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1YDYkuxd_8y94TU_RrSoQbPFrCqT9Hp7r",
  ),
  Data(
    english: "Abuse",
    turkish: "İstismar",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
  ),
  Data(
    english: "Abuse",
    turkish: "Kötüye Kullanma",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=16PFxBJiqbmFoSvosvoBmBAZEk9FyqaAg",
  ),
  Data(
    english: "Academy",
    turkish: "Akademi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1hIvdev2HHiakazWoS6UA65hmREsrXMr0",
  ),
  Data(
    english: "Accelerate",
    turkish: "Hızlanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Ra16GiSp9n3rrttHJobtWR-WpJCsnElI",
  ),
  Data(
    english: "Accent",
    turkish: "Aksan",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1m5wqpGWRhLCXn7O66Bl33Hv9yBIgJkGP",
  ),
  Data(
    english: "Acceptance",
    turkish: "Kabul",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Bmq_8d3kvFMFpmIKJsDVxdshBWPKDJxA",
  ),
  Data(
    english: "Accessible",
    turkish: "Ulaşılabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1-72_Pu_AUPMV5h4siys4A3l-09IH7mrH",
  ),
  Data(
    english: "Accidentally",
    turkish: "Tesadüfen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1xrrGiLDkdsoDgCp4ijQy6WVNLaffU38n",
  ),
  Data(
    english: "Accommodate",
    turkish: "Tedarik Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ypwijSBPabhOmn-8ALNegNOkaX5XNxox",
  ),
  Data(
    english: "Accommodation",
    turkish: "İkametgah",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1hfijJd1ApLg1TMiumodpVrEdoE-DQRis",
  ),
  Data(
    english: "Accomplish",
    turkish: "Başarmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1GzezRpMPo0Iwyj8SFRrmmnfv8K53ido9",
  ),
  Data(
    english: "Accomplishment",
    turkish: "Başarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Bc_K94nj0I1IIxnxufS7GjBr_sRtWjF0",
  ),
  Data(
    english: "Accordingly",
    turkish: "Buna Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1C3DyZth-MhYDGWRySDuliSvDGIfzqfUo",
  ),
  Data(
    english: "Accountability",
    turkish: "Sorumluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=15G27ZqvSUEtuSItNl4q-7XVek-Iem5E_",
  ),
  Data(
    english: "Accountable",
    turkish: "Sorumlu",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1eSDIPzkxJSVMalfwo3Gskd-eor2UyGQR",
  ),
  Data(
    english: "Accountant",
    turkish: "Muhasebeci",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1eAkmvWcHtNP9xqpFtfWlx0umOd-OCnCk",
  ),
  Data(
    english: "Accumulate",
    turkish: "Biriktirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1LpFhq0HI1wdSwCmYAWTBa2mI9KrMTzZE",
  ),
  Data(
    english: "Accumulation",
    turkish: "Birikme",
    level: WordLevel.c2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1VgbjS_XKhsZsLCBfX49ZPyKzgo1RhGSl",
  ),
  Data(
    english: "Accuracy",
    turkish: "Doğruluk",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1FBiO3RDQFmw1tRqJcq5I94SitQbpEHNX",
  ),
  Data(
    english: "Accurately",
    turkish: "Tam Olarak",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1qbXNoaWCYyrOlnIZdK0_f9l6OlZcqtNP",
  ),
  Data(
    english: "Accusation",
    turkish: "Suçlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1iAc5RkzrduuKu_s_XTW1bM5AFL20V8Wr",
  ),
  Data(
    english: "Accused",
    turkish: "Sanık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=1SlZXy2Mu-_QgdLGSui4F7JjEbcElm1Y-",
  ),
  Data(
    english: "Acid",
    turkish: "Asit",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
  ),
  Data(
    english: "Acid",
    turkish: "Asitli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1FnBofFbiECExaG4F2btPYPj9rghl2v2R",
  ),
  Data(
    english: "Acquisition",
    turkish: "Edinim",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1prYxOsYe-XNeIT1OPg-gqG86HKCmnzG_",
  ),
  Data(
    english: "Acre",
    turkish: "Hektar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1LhMM1VMEBL3YyC0AIz0sK9v1H5KMwbtM",
  ),
  Data(
    english: "Activate",
    turkish: "Çalıştırmak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1H75OoLMtU-5upOBjtTtaa95hqetJzz3T",
  ),
  Data(
    english: "Activation",
    turkish: "Aktifleştirme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1mn2sxnJLpEPDmVjqwLpHOoHHBRWC23mW",
  ),
  Data(
    english: "Activist",
    turkish: "Savunucu",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ohSi-FEdObYcuY49nkyUpYyLTwXQ5Otx",
  ),
  Data(
    english: "Acute",
    turkish: "Şiddetli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=168F98_OljdKFjbDtKh2I2cutZx1pfGAD",
  ),
  Data(
    english: "Adaptation",
    turkish: "Uyarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1tZbzbHhXvk0mamiVTEjLN_pLoLUhBHCW",
  ),
  Data(
    english: "Addiction",
    turkish: "Bağımlılık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1xHozXnoUsjdJWYE4hXQj_14uWHl9zgN8",
  ),
  Data(
    english: "Additionally",
    turkish: "İlaveten",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=13Y7NwMnvDdrUMui1T2z8UydujTtj0tdL",
  ),
  Data(
    english: "Adequate",
    turkish: "Yeterli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1V6oAqPDm5RPAFPaKbszffdyDcPiEUV3y",
  ),
  Data(
    english: "Adequately",
    turkish: "Yeterince",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1D04jd4kM9LTrQg1KFRI4Hug9RG6-QDr1",
  ),
  Data(
    english: "Adhere",
    turkish: "Yapışmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=1f1DBUI-SxdqtGqbYXN4mxizkMgZL7Csc",
  ),
  Data(
    english: "Adjacent",
    turkish: "Bitişik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1PMipKnVa3Y_FXvc8DQIckNHe-jD7eg-R",
  ),
  Data(
    english: "Adjust",
    turkish: "Ayarlamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1rhwwdcigtutgbNWRCfi2JeWOHC0EGdT8",
  ),
  Data(
    english: "Adjustment",
    turkish: "Ayarlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1gB5EPbCnsX74H3YtfMsfBJPotMS9tyG5",
  ),
  Data(
    english: "Administer",
    turkish: "İdare Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1XcWpvDY7CQsqfyMLE9-w7Ed2WczIzGD2",
  ),
  Data(
    english: "Administrative",
    turkish: "İdari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Sox3D78HFO0H77epmq7A0lEDSXlLeBnV",
  ),
  Data(
    english: "Administrator",
    turkish: "Yönetici",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1BL1X1vrqO8CR4kthwE42CmtSpdnJc06f",
  ),
  Data(
    english: "Admission",
    turkish: "İtiraf",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1k9ya9G5pDWS4j_f3IPTyOsjUz3vCZncp",
  ),
  Data(
    english: "Adolescent",
    turkish: "Ergen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1UUp7XeVJEnjhummmy7eMa6Xdfru-V0h6",
  ),
  Data(
    english: "Adoption",
    turkish: "Benimseme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=13cdOhE8QuBr_pJQ_frlfFqajXQ5BFmEO",
  ),
  Data(
    english: "Adverse",
    turkish: "Karşıt",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=16ZNzFiIiyFxHYyErutkt--FH_Nbm75WJ",
  ),
  Data(
    english: "Advocate",
    turkish: "Desteklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
  ),
  Data(
    english: "Advocate",
    turkish: "Destekleyen",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1dWLey_Jyd5taWFOF1juwuOP_gC5XG0y_",
  ),
  Data(
    english: "Aesthetic",
    turkish: "Estetik",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1DC4pM41-90ox15wAKGdzUYIXihQU6-7N",
  ),
  Data(
    english: "Affection",
    turkish: "Sevgi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1f8YaqvHRZDg7m26yzgUYBcDGIvtvSAlN",
  ),
  Data(
    english: "Affordable",
    turkish: "Alınabilir",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1V2wABU3iARv7GyLbSs_DZpNPWYQxmpE2",
  ),
  Data(
    english: "Aftermath",
    turkish: "Sonrası",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1OKXTDV-xF4_4jsMqVo4tSHhHzc4GPZ1T",
  ),
  Data(
    english: "Aged",
    turkish: "Yaşlanmış",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=182lMlz4Vyom8jEL1PzsudHeZz4DwBT5M",
  ),
  Data(
    english: "Aggression",
    turkish: "Saldırganlık",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1h5L8fvCdHnx4YGCfq42omdZhjE0KM26W",
  ),
  Data(
    english: "Agricultural",
    turkish: "Tarımsal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ROVqgV8WRKQmwn4VEsGyaGvoNy8cJ3fy",
  ),
  Data(
    english: "Agriculture",
    turkish: "Ziraat",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ZnvEe3iYgzFYZh7TCsSvjkdzNlHLfr76",
  ),
  Data(
    english: "Aide",
    turkish: "Yardımcı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=15qvk9g--wN3QXQVylRf4V9ZE7DcfmTsu",
  ),
  //!
  Data(
    english: "Alert",
    turkish: "Uyarmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alert",
    turkish: "Uyarı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alert",
    turkish: "Dikkatli",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Vzhh0j7sIAc_4wnwNuKJHU8DA4uyaFay",
  ),
  Data(
    english: "Alien",
    turkish: "Uzaylı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
  ),
  Data(
    english: "Alien",
    turkish: "Acayip",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1T_QED2_aOMXKnV7JNrzctzs_AdH7dHjg",
  ),
  Data(
    english: "Align",
    turkish: "Hizalamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1zpK5ui7GZLOxpFcANQKE8swLW8neEP4B",
  ),
  Data(
    english: "Alignment",
    turkish: "Aynı Hizaya Getirmek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1fOuPeaY5sWJmXoBcABL4cpZlQW_K_POr",
  ),
  Data(
    english: "Alike",
    turkish: "Aynı Şekilde",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
  ),
  Data(
    english: "Alike",
    turkish: "Benzer",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1190ZazdHM-6Cr07RD5h3QQrKbM4dq7mC",
  ),
  Data(
    english: "Allegation",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1LTG1M64j9ALtGklxnGMg8T5Uh-I0Fvzd",
  ),
  Data(
    english: "Allege",
    turkish: "İddia Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1dxfYHqVfsbE0XkcrHp1yFPMeFWfUonP9",
  ),
  Data(
    english: "Allegedly",
    turkish: "İddiaya Göre",
    level: WordLevel.c1,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1rntCt1x7f5OcCPcvuVUQiBJgBE_xzSZA",
  ),
  Data(
    english: "Alliance",
    turkish: "İttifak",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1T9Kp-Js7mtMVXZMDxXcF0gXN9fMuMdQg",
  ),
  Data(
    english: "Allocate",
    turkish: "Ayırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1_3kU1xneTzG50yEiCZbnnKOZ3Dn6t_nB",
  ),
  Data(
    english: "Allocation",
    turkish: "Tahsisat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=13lo2tqgcOjOJsP7b4WnhvmJ97nSDZuDl",
  ),
  Data(
    english: "Allowance",
    turkish: "Ödenek",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1dLZbvPVfwDvp9yLDySVrmzy8BG_XyUUR",
  ),
  Data(
    english: "Ally",
    turkish: "Müttefik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1A_YqDbxN7L8AfPcz6ZvW_GUdpbeuzrQo",
  ),
  Data(
    english: "Alongside",
    turkish: "Yanıbaşında",
    level: WordLevel.b2,
    type: WordType.preposition,
    mediaLink:
        "drive.google.com/uc?export=download&id=1YMuOiThlK4Kf-vn7QLSRvz_VxfuXkBxX",
  ),
  Data(
    english: "Altogether",
    turkish: "Tamamen",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1AjCqR-hgZ7-sMvGg3LGwZ4L4rIQEidjG",
  ),
  Data(
    english: "Aluminium",
    turkish: "Aliminyum",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1fycLOL_C_AzK7bPYMQGUV_kqHqb3VFBv",
  ),
  Data(
    english: "Amateur",
    turkish: "Amatörce",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
  ),
  Data(
    english: "Amateur",
    turkish: "Acemi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=16kRe7sreecVuJHwwM_4gYu9UyN6yjmgY",
  ),
  Data(
    english: "Ambassador",
    turkish: "Büyükelçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1xozLYMpGOGv2Wa4I-EhOOg7nexTPKpIz",
  ),
  Data(
    english: "Ambitious",
    turkish: "Hırslı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1pHYdjJjNDpVMBtQ9sJLHPDyfV4xlVqvB",
  ),
  Data(
    english: "Amend",
    turkish: "Değiştirmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1n16wyhtAGvuIZLmvBW8veIyIRRsO6Yak",
  ),
  Data(
    english: "Amendment",
    turkish: "Değişiklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1YOvEeZ0RGgrLjiflJdsOwHcZzj0VTPCK",
  ),
  Data(
    english: "Amid",
    turkish: "Ortasında",
    level: WordLevel.c1,
    type: WordType.preposition,
    mediaLink:
        "drive.google.com/uc?export=download&id=1QFssgpduG_0qwNL0ADASEH_tnx6jhs1y",
  ),
  Data(
    english: "Amusing",
    turkish: "Eğlendirici",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1k7wrMxxH48E5m9j84nu5zs6vfmlJpPn_",
  ),
  Data(
    english: "Analogy",
    turkish: "Benzeşme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1uGfT5U92x4PfrglX0c00IUNweuhsphLX",
  ),
  Data(
    english: "Analyst",
    turkish: "Analist",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1_FQJZGmHmZHe-dAOcAp-SLHdDopX-Pd1",
  ),
  Data(
    english: "Ancestor",
    turkish: "Ata",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=12-FsuaH4vqncRlEsmuqahVfus1Em7t5f",
  ),
  Data(
    english: "Anchor",
    turkish: "Çapa",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1peTLfu16JGq3Y9hF9JhgKhI-8XkyJnCb",
  ),
  Data(
    english: "Angel",
    turkish: "Melek",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1o_On2Clok7-BDKVAcnxKVLnUr2MEUvwF",
  ),
  Data(
    english: "Animation",
    turkish: "Canlandırma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ZSdgENrjyH98VsjNoiX-OLWZ-KCIu7bE",
  ),
  Data(
    english: "Annually",
    turkish: "Her Sene",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1EKUV_be5EcpFhsyv9bwo0HxbOXwA0xxm",
  ),
  Data(
    english: "Anonymous",
    turkish: "Anonim",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Hljw6RhLCtz1S1nJ4QCB7Plh5caquDa-",
  ),
  Data(
    english: "Anticipate",
    turkish: "Ummak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ACDE4mpbzVOCmHCxLyrAu2zMwp0HrgFi",
  ),
  Data(
    english: "Anxiety",
    turkish: "Endişe",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1phLgaKB3dHEw8TDBPFH5fMqfM30S8Qoa",
  ),
  //! ingilizce level düzeyine cambridge'in kendi sitesinden bakmaya başladım
  Data(
    english: "Apology",
    turkish: "Özür",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1HuJ9WcnSuebEabzWoAMSXoJ7nqthukSq",
  ),
  Data(
    english: "Apparatus",
    turkish: "Aygıt",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1aND-uPcx1raQoE8DJF0x-XpHLO-yp0ia",
  ),
  Data(
    english: "Apparel",
    turkish: "Kıyafet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1hFVXuVJY7raQtV_SM54Eqsd8cUqqmMll",
  ),
  Data(
    english: "Appealing",
    turkish: "Çekici",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1n6HJ7SF7H1B-ziNWBLLxwcgFrGPiXu71",
  ),
  Data(
    english: "Appetite",
    turkish: "İştah",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1WO2bDldAFTgOn645WCvzSXbwvL4oiY-6",
  ),
  Data(
    english: "Applaud",
    turkish: "Alkışlamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1BBnzqOiUANESwnykryoi0VZCuTxyu8yn",
  ),
  Data(
    english: "Applicable",
    turkish: "Uygulanabilir",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Spv5bi8hHPtwaq1zv-2C8kWWramiSEsQ",
  ),
  Data(
    english: "Applicant",
    turkish: "Başvuran",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=19hQ7Sbvbe11BxccGrVWb4ibrMLOYfhzc",
  ),
  Data(
    english: "Appoint",
    turkish: "Atamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1PCqWAzZt-KBgLL6my_hbVEv_vgDwOcIn",
  ),
  Data(
    english: "Appreciation",
    turkish: "Takdir",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1HhHktkmzHC9eRYAmQ6llSvODuXUJ84Nv",
  ),
  Data(
    english: "Appropriately",
    turkish: "Uygun Şekilde",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1-hp-FZ9bi30BVaN1hDZfCIf77CgrMkZ2",
  ),
  Data(
    english: "Arbitrary",
    turkish: "Keyfi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1hsCjBqiVMPBaZbxcINYc1REn0YTfqp5n",
  ),
  Data(
    english: "Architectural",
    turkish: "Mimari",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=13r9EUlQWtFkZ68B0GzEvixHAzI-klS5V",
  ),
  Data(
    english: "Archive",
    turkish: "Arşiv",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1dtZ6j4_TVLa_UNjbclXy-hql2YC0m7Ld",
  ),
  Data(
    english: "Arm",
    turkish: "Silahlandırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1cq0pDz5zr-oo5XEy5ViPvBlcg_CYkcVg",
  ),
  Data(
    english: "Array",
    turkish: "Dizi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1VAvDm46kcoUjQ6eyEkQRxci6fg4q8J5R",
  ),
  Data(
    english: "Arrow",
    turkish: "Ok",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1TEuieWo5C8zZRDGikpKQWH8wmsdiZw_g",
  ),
  Data(
    english: "Articulate",
    turkish: "Açıklamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ezW-Vw5jsfte3PBjfJgxGjx8_IhNP6fF",
  ),
  Data(
    english: "Artwork",
    turkish: "Sanat Eseri",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=14FlMtv-T7Tt0lsxAXy4qmZK6Df_NlUXo",
  ),
  Data(
    english: "Ash",
    turkish: "Kül",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Am7f_8h-f_3HpaUn0UrZ5T4RvKr0SQqo",
  ),
  Data(
    english: "Aspiration",
    turkish: "Özlem",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1XN5qB-SgN4kWtZpLpU-bQ4e9K0Iz62r-",
  ),
  Data(
    english: "Aspire",
    turkish: "Çok İstemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=15Q8yhkxuBSuKe95daTsVtINoKzWZhueQ",
  ),
  Data(
    english: "Assassination",
    turkish: "Suikast",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1J4IzZUSPdpXBCmjRGGbuMGr2Q6-G__cn",
  ),
  Data(
    english: "Assault",
    turkish: "Saldırı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
  ),
  Data(
    english: "Assault",
    turkish: "Saldırmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Qqoj1_SHipXU4ld3-sFvv4OdxmpyUevb",
  ),
  Data(
    english: "Assemble",
    turkish: "Toplanmak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1TjFaY1LJPWbCTwh6zhwtPVdrixTGSRPJ",
  ),
  Data(
    english: "Assembly",
    turkish: "Toplantı",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1C85ELyCBaAKGtDl6xfSJwGE98vhDH_f7",
  ),
  Data(
    english: "Assert",
    turkish: "Beyan Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1a47KOAJA70ew7Fv9HvQd7b7GX8AVjIdj",
  ),
  Data(
    english: "Assertion",
    turkish: "İddia",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1k7KdPEJlEIVoTwSee2HApW-A4kURVPOb",
  ),
  Data(
    english: "Asset",
    turkish: "Servet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1MbrZgHLiEnHe0QP00zHljf4N-2IsPso2",
  ),
  Data(
    english: "Assign",
    turkish: "Görevlendirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1WgOKt7npiqZt8VS8UKYiNql2zTJGeO5Y",
  ),
  Data(
    english: "Assistance",
    turkish: "Yardım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1zug94ZYx1Kc9CgNbGVO0Ijtf87M6yNPn",
  ),
  Data(
    english: "Assumption",
    turkish: "Varsayım",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1VoWsL86obLAUZTkfKPFd56gPD56o95L1",
  ),
  Data(
    english: "Assurance",
    turkish: "Teminat",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1w9A_ikkFG5NMlDvXGS8MoaZ8wiVICyWn",
  ),
  Data(
    english: "Assure",
    turkish: "Garanti Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1zv_Ji4vSnXCerkuNOyYlft_fa2Keze1m",
  ),
  Data(
    english: "Astonishing",
    turkish: "Şaşırtıcı",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1zaks5mQ1spJloAcZ0DFfEOe_qmF6_pyw",
  ),
  Data(
    english: "Asylum",
    turkish: "Akıl Hastanesi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1v34CSyrDtRE6ZMu1Ubw4NZmjjrjNGzzb",
  ),
  Data(
    english: "Athletic",
    turkish: "Atletik",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1aVtGw4z_UNmqYf3kCzkEa054DEpzJWxO",
  ),
  Data(
    english: "Atrocity",
    turkish: "Vahşet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=13Cp8MJxNTysi3_pN6iNXPvWMoSsjWdVg",
  ),
  Data(
    english: "Attachment",
    turkish: "Eklenti",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1Fo5mcb-kYxAeP4gk6WIRVn4JutfU0fzT",
  ),
  Data(
    english: "Attain",
    turkish: "Erişmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1BaHO1wIrj6WR2Hyws1rdpYyI5g9QO46K",
  ),
  Data(
    english: "Attendance",
    turkish: "Katılım",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1qTcCy0KXcnuCt3KpS3J2UMc7wSVBGj4W",
  ),
  Data(
    english: "Attribute",
    turkish: "Özellik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1W7Di_rIEnIMEPByA9WdfUr3x9tahcxEU",
  ),
  Data(
    english: "Auction",
    turkish: "Açık Arttırma",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=18rpDDws732iFAqx29co_nTBqjBFS-nNF",
  ),
  Data(
    english: "Audit",
    turkish: "Denetçi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=13svznKutHbDQNvAuwKpg2JYY7ARB0zMo",
  ),
  Data(
    english: "Authentic",
    turkish: "Orijinal",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1ENFuuwaMYb5Nx-V-MF1ZEKuLb9tqaKMa",
  ),
  Data(
    english: "Authorize",
    turkish: "Yetki Vermek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1wR3ouN0bZd3ZRSTJnqoOaaPgTsNAi04i",
  ),
  Data(
    english: "Autonomy",
    turkish: "Özerklik",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1enIXA1voM-rJt75LGv57_outmpZBkWOr",
  ),
  Data(
    english: "Autumn",
    turkish: "Sonbahar",
    level: WordLevel.a2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1mIgLfPpRD3BHuaovORHpgIpD_0YrDe6w",
  ),
  Data(
    english: "Availability",
    turkish: "Mevcut Olma",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1A2ZVhBYPJmvGSSGkjrIc7ZAm0gcxFJfT",
  ),
  Data(
    english: "Await",
    turkish: "Beklemek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink:
        "drive.google.com/uc?export=download&id=1AN5yPFczD-Wo6_WtuSWi7SbQ6DIE27pe",
  ),
  Data(
    english: "Awareness",
    turkish: "Farkındalık",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1gbf38_w59c-cIRaIhc-1atVl06T4fPLg",
  ),
  Data(
    english: "Awkward",
    turkish: "Beceriksiz",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=1akY2mbfG57S-0aeNklfH-GE5vddQIZ9z",
  ),
  Data(
    english: "Backing",
    turkish: "Destekleme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1T8-Pi3T88_cNE-SrnODNwi-1_6YI3I5_",
  ),
  Data(
    english: "Backup",
    turkish: "Destek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1mXH78sHGyQE_cwJuwKH2MOCR7CwA4sjx",
  ),
  Data(
    english: "Badge",
    turkish: "Rozet",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1kvvk41tQO57XZlSU-NCXaAR7XwgHvpps",
  ),
  Data(
    english: "Bail",
    turkish: "Kefalet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink:
        "drive.google.com/uc?export=download&id=1AN_mXG7e-2DU280dJ8yGFyT9XS5ll4K3",
  ),
  Data(
    english: "Balanced",
    turkish: "Dengeli",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink:
        "drive.google.com/uc?export=download&id=142dSdyRz19B5GkKK0QiEkhiRXAmRes25",
  ),
  Data(
      english: "Ballot",
      turkish: "Oylama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1YDsXUR62WUIJcjT_NbjxOOidGRqcJgRp"),
  Data(
      english: "Bankruptcy",
      turkish: "İflas",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1ZlzSqUKr69hEvlciDajq4BCFZg6Ahyd2"),
  Data(
      english: "Banner",
      turkish: "Sancak",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1vEK42YgDlG0sON0s8Mw-4xaPUG1wNj-N"),
  Data(
      english: "Bare",
      turkish: "Çorak",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=1tqeLYnjaqXyP_D0O2kVumop0ZW2QYsbY"),
  Data(
      english: "Barely",
      turkish: "Ancak",
      level: WordLevel.b2,
      type: WordType.adverb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1PdIm1DWGwn58yJW26Pd-Vh-heO3rE8EZ"),
  Data(
      english: "Bargain",
      turkish: "Pazarlık",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1vE3nzAOGyj3MQv9zXAw9xg05aAlT1rAz"),
  Data(
      english: "Barrel",
      turkish: "Namlu",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1u-GnhRJoONz_ylv5KzuFUXI5J59zSIYn"),
  Data(
      english: "Basement",
      turkish: "Bodrum",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1fLPg5mKqVFUFI_Fpfl70TcfSxb5Ij_Lv"),
  Data(
      english: "Basket",
      turkish: "Sepet",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1EpVDX70QTmBfucAKk-fwSMlYjfD95xCb"),
  Data(
      english: "Bat",
      turkish: "Yarasa",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1btyry_kKS0nrJe5YGu856aYzJgOXW9JR"),
  Data(
      english: "Battlefield",
      turkish: "Savaş Alanı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1pyqlIlbrUNxO5XIWlS1VugI8gHaFvo6X"),
  Data(
      english: "Bay",
      turkish: "Körfez",
      level: WordLevel.b1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1yEME9Rs_M-N3nGiyVSuFS60dlvx94TWh"),
  Data(
      english: "Beam",
      turkish: "Işın",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1LDklALd36Ag8k6bOTVEvtww5dGetsmSx"),
  Data(
      english: "Beast",
      turkish: "Hınzır",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1O0mbOrOFGDmwmMNx962CXL7rBmpM8blK"),
  Data(
      english: "Behalf",
      turkish: "Temsilen",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1BIrdCmTau5MM7EKHnJdtz5wVjfhvyxU0"),
  Data(
      english: "Behavioral",
      turkish: "Davranışsal",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=1eVah5H0KnXnXExscxXzOKv2f5s2PGqjj"),
  Data(
      english: "Beloved",
      turkish: "Sevgili",
      level: WordLevel.c1,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=1PmnPpKagQIxy70yuLji-GYHV9hEZ1jP4"),
  Data(
      english: "Bench",
      turkish: "Bank",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1Qj8zQM_I8iSwjmoKIPRgXUHbd1blvr8y"),
  Data(
      english: "Benchmark",
      turkish: "Kalite Seviyesi",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1J_2BkCzE8sGRNvwVkiPj92mfbNSjmF-u"),
  Data(
      english: "Beneath",
      turkish: "Altında",
      level: WordLevel.b1,
      type: WordType.preposition,
      mediaLink:
          "drive.google.com/uc?export=download&id=1Ron8lMD18loLTPt57hp-YUl2zABmVoZE"),
  Data(
      english: "Beneficial",
      turkish: "Faydalı",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=17GynwUAA0hnSVvMPlFyJFl-G8HB2wY0d"),
  Data(
      english: "Beneficiary",
      turkish: "Yardıma Muhtaç",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1ue7dmF5c37Pm-oi6ls104i5GIo0nqPHX"),
  Data(
      english: "Beside",
      turkish: "Yanında",
      level: WordLevel.a2,
      type: WordType.preposition,
      mediaLink:
          "drive.google.com/uc?export=download&id=1xaPuqb7FudoToTcTG3VfZASfA5IwET0e"),
  Data(
      english: "Besides",
      turkish: "Ayrıca",
      level: WordLevel.b1,
      type: WordType.adverb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1bKXcqSi1vp7xTaDeS45AIZKnNXUbbe5F"),
  Data(
      english: "Betray",
      turkish: "İhanet Etmek",
      level: WordLevel.b2,
      type: WordType.verb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1Kzfs5KCrLKXv4FuZvSP52zprA2hKry_8"),
  Data(
      english: "Beverage",
      turkish: "İçecek",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1lzSEhGP0OGJ-P5PH3sFxcw_tMQQL1WmQ"),
  Data(
      english: "Bias",
      turkish: "Önyargı",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1lwIyX8hpcRubZnL1rctA4GWyvfi_UJzI"),
  Data(
      english: "Bid",
      turkish: "Girişim",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1gkOrmbF_VvtJBFu3N_uHvHyfFuT3CRjc"),
  Data(
      english: "Bind",
      turkish: "Bağlamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "drive.google.com/uc?export=download&id=173GFX-VU7wrEKTfvwqQA7huiATdds8vj"),
  Data(
      english: "Biological",
      turkish: "Biyolojik",
      level: WordLevel.b2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1wAXjQJmoLLMNYBebqToIgLXwoO0cVWIQ"),
  Data(
      english: "Bishop",
      turkish: "Piskopos",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=13SlPmJaiAKgwDAr5ZN4vfr37FObJVZgD"),
  Data(
      english: "Bizarre",
      turkish: "Acayip",
      level: WordLevel.b2,
      type: WordType.adjective,
      mediaLink:
          "drive.google.com/uc?export=download&id=1HTBL2gqYybW0Y-6JvI5Q_L4Tjt8lPVLQ"),
  Data(
      english: "Blade",
      turkish: "Bıçak Ağzı",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1d0qiUlpm-HP59HEOexQ5R2ZaRcLQzQ7x"),
  Data(
      english: "Blanket",
      turkish: "Battaniye",
      level: WordLevel.a2,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1GODnPAtsu3Hwfc0fH8bCR-Uobqi06z4_"),
  Data(
      english: "Blast",
      turkish: "Büyük Patlama",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1iFYYcm4vOknprC3fQE131-VLdso5f2ha"),
  Data(
      english: "Bleed",
      turkish: "Kanamak",
      level: WordLevel.b1,
      type: WordType.verb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1YTY7uve0-cp6QBbFJAyp3rXKkAvlN34m"),
  Data(
      english: "Blend",
      turkish: "Karıştırmak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv"),
  Data(
      english: "Blend",
      turkish: "Karışım",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1SdEr1bkJjAJqpOG80hkrNH_-7btmm3dv"),
  Data(
      english: "Bless",
      turkish: "Kutsamak",
      level: WordLevel.c1,
      type: WordType.verb,
      mediaLink:
          "drive.google.com/uc?export=download&id=1MkufwyLGV5VsnbGbEXLhaVvipAD015Rh"),
  Data(
      english: "Blessing",
      turkish: "Nimet",
      level: WordLevel.c1,
      type: WordType.noun,
      mediaLink:
          "drive.google.com/uc?export=download&id=1hCvEMqn5jP1YOYjGloh-YW0ilf3V_YDD"),
  Data(
    english: "Blow",
    turkish: "Üflemek",
    level: WordLevel.b1,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1l0aH9e-Y9uKXVpZCxxIiWjUNh1A8UdRV"
  ),
  Data(
    english: "Boast",
    turkish: "Övünme",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1HQ6AoQ01KhiHtlmVVF6veiDDoOldx22v"
  ),
  Data(
    english: "Bold",
    turkish: "Cesur",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "drive.google.com/uc?export=download&id=1uYbm9tntPs_5bUlSplx9brJhD1kwIk1P"
  ),
  Data(
    english: "Booking",
    turkish: "Rezervasyon",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink:"drive.google.com/uc?export=download&id=1ZLoEgrEfWZPsPfpjJYh63QemGkYpne2T"
  ),
  Data(
    english: "Boom",
    turkish: "Patlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1BgeD8Iqa54x2sbM8JUpidZhNpVhhJqjp"
  ),
  Data(
    english: "Boost",
    turkish: "Desteklemek",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7"
  ),
  Data(
    english: "Boost",
    turkish: "Geliştirmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1q5nqvokGXFJksmG_fmaW7ntO6hbrUMB7"
  ),
  Data(
    english: "Bounce",
    turkish: "Zıplamak",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1fTOhd6bAqsIg4XIlTxCWcs1rq33uvtI0"
  ),
  Data(
    english: "Bound",
    turkish: "Sorumlu",
    level: WordLevel.b2,
    type: WordType.adjective,
    mediaLink: "drive.google.com/uc?export=download&id=1Jq6jD5WwrLp5Ia_aVs2L0Vb-a8NY785h"
  ),
  Data(
    english: "Boundary",
    turkish: "Sınır",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1JCX2lhRZ6c9SPr4pP9exH20PCmz_MWxu"
  ),
  Data(
    english: "Bow",
    turkish: "Selamlama",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1yKQ3KKeppIJ7LX8nkyMK8DmXbpbd824T"
  ),
  Data(
    english: "Breach",
    turkish: "İhlal",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc"
  ),
  Data(
    english: "Breach",
    turkish: "İhlal Etmek",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1XlEfLIQQHw2mV909h-RK9liDGS8tAjvc"
  ),
  Data(
    english: "Breakdown",
    turkish: "Zihinsel Çöküntü",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=13T3nVaPk39JNeRcvPEYftKc0xPYFnMVD"
  ),
  Data(
    english: "Breakthrough",
    turkish: "Önemli Buluş",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1yvM-81xf2hBrH4B17dXdAIL46ovYv1Xa"
  ),
  Data(
    english: "Breed",
    turkish: "Yavrulamak",
    level: WordLevel.c1,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4"
  ),
  Data(
    english: "Breed",
    turkish: "Hayvan Cinsi",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1l_z6BDZExutr0WB482U9rWSqv38Pk8X4"
  ),
  Data(
    english: "Brick",
    turkish: "Tuğla",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1Ycw3b3MBcQlQ3NvbYkIyfnH_P_CVyBp4"
  ),
  Data(
    english: "Briefly",
    turkish: "Kısaca",
    level: WordLevel.b1,
    type: WordType.adverb,
    mediaLink: "drive.google.com/uc?export=download&id=1ikXHbX1SUmQnNFqr821vH_sGqwK6YNLr"
  ),
  Data(
    english: "Broadband",
    turkish: "Geniş Bant",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1UIk5OwyIgtXZIbooC7sm5pZzrmz3u3xs"
  ),
  Data(
    english: "Broadcaster",
    turkish: "Yayıncı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=19unVvGq4AgcBxrRfm6Dn_jQ1cxZ4G-Yx"
  ),
  Data(
    english: "Broadly",
    turkish: "Genel Anlamda",
    level: WordLevel.b2,
    type: WordType.adverb,
    mediaLink: "drive.google.com/uc?export=download&id=1xIhBnQw9Uz8RurMgGXAj8K8Kjl7Xj9QA"
  ),
  Data(
    english: "Browser",
    turkish: "Tarayıcı",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1IDSqeHaCS0Iiw1q6pJ4gNIDVle6kh8dj"
  ),
  Data(
    english: "Brutal",
    turkish: "Vahşi",
    level: WordLevel.c1,
    type: WordType.adjective,
    mediaLink: "drive.google.com/uc?export=download&id=13D_5oiScD4K7RcU9DWuTNeGj6RZUH9xF"
  ),
  Data(
    english: "Buck",
    turkish: "Dolar",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1KFUNLfJKmIRZMZQ4ECk94FfZoHJTVtU7"
  ),
  Data(
    english: "Buddy",
    turkish: "Ahbap",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1sgEfnpoxSLFdWabuoMT1gXKCintZDBuK"
  ),
  Data(
    english: "Buffer",
    turkish: "Tampon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1es76q0tNqKrobQS8ecUwrLFTc0t6hi1b"
  ),
  Data(
    english: "Bug",
    turkish: "Hata",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink:"drive.google.com/uc?export=download&id=14ppKaOzDRJY6QYLmD6NwddzkbnlIpvEA"
  ),
  Data(
    english: "Bulk",
    turkish: "Çok Miktarda",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1bQwd7s1Hj9mPaxnodLT4QhwYaLy7XFbI"
  ),
  Data(
    english: "Burden",
    turkish: "Sorumluluk",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1_sTORdaVQZqw6lW48v2XsEV8bRX2Mc78"
  ),
  Data(
    english: "Bureaucracy",
    turkish: "Bürokrasi",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1w8txOnMGcBgKic4SYhiKOCsGEuJkbNK_"
  ),
  Data(
    english: "Burial",
    turkish: "Defin",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1vwjx3fVB9hWpdjeU2PJSxvRdxdg0kjFT"
  ),
  Data(
    english: "Burst",
    turkish: "İnfilak Etmek",
    level: WordLevel.b2,
    type: WordType.verb,
    mediaLink: "drive.google.com/uc?export=download&id=1ToTR1IcAfFSTFdpxr3nJL8jsi6D6baJo"
  ),
  Data(
    english: "Cabinet",
    turkish: "Kabine",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1CpWGPwOwRULUOLm6ezwjmV4OWbh5bkva"
  ),
  Data(
    english: "Calculation",
    turkish: "Hesaplama",
    level: WordLevel.b2,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=14bsKLxrxSkKNQRXk_4LxoWFgtISzlyun"
  ),
  Data(
    english: "Candle",
    turkish: "Mum",
    level: WordLevel.b1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=106ZzBefaicJ44yqjxqBKjYHcB-MtKlg6"
  ),
  Data(
    english: "Canvas",
    turkish: "Tuval",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1MBozCbLV0r2pnH0BEsLIFqPYwAC2vNm7"
  ),
  Data(
    english: "Capability",
    turkish: "Kabiliyet",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=1P3bZd0a7mg4Ays4iThpfNDAd61D53lLb"
  ),
  Data(
    english: "Carriage",
    turkish: "Vagon",
    level: WordLevel.c1,
    type: WordType.noun,
    mediaLink: "drive.google.com/uc?export=download&id=12_AJ4ZYDSguG67TuzkqSlonv6heNay74"
  ),
  // Data(
  //   english: "EN",
  //   turkish: "TR",
  //   level: WordLevel.c1,
  //   type: WordType.noun,
  //   mediaLink:
  // ),
];
