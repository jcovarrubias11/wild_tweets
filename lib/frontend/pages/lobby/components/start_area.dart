import 'package:crazy_tweets_2/frontend/pages/lobby/components/creator_start_button.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/components/non_leader_message.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StartArea extends HookWidget {
  const StartArea({Key key, @required this.lobby, @required this.deletePlayer})
      : super(key: key);

  final Lobby lobby;
  final Function deletePlayer;

  @override
  Widget build(BuildContext context) {
    final playerProvider = useProvider(playerStateProvider.state);

    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: CreatorStartButton(
            playerProvider: playerProvider, deletePlayer: deletePlayer));
  }
}
