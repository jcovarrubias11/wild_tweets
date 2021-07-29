import 'package:crazy_tweets_2/frontend/pages/game/components/null_lobby.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/components/list_of_players.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/components/start_area.dart';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:crazy_tweets_2/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

//Lobby Stream From Firebase Realtime Database
final lobbyStreamProvider = StreamProvider.autoDispose.family<Lobby, String>(
    (ref, lobby) => FirebaseDatabaseService(
            ref.watch(databaseProvider), ref.watch(playerStateProvider.notifier))
        .lobbyStream(lobby: lobby));

final lobbyGetFutureProvider = FutureProvider.autoDispose.family<Lobby, String>(
    (ref, lobby) => FirebaseDatabaseService(
            ref.watch(databaseProvider), ref.watch(playerStateProvider.notifier))
        .getLobby(lobby: lobby));

final playerFutureSetTweets = FutureProvider.autoDispose<void>(
    (ref) => ref.watch(playerStateProvider.notifier).getTweets());

class LobbyPage extends HookWidget {
  const LobbyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(firebaseAuthProvider);
    final playerProvider = useProvider(playerStateProvider);
    final databaseService = useProvider(firebaseDatabaseServiceProvider);
    final lobbyStream =
        useProvider(lobbyStreamProvider(playerProvider.lobbyCode));

    Future<void> _deletePlayer(String lobby) async {
      try {
        await databaseService.deletePlayer(
            lobby: lobby,
            player: playerProvider.player,
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
              playerProvider.isCreator
                  ? "If you leave the lobby will be assassinated and everyone will be kicked. Are you sure you wanna go back to the home page?"
                  : "Are you sure you wanna go back to the home page?",
              style: Theme.of(context).accentTextTheme.headline1,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text("Yes"),
                    onPressed: playerProvider.isCreator
                        ? () async {
                            await _deactivateLobby(playerProvider.lobbyCode);
                            context.read(playerStateProvider.notifier).reset();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          }
                        : () async {
                            await _deletePlayer(playerProvider.lobbyCode);
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
              ),
            ],
          );
        },
      );
    }

    return lobbyStream.when(data: (lobby) {
      if (lobby == null) {
        print("lobby null");
        return NullLobby();
      } else if (lobby.gameAlive) {
        //START FOR EVERYONE

        // Future.delayed(Duration.zero, () async {
        //   if (lobby.gameStarted) {
        //     await Navigator.of(context).popAndPushNamed(AppRoutes.gamePage);
        //   }
        // });

        return WillPopScope(
          onWillPop: () => showDialog<bool>(
            context: context,
            builder: (c) => AlertDialog(
              title: Text(
                'WAIT',
                style: Theme.of(context).accentTextTheme.headline1,
                textAlign: TextAlign.center,
              ),
              content: Text(
                playerProvider.isCreator
                    ? "If you leave the lobby will be assassinated and everyone will be kicked. Are you sure you wanna go back to the home page?"
                    : "Are you sure you wanna go back to the home page?",
                style: Theme.of(context).accentTextTheme.headline1,
                textAlign: TextAlign.center,
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: new Text("Yes"),
                      onPressed: playerProvider.isCreator
                          ? () async {
                              await _deactivateLobby(playerProvider.lobbyCode);
                              context.read(playerStateProvider.notifier).reset();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            }
                          : () async {
                              await _deletePlayer(playerProvider.lobbyCode);
                              context.read(playerStateProvider.notifier).reset();
                              Navigator.of(context)
                                  .popUntil((route) => route.isFirst);
                            },
                    ),
                    TextButton(
                      child: new Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color.fromRGBO(3, 9, 23, 1),
            body: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Lobby Code:",
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            Text(
                              playerProvider.lobbyCode,
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.headline1,
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            StartArea(
                                lobby: lobby,
                                deletePlayer: _deletePlayer),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              "Players",
                              textAlign: TextAlign.center,
                              style:
                                  Theme.of(context).primaryTextTheme.headline2,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        )),
                    Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        color: Theme.of(context).accentColor,
                        child: LobbyList(lobby))
                  ],
                )),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniStartTop,
            floatingActionButton: FloatingActionButton(
              onPressed: () async => {showTheDialog(context)},
              tooltip: 'Back Home',
              child: Icon(Icons.arrow_back),
              elevation: 1.0,
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      } else {
        print("lobby else");
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Container(),
        );
      }
    }, loading: () {
      print("Loading");
      return Container();
    }, error: (e, __) {
      print(e);
      return NullLobby();
    });
  }

  Container buildNullLobby(BuildContext context) {
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoutes.homePage, (Route<dynamic> route) => false);
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
