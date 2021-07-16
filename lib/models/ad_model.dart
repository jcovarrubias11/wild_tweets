import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:crazy_tweets_2/utils/config_reader.dart';

class AdModel {
  AdModel(this.initialization);

  Future<InitializationStatus> initialization;

  String get bannerAdUnitId => Platform.isAndroid
      ? ConfigReader.getAndroidAdId()
      : ConfigReader.getiOSAdId();

  AdListener get adListener => _adListener;

  AdListener _adListener = AdListener(
    onAdLoaded: (ad) => print('Ad loaded: ${ad.adUnitId}.'),
    onAdClosed: (ad) => print('Ad closed: ${ad.adUnitId}.'),
    onAdFailedToLoad: (ad, error) =>
        print('Ad failed to load: ${ad.adUnitId}, $error.'),
    onAdOpened: (ad) => print('Ad opened: ${ad.adUnitId}.'),
    onAppEvent: (ad, name, data) =>
        print('App event: ${ad.adUnitId}, $name, $data.'),
    onApplicationExit: (ad) => print('App exit: ${ad.adUnitId}.'),
    onNativeAdClicked: (nativeAd) =>
        print('Native ad clicked: ${nativeAd.adUnitId}.'),
    onNativeAdImpression: (nativeAd) =>
        print('Native ad clicked: ${nativeAd.adUnitId}.'),
  );
}
