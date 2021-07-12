import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crazy_tweets_2/frontend/pages/game/game.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/game_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/constants/pics.dart';
import 'package:crazy_tweets_2/constants/drinks.dart';
import 'package:crazy_tweets_2/constants/dares.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_string/random_string.dart';

class Leaderboard extends HookWidget {
  const Leaderboard(this.player, this.finalLoser, {Key key}) : super(key: key);

  final Player player;
  final String finalLoser;

  @override
  Widget build(BuildContext context) {
    final lobbyStream = useProvider(lobbyStreamProvider(player.lobbyCode));

    return lobbyStream.when(data: (lobby) {
      if (lobby == null) {
        print("Lobby Null");
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (lobby.gameAlive) {
        return Container(
            height: MediaQuery.of(context).size.height,
            child: LeaderboardList(player, lobby.players, finalLoser,
                (lobby.playersDone.length == lobby.players.length)));
      } else {
        return Container();
      }
    }, loading: () {
      print("Loading");
      return Center(
        child: CircularProgressIndicator(),
      );
    }, error: (e, __) {
      print(e);
      return Container();
    });
  }
}

class LeaderboardList extends HookWidget {
  const LeaderboardList(
    this.player,
    this.players,
    this.finalLoser,
    this.playersDone, {
    Key key,
  }) : super(key: key);

  final List<dynamic> players;
  final Player player;
  final String finalLoser;
  final bool playersDone;

  @override
  Widget build(BuildContext context) {
    final gameState = useProvider(gameStateProvider.state);

    Timer startTimeout() {
      return Timer(
          Duration(seconds: 30),
          () => {
                context.read(gameStateProvider).updateGameOver(true),
              });
    }

    if (playersDone) {
      startTimeout();
    }

    players.sort((a, b) {
      return int.parse(b[1]).compareTo(int.parse(a[1]));
    });

    return !gameState.gameOver
        ? ListView.builder(
            padding: EdgeInsets.all(6),
            itemCount: playersDone ? players.length : 1,
            itemBuilder: (BuildContext context, int index) {
              List<dynamic> item = players[index];
              return GestureDetector(
                onTap: playersDone
                    ? index == 0
                        ? null
                        : () => {
                              context
                                  .read(gameStateProvider)
                                  .updateNameVoted(item[0]),
                            }
                    : () => {},
                child: playersDone
                    ? playersDoneBuildCard(gameState, item, index, context)
                    : playersNotDoneBuildCard(context),
              );
            },
          )
        : Container(
            child: Column(
            children: [
              SizedBox(height: 20),
              DefaultTextStyle(
                style: Theme.of(context).accentTextTheme.headline1,
                child: AnimatedTextKit(
                  animatedTexts: finalLoser == player.player
                      ? [
                          TypewriterAnimatedText("You've Been Impeached!"),
                          TypewriterAnimatedText("Choose Your Punishment..."),
                        ]
                      : [
                          TypewriterAnimatedText(
                              "${finalLoser} Has Been Impeached!"),
                        ],
                  isRepeatingAnimation:
                      finalLoser == player.player ? true : false,
                ),
              ),
              Image.asset(
                "assets/images/TrumpJailbird.png",
                height: MediaQuery.of(context).size.height / 3,
              ),
              Center(
                child: finalLoser == player.player
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme.of(context).primaryColorDark,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2.5,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () => showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (c) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: Text(
                                    'DRINK',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2,
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Text(
                                    drinks[
                                        randomBetween(0, (drinks.length - 1))],
                                    style: Theme.of(context)
                                        .accentTextTheme
                                        .headline1,
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Theme.of(context).accentColor,
                                        child: MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          onPressed: () async {
                                            // Navigator.of(context).pop();
                                            context
                                                .read(playerStateProvider)
                                                .reset();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          child: Text(
                                            "Back Home",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30)
                                  ],
                                ),
                              ),
                              child: Text(
                                "Drink",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              "or",
                              style: Theme.of(context).textTheme.headline2,
                            ),
                          ),
                          Material(
                            elevation: 5.0,
                            borderRadius: BorderRadius.circular(30.0),
                            color: Theme.of(context).primaryColorDark,
                            child: MaterialButton(
                              minWidth: MediaQuery.of(context).size.width / 2.5,
                              padding:
                                  EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                              onPressed: () => showDialog<bool>(
                                context: context,
                                barrierDismissible: false,
                                builder: (c) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(20.0)),
                                  title: Text(
                                    'DARE',
                                    style: Theme.of(context)
                                        .primaryTextTheme
                                        .headline2
                                        .copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight),
                                    textAlign: TextAlign.center,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        dares[randomBetween(
                                            0, (dares.length - 1))],
                                        style: Theme.of(context)
                                            .accentTextTheme
                                            .headline1,
                                        textAlign: TextAlign.center,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Text(
                                          "if you decline or fail:",
                                          style: Theme.of(context)
                                              .accentTextTheme
                                              .headline1
                                              .copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColorLight),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Text(
                                        drinks[randomBetween(
                                            0, (drinks.length - 1))],
                                        style: Theme.of(context)
                                            .accentTextTheme
                                            .headline1,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Center(
                                      child: Material(
                                        elevation: 5.0,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                        color: Theme.of(context).accentColor,
                                        child: MaterialButton(
                                          minWidth: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          padding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          onPressed: () async {
                                            // Navigator.of(context).pop();
                                            context
                                                .read(playerStateProvider)
                                                .reset();
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          child: Text(
                                            "Back Home",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30)
                                  ],
                                ),
                              ),
                              child: Text(
                                "Dare",
                                style: Theme.of(context).textTheme.headline2,
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
              )
            ],
          ));
  }

  Card playersDoneBuildCard(
      Game gameState, List<dynamic> item, int index, BuildContext context) {
    return Card(
      color: gameState.nameVoted == item[0]
          ? Colors.white.withOpacity(0.15)
          : Colors.white.withOpacity(0.5),
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
                        image: index == 0
                            ? AssetImage(
                                "assets/images/trump_tairedOfWinning_600px-1.png",
                              )
                            : AssetImage(Pics.pic1[index % 6]),
                        fit: BoxFit.contain)),
                child: Container()),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DefaultTextStyle(
                  style: Theme.of(context).accentTextTheme.headline1,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(item[0]),
                    ],
                    isRepeatingAnimation: true,
                  ),
                ),
              ],
            ),
            Container(
              height: 125,
              width: 60,
              child: Center(
                child: Text(
                  item[1],
                  style: Theme.of(context).accentTextTheme.headline1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card playersNotDoneBuildCard(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.5),
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  "assets/images/69312-neeson-caricature-celebrity-draw-mark-zuckerberg-liam-thumb.png",
                  fit: BoxFit.contain,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
