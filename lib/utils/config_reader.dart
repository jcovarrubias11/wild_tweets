import 'dart:convert';
import 'package:flutter/services.dart';

abstract class ConfigReader {
  static Map<String, dynamic> _config;

  static Future<void> initialize() async {
    final configString = await rootBundle.loadString('config/app_config.json');
    _config = json.decode(configString) as Map<String, dynamic>;
  }

  static String getApiKey() {
    return _config['apiKey'] as String;
  }

  static String getProjectId() {
    return _config['projectId'] as String;
  }

  static String getDatabaseURL() {
    return _config['databaseURL'] as String;
  }

  static String getiOSAppId() {
    return _config['iosAppId'] as String;
  }

  static String getAndroidAppId() {
    return _config['androidAppId'] as String;
  }

  static String getiOSAdId() {
    return _config['iosAdId'] as String;
  }

  static String getAndroidAdId() {
    return _config['androidAdId'] as String;
  }

  static String getAndroidInterAdId() {
    return _config['androidInterAdId'] as String;
  }

  static String getiOSInterAdId() {
    return _config['iosInterAdId'] as String;
  }

    static String getTestBannerAdId() {
    return _config['bannerTestAdID'] as String;
  }

  static String getTestInterAdId() {
    return _config['interstitialTestId'] as String;
  }

}
