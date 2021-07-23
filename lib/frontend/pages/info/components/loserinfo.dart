import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoserSlider extends HookWidget {
  const LoserSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              child: Image.asset(
            'assets/images/loser.gif',
            width: 300,
            height: 450,
            fit: BoxFit.contain,
          )),
          Container(
            height: 60,
            child: Text(
              'The loser will be shown on everyones screen and has to choose "Drink" or "Dare".',
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
                    "DRINK:",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "Gives you ",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "random drink.",
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
                    "DARE:",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "Complete the dare ",
                    style: Theme.of(context)
                        .accentTextTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Text(
                    "to not drink.",
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
