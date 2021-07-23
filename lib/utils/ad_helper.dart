import 'dart:io';

class AdHelper {

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6504908522392672/5394412199";
    } else if (Platform.isIOS) {
      return "ca-app-pub-6504908522392672/5394412199";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-6504908522392672/8283549359";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_NATIVE_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}