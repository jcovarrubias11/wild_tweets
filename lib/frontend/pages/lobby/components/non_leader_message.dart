import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NonLobbyLeader extends HookWidget {
  const NonLobbyLeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playerProvider = useProvider(playerStateProvider.state);
    final lobbyFuture =
        useProvider(lobbyGetFutureProvider(playerProvider.lobbyCode));

    return lobbyFuture.when(data: (lobby) {
      return Text(
        "Waiting For ${lobby.partyLeader.toUpperCase()} To Start. . .",
        style: Theme.of(context).accentTextTheme.headline1,
      );
    }, loading: () {
      print("Loading");
      return Container();
    }, error: (e, __) {
      print(e);
      return Container();
    });
  }
}
