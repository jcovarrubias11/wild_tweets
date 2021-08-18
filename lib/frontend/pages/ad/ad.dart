import 'package:crazy_tweets_2/main.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AdBanner extends StatefulWidget {
  AdBanner({Key key}) : super(key: key);

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd banner;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = context.read(adStateProvider);
    adState.initialization.then((status) {
      print("status: " + status.toString());
      setState(() {
        banner = BannerAd(
            adUnitId: adState.bannerAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: adState.adListener)
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: banner == null
          ? Container()
          : Container(
              color: Colors.transparent,
              child: Center(child: AdWidget(ad: banner))),
    );
  }
}
