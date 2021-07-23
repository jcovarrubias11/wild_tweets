import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Begin extends HookWidget {
  const Begin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            child: Image.asset(
          'assets/images/dab.gif',
          width: 300,
          height: 450,
          fit: BoxFit.contain,
        )),
        Container(
          height: 60,
          child: Text(
            "Good Luck, I believe in you.",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .accentTextTheme
                .headline1
                .copyWith(fontSize: 24.0),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5.0),
          height: 60,
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(30.0),
            color: Theme.of(context).primaryColorDark,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              onPressed: () async => {
                await Navigator.of(context).popAndPushNamed(AppRoutes.gamePage)
              },
              child: Text(
                "Start Game",
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        )
      ],
    );
  }
}
