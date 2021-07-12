import 'package:crazy_tweets_2/models/ad_model.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  AdBanner({Key key, this.adModel}) : super(key: key);
  final AdModel adModel;

  @override
  _AdBannerState createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print(widget.adModel.bannerAdUnitId);
    widget.adModel.initialization.then((status) {
      print(status);
      setState(() {
        banner = BannerAd(
            adUnitId: widget.adModel.bannerAdUnitId,
            size: AdSize.banner,
            request: AdRequest(),
            listener: widget.adModel.adListener)
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
