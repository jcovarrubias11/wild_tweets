import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SwipeSlider extends HookWidget {
  const SwipeSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: Image.asset(
            'assets/images/swipe.gif',
            width: 300,
            height: 450,
            fit: BoxFit.contain,
          )),
          Container(
            height: 60,
            child: Text(
              "You will be presented with 25 tweets. You have 2 minutes to decipher which " +
                  "ones are real and which aren't. ",
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .accentTextTheme
                  .headline1
                  .copyWith(fontSize: 18.0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "SWIPE LEFT:",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "Fake Tweets",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "SWIPE RIGHT:",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "Real Tweets",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
