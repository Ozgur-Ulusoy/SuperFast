import 'dart:io';

class AdHelper {
  static bool isTest = false;
  //! Banner
  static String get homePageBannerAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return 'ca-app-pub-5649927083621903/1359861666';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get testPageBannerAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return 'ca-app-pub-5649927083621903/9950181011';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get letterPageBannerAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return 'ca-app-pub-5649927083621903/1809372083';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get wordsPageBannerAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return 'ca-app-pub-3940256099942544/6300978111';
      }
      return 'ca-app-pub-5649927083621903/5607078499';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  //! Interstitial
  static String get testPageInterstitialAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return 'ca-app-pub-5649927083621903/7820316472';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get letterPageInterstitialAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return 'ca-app-pub-5649927083621903/4140355095';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get soundPageInterstitialAdUnitId {
    if (Platform.isAndroid) {
      if (isTest) {
        return "ca-app-pub-3940256099942544/1033173712";
      }
      return 'ca-app-pub-5649927083621903/6124091427';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  //!

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return '<YOUR_ANDROID_REWARDED_AD_UNIT_ID>';
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}

//! Test Ad
class AdHelperTest {
  static String get homePageBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get testPageBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get letterPageBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get wordsPageBannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }
}
