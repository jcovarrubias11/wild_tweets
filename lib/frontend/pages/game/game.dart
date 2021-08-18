import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crazy_tweets_2/frontend/pages/ad/ad.dart';
import 'package:crazy_tweets_2/frontend/pages/game/components/game_timer.dart';
import 'package:crazy_tweets_2/frontend/pages/game/components/leaderboard.dart';
import 'package:crazy_tweets_2/frontend/pages/game/components/null_lobby.dart';
import 'package:crazy_tweets_2/frontend/pages/game/components/tweet_list.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/game_model.dart';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/providers/game_provider.dart';
import 'package:crazy_tweets_2/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_string/random_string.dart';

final gameStateProvider = StateNotifierProvider.autoDispose<GameProvider, Game>(
    (ref) => GameProvider());

final timerStateProvider =
    StateNotifierProvider.autoDispose<TimerNotifier, TimerModel>((ref) =>
        TimerNotifier(
            ref.watch(databaseProvider), ref.watch(playerStateProvider)));

class GamePage extends HookWidget {
  const GamePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(firebaseAuthProvider);
    final playerState = useProvider(playerStateProvider);
    final lobbyStream = useProvider(lobbyStreamProvider(playerState.lobbyCode));
    final gameState = useProvider(gameStateProvider);
    final databaseService = useProvider(firebaseDatabaseServiceProvider);

    Future<void> _deletePlayer(String lobby) async {
      try {
        await databaseService.deletePlayer(
            lobby: lobby,
            player: playerState.player,
            uid: auth.currentUser.uid);
      } catch (e) {
        print(e);
      }
    }

    Future<void> _deactivateLobby(String lobby) async {
      try {
        await databaseService.deactivateLobby(lobby: lobby);
      } catch (e) {
        print(e);
      }
    }

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
              playerState.isCreator
                  ? "If you leave the lobby will be assassinated and everyone will be kicked. Are you sure you wanna go back to the home page?"
                  : "Are you sure you wanna go back to the home page?",
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: playerState.isCreator
                    ? () async {
                        await _deactivateLobby(playerState.lobbyCode);
                        context.read(playerStateProvider.notifier).reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    : () async {
                        await _deletePlayer(playerState.lobbyCode);
                        context.read(playerStateProvider.notifier).reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
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

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'WAIT',
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            content: Text(
              playerState.isCreator
                  ? "If you leave the lobby will be assassinated and everyone will be kicked. Are you sure you wanna go back to the home page?"
                  : "Are you sure you wanna go back to the home page?",
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: playerState.isCreator
                    ? () async {
                        await _deactivateLobby(playerState.lobbyCode);
                        context.read(playerStateProvider.notifier).reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }
                    : () async {
                        await _deletePlayer(playerState.lobbyCode);
                        context.read(playerStateProvider.notifier).reset();
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
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
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: lobbyStream.when(
                  data: (lobby) {
                    if (lobby == null) {
                      print("Lobby Null");
                      return NullLobby();
                    } else if (lobby.gameAlive) {
                      return GameView(
                          playerState: playerState,
                          playersDone: (lobby.playersDone.length ==
                              lobby.players.length),
                          lobby: lobby);
                    } else {
                      return NullLobby();
                    }
                  },
                  loading: () => CircularProgressIndicator(),
                  error: (e, __) {
                    print(e);
                    return Container();
                  }),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        floatingActionButton: gameState.isGameLive
            ? FloatingActionButton(
                onPressed: () async => {showTheDialog(context)},
                tooltip: 'Back Home',
                child: Icon(Icons.arrow_back),
                elevation: 0.0,
                backgroundColor: Colors.transparent,
              )
            : Container(),
      ),
    );
  }
}

class GameView extends HookWidget {
  const GameView(
      {Key key,
      @required this.playerState,
      @required this.playersDone,
      @required this.lobby})
      : super(key: key);

  final Player playerState;
  final bool playersDone;
  final Lobby lobby;

