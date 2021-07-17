import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatorStartButton extends HookWidget {
  const CreatorStartButton(
      {Key key, @required this.playerProvider, @required this.deletePlayer})
      : super(key: key);

  final Player playerProvider;
  final Function deletePlayer;

  @override
  Widget build(BuildContext context) {
    final setTweets = useProvider(playerFutureSetTweets);

    void showTheDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'WAIT',
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            content: Text(
              "As lobby GOD once you start YOUR game no one else can join the lobby. So are you sure everyone that wants to play has joined?",
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () async => {
                  context
                      .read(firebaseDatabaseServiceProvider)
                      .updateLobbyAfterStart(lobby: playerProvider.lobbyCode),
                  await Navigator.of(context)
                      .popAndPushNamed(AppRoutes.gamePage)
                },
              ),
              TextButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return setTweets.when(data: (data) {
      return Container(
        height: 60,
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColorDark,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: playerProvider.isCreator
                ? () => showTheDialog(context)
                : () async => {
                      await Navigator.of(context)
                          .popAndPushNamed(AppRoutes.gamePage)
                    },
            child: Text(
              "Start Game",
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
        ),
      );
    }, loading: () {
      return Container(
        height: 60,
        child: Center(
            child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 20.0,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context).primaryTextTheme.headline2,
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText('Finding Sick Tweets'),
              ],
              repeatForever: true,
            ),
          ),
        )),
      );
    }, error: (e, _) {
      print(e);
      return Container(
        height: 60,
        child: Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(30.0),
          color: Theme.of(context).primaryColorDark,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width,
            padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            onPressed: () async => {
              await deletePlayer(playerProvider.lobbyCode),
              context.read(playerStateProvider).reset(),
              Navigator.of(context).popUntil((route) => route.isFirst)
            },
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 20.0,
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.headline2,
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText('Shits Broken, My B! 🤷'),
                    RotateAnimatedText('Return Home and'),
                    RotateAnimatedText('Join Lobby Again'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
