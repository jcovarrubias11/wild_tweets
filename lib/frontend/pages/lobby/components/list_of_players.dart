import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:crazy_tweets_2/constants/pics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_string/random_string.dart';

class LobbyList extends HookWidget {
  const LobbyList(this.lobby, {Key key}) : super(key: key);

  final Lobby lobby;

  @override
  Widget build(BuildContext context) {
    final playerProvider = useProvider(playerStateProvider);

    return Container(
        height: MediaQuery.of(context).size.height,
        child: listOfPlayers(lobby.players, playerProvider));
  }
}

Widget listOfPlayers(List<dynamic> players, Player playerState) {
  return ListView.builder(
    padding: EdgeInsets.all(6),
    itemCount: players.length,
    itemBuilder: (BuildContext context, int index) {
      List<dynamic> item = players[index];
      return Card(
        color: Colors.white.withOpacity(0.5),
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 125,
                  width: 110,
                  padding:
                      EdgeInsets.only(left: 0, top: 10, bottom: 70, right: 0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: AssetImage(Pics.pic1[randomBetween(0, 5)]),
                          fit: BoxFit.contain)),
                  child: Container()),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item[0],
                    style: Theme.of(context).accentTextTheme.headline1,
                  ),
                ],
              ),
              Container(
                height: 125,
                width: 60,
                child: playerState.player == item[0]
                    ? IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () async => {
                          await Navigator.of(context)
                              .pushNamed(AppRoutes.editPage)
                        },
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      );
    },
  );
}