  @override
  Widget build(BuildContext context) {
    final timerState = useProvider(timerStateProvider);
    final gameState = useProvider(gameStateProvider);

    List<dynamic> loserCount = [];
    int maxVotes;
    int randomLoserIfTied;
    String finalLoser;

    for (var i = 0; i < lobby.players.length; i++) {
      int count = 0;
      for (var j = 0; j < lobby.loser.length; j++) {
        if (lobby.players[i][0] == lobby.loser[j]) {
          count = count + 1;
        }
      }
      loserCount.add([lobby.players[i][0], count]);
    }

    maxVotes = loserCount.map<int>((e) => e[1]).reduce(max);

    loserCount.removeWhere((element) => element[1] != maxVotes);

    if (loserCount.length != null) {
      randomLoserIfTied = randomBetween(0, (loserCount.length - 1));
      finalLoser = loserCount[randomLoserIfTied][0].toString();
    } else {
      randomLoserIfTied = randomBetween(0, (lobby.players.length - 1));
      finalLoser = lobby.players[randomLoserIfTied][0].toString();
    }

    var impeachButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColorDark,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: gameState.nameVoted != ""
            ? () async {
                await context.read(firebaseDatabaseServiceProvider).updateLoser(
                    lobby: playerState.lobbyCode, loser: gameState.nameVoted);
                context
                    .read(gameStateProvider.notifier)
                    .updatesubmittedName(true);
              }
            : () => {},
        child: !playersDone
            ? DefaultTextStyle(
                style: Theme.of(context).textTheme.headline2,
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText("Waiting For Everyone 😒..."),
                  ],
                  isRepeatingAnimation: true,
                  totalRepeatCount: 1,
                ),
              )
            : gameState.nameVoted != ""
                ? Text(
                    "Impeach ${gameState.nameVoted}?",
                    style: Theme.of(context).textTheme.headline2,
                  )
                : Text(
                    "Choose a player to impeach...",
                    style: Theme.of(context).textTheme.headline2,
                  ),
      ),
    );

    var impeachVotedButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColorDark.withOpacity(0.4),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: null,
        child: Text(
          "Voted for ${gameState.nameVoted}!",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    var backHomeButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColorDark,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () => {
          context.read(playerStateProvider.notifier).reset(),
          Navigator.of(context).popUntil((route) => route.isFirst)
        },
        child: Text(
          "Back Home",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    // var restartButton = Material(
    //   elevation: 5.0,
    //   borderRadius: BorderRadius.circular(30.0),
    //   color: Theme.of(context).primaryColorDark,
    //   child: MaterialButton(
    //     minWidth: MediaQuery.of(context).size.width / 2.5,
    //     padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
    //     onPressed: () =>
    //         {Navigator.of(context).popUntil((route) => route.isFirst)},
    //     child: Text(
    //       "Restart",
    //       style: Theme.of(context).textTheme.headline2,
    //     ),
    //   ),
    // );

    return Column(
      children: <Widget>[
        (timerState.timeLeftString != "00:00" && gameState.isGameLive)
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width * .20,
                          width: MediaQuery.of(context).size.width * .20,
                          //TIMER FOR EACH QUESTION: STREAM
                          child: Timer(playerState),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 6,
                          width: MediaQuery.of(context).size.width * .80,
                          child: Center(
                            child: DefaultTextStyle(
                              style:
                                  Theme.of(context).accentTextTheme.headline1,
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  TypewriterAnimatedText(
                                      'Guess The Real Trump Tweets'),
                                ],
                                totalRepeatCount: 1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        gameState.gameOver
                            ? Container(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width * .60,
                                child: Center(
                                    child: DefaultTextStyle(
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2,
                                  child: finalLoser == playerState.player
                                      ? AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText('Game Over'),
                                          ],
                                          isRepeatingAnimation: false,
                                        )
                                      : AnimatedTextKit(
                                          animatedTexts: [
                                            TypewriterAnimatedText('Game Over'),
                                            TypewriterAnimatedText(
                                                'Play Again!'),
                                          ],
                                          isRepeatingAnimation: false,
                                        ),
                                )),
                              )
                            : Container(
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width * .60,
                                child: Center(
                                    child: Text(
                                  "Leaderboard",
                                  style: Theme.of(context)
                                      .primaryTextTheme
                                      .headline2,
                                )),
                              ),
                        gameState.nameVoted != ""
                            ? Container(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: gameState.gameOver
                                        ? finalLoser != playerState.player
                                            ? backHomeButton
                                            : Container()
                                        : gameState.submittedName
                                            ? impeachVotedButton
                                            : impeachButton),
                              )
                            : gameState.isGameLive
                                ? Container(
                                    child: Center(
                                        child: Text(
                                    "Choose a player to impeach...",
                                    style: Theme.of(context)
                                        .accentTextTheme
                                        .headline1,
                                  )))
                                : Container(
                                    child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, right: 20.0),
                                        child: gameState.gameOver
                                            ? finalLoser != playerState.player
                                                ? backHomeButton
                                                : Container()
                                            : gameState.submittedName
                                                ? impeachVotedButton
                                                : impeachButton),
                                  )
                      ],
                    ),
                  ],
                )),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 1.75,
          color: Theme.of(context).accentColor,
          //QUESTION AREA FOR EACH TWEET: FUTURE
          child: (timerState.timeLeftString != "00:00" && gameState.isGameLive)
              ? TweetList(playerState)
              : Leaderboard(playerState, finalLoser),
        ),
        //AD AREA
        Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 11,
            color: Theme.of(context).accentColor,
            child: Center(child: AdBanner())),
      ],
    );
  }
}
