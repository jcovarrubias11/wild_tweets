import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:crazy_tweets_2/models/ad_model.dart';

class AdProvider extends StateNotifier<AdModel> {
  AdProvider() : super(AdModel(null));

  void setAdModel({@required Future<InitializationStatus> initialization}) {
    state = AdModel(initialization);
  }
}
