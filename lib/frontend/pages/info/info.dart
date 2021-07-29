import 'package:crazy_tweets_2/frontend/pages/info/components/begin.dart';
import 'package:crazy_tweets_2/frontend/pages/info/components/chooselose.dart';
import 'package:crazy_tweets_2/frontend/pages/info/components/loserinfo.dart';
import 'package:crazy_tweets_2/frontend/pages/info/components/swiper.dart';
import 'package:crazy_tweets_2/models/info_model.dart';
import 'package:crazy_tweets_2/providers/info_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final infoStateProvider =
    StateNotifierProvider<InfoProvider, Info>((ref) => InfoProvider());

class InfoPage extends HookWidget {
  const InfoPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final infoProvider = useProvider(infoStateProvider);
    final CarouselController _controller = CarouselController();
    final List<Widget> sliderList = [
      SwipeSlider(),
      ChooseLose(),
      LoserSlider(),
      Begin()
    ];

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Container(
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: CarouselSlider(
                      carouselController: _controller,
                      options: CarouselOptions(
                          height: MediaQuery.of(context).size.height - 50,
                          enableInfiniteScroll: false,
                          viewportFraction: 1.0,
                          enlargeCenterPage: false,
                          onPageChanged: (index, reason) {
                            context.read(infoStateProvider.notifier).setPage(index);
                          }),
                      items: sliderList),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sliderList.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.black
                                        : Colors.white)
                                    .withOpacity(infoProvider.page == entry.key
                                        ? 0.9
                                        : 0.4)),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
