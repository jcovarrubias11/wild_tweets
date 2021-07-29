import 'package:crazy_tweets_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NullLobby extends HookWidget {
  const NullLobby({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Oops, the lobby was assassinated...",
                style: Theme.of(context).accentTextTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Text(
                "Return to home page.",
                style: Theme.of(context).accentTextTheme.headline1,
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () async {
                      context.read(playerStateProvider.notifier).reset();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text(
                      "OK",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
              ),
            ]),
      )),
    );
  }
}
