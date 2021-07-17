import 'dart:async';
import 'dart:ui';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:crazy_tweets_2/providers/player_provider.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';

class FirebaseDatabaseService {
  FirebaseDatabaseService(this.database, this.playerProvider);
  final FirebaseDatabase database;
  final PlayerProvider playerProvider;

  static bool matchExists;
  static bool playerExists;
  static String _lobbyCode = randomAlpha(6).toUpperCase();

  String generateNewLobbyCode() {
    return randomAlpha(6).toUpperCase();
  }

  void createLobby(
      BuildContext context, String player, String leaderUid) async {
    List<List<dynamic>> _playersCreate = [];
    List<dynamic> playerStats = [player, "0"];

    //check if lobby exists already
    await database
        .reference()
        .child("games")
        .once()
        .then((value) => {
              if (value.value == null)
                {matchExists = false}
              else
                {
                  value.value[_lobbyCode] == null
                      ? matchExists = false
                      : matchExists = true
                }
            })
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => {print(error)});
    //
    // start trying to create lobby and push to firebase
    if (matchExists) {
      _lobbyCode = generateNewLobbyCode();
      _playersCreate.add(playerStats);
      await database
          .reference()
          .child("games")
          .child(_lobbyCode)
          .set({
            "players": _playersCreate,
            "playersUid": [leaderUid],
            "partyLeader": player,
            "partyLeaderUid": leaderUid,
            "gameStarted": false,
            "gameAlive": true,
            "joinable": true,
            "turns": 0,
            "startTime": "",
            "loser": [""],
            "playersDone": [""]
          })
          .then((value) => {playerProvider.createdLobby(_lobbyCode, player)})
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((onError) => print(onError.toString()));
    } else {
      _playersCreate.add(playerStats);
      await database
          .reference()
          .child("games")
          .child(_lobbyCode)
          .set({
            "players": _playersCreate,
            "playersUid": [leaderUid],
            "partyLeader": player,
            "partyLeaderUid": leaderUid,
            "gameStarted": false,
            "gameAlive": true,
            "joinable": true,
            "turns": 0,
            "startTime": "",
            "loser": [""],
            "playersDone": [""]
          })
          // .then((value) => state = Player(_lobbyCode, player, true, true))
          .then((value) => {playerProvider.createdLobby(_lobbyCode, player)})
          // ignore: return_of_invalid_type_from_catch_error
          .catchError((onError) => print(onError.toString()));
    }
    //
  }

  void joinLobby(BuildContext context, String player, String lobbyCode,
      String playerUid) async {
    List<List<dynamic>> _playersJoin;
    List<dynamic> playerStats = [player, "0"];
    List<dynamic> _playersUids;

    await database
        .reference()
        .child("games")
        .once()
        .then((value) async => {
              //check if lobby exists
              if (value.value == null)
                {matchExists = false}
              else
                {
                  value.value[lobbyCode] == null
                      ? matchExists = false
                      : matchExists = true
                },
              // ensure player doesnt already exist
              if (matchExists)
                {
                  playerExists =
                      value.value[lobbyCode]['players'].contains(player),
                  if (!playerExists)
                    {
                      _playersJoin = [
                        ...value.value[lobbyCode]['players'],
                        playerStats
                      ],
                      _playersUids = [
                        ...value.value[lobbyCode]['playersUid'],
                        playerUid
                      ],
                      await database
                          .reference()
                          .child("games")
                          .child(lobbyCode)
                          .update({
                            "players": _playersJoin,
                            "playersUid": _playersUids
                          })
                          .then((value) async => {
                                playerProvider.joinedLobby(lobbyCode, player),
                                await Navigator.of(context).pushNamed(
                                  AppRoutes.lobbyPage,
                                )
                              })
                          // ignore: return_of_invalid_type_from_catch_error
                          .catchError((onError) => print(onError.toString()))
                    }
                  else
                    {
                      showTheDialog(context,
                          "Oops! Player Name Already Exists. Try Another Name.")
                    }
                }
              else
                {
                  showTheDialog(context,
                      "Oops! Lobby Doesn't Exist. Check Lobby Entry And Make Sure It's Correct.")
                }
            })
        // ignore: return_of_invalid_type_from_catch_error
        .catchError((error) => {print(error)});
  }

  void showTheDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            message,
            style: Theme.of(context).accentTextTheme.headline1,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Stream<Lobby> lobbyStream({@required String lobby}) =>
      database.reference().child("games").child(lobby).onValue.map((event) {
        return Lobby.fromMap(event.snapshot.value);
      });

  Future<Lobby> getLobby({@required String lobby}) async => await database
          .reference()
          .child("games")
          .child(lobby)
          .once()
          .then((DataSnapshot snapshot) {
        return Lobby.fromMap(snapshot.value);
      });

  Future<void> deletePlayer(
      {@required String lobby, @required String player, @required String uid}) async {
    Lobby playersLobby;
    List<dynamic> players;
    List<dynamic> playersUid;

    await database
        .reference()
        .child("games")
        .child(lobby)
        .once()
        .then((DataSnapshot snapshot) {
      playersLobby = Lobby.fromMap(snapshot.value);
      players = new List<dynamic>.from(playersLobby.players);
      playersUid = new List<dynamic>.from(playersLobby.players);
    });
    players.removeWhere((element) => element[0] == player);
    playersUid.removeWhere((uid) => uid == player);

    await database
        .reference()
        .child("games")
        .child(lobby)
        .update({'players': players});
  }

  Future<void> deactivateLobby({@required String lobby}) async {
    // await database.reference().child("games").child(lobby).update({'gameAlive': false});
    await database.reference().child("games").child(lobby).remove();
  }

  Future<void> restartLobby({@required String lobby}) async {
    await database
        .reference()
        .child("games")
        .child(lobby)
        .update({'gameStarted': false, 'joinable': true});
  }

  Future<void> updatePlayerName(
      {@required String lobby,
      @required String oldplayer,
      @required String newplayer}) async {
    Lobby playersLobby;
    List<List<dynamic>> players;
    String partyLeader;

    await database
        .reference()
        .child("games")
        .child(lobby)
        .once()
        .then((DataSnapshot snapshot) {
      playersLobby = Lobby.fromMap(snapshot.value);
      players = new List<List<dynamic>>.from(playersLobby.players);
      partyLeader = playersLobby.partyLeader;
    });

    players.removeWhere((player) => player[0] == oldplayer);
    players.add([newplayer, "0"]);
    playerProvider.updatePlayerName(newplayer);

    if (partyLeader == oldplayer) {
      await database
          .reference()
          .child("games")
          .child(lobby)
          .update({'players': players, 'partyLeader': newplayer});
    } else {
      await database
          .reference()
          .child("games")
          .child(lobby)
          .update({'players': players});
    }
  }

  Future<void> updatePlayerStats(
      {@required String lobby,
      @required String playerName,
      @required String stats}) async {
    Lobby playersLobby;
    List<List<dynamic>> players;
    List<dynamic> playersDone;

    await database
        .reference()
        .child("games")
        .child(lobby)
        .once()
        .then((DataSnapshot snapshot) {
      playersLobby = Lobby.fromMap(snapshot.value);
      players = new List<List<dynamic>>.from(playersLobby.players);
      playersDone = new List<dynamic>.from(playersLobby.playersDone);
    }).catchError((error) => {print(error)});

    players.removeWhere((player) => player[0] == playerName);
    playersDone.removeWhere((playerCheck) => playerCheck == "");
    players.add([playerName, stats]);
    playersDone.add(playerName);

    await database
        .reference()
        .child("games")
        .child(lobby)
        .update({'players': players, 'playersDone': playersDone});
  }

  void updateLobbyAfterStart({@required String lobby}) async {
    await database.reference().child("games").child(lobby).update({
      'gameStarted': true,
      'joinable': false,
      'startTime': DateTime.now().toString()
    });
  }

  Future<void> updateLoser(
      {@required String lobby, @required String loser}) async {
    Lobby playersLobby;
    List<dynamic> loserList;
    await database
        .reference()
        .child("games")
        .child(lobby)
        .once()
        .then((DataSnapshot snapshot) {
      playersLobby = Lobby.fromMap(snapshot.value);
      loserList = new List<dynamic>.from(playersLobby.loser);
    }).catchError((error) => {print(error)});

    loserList = [...playersLobby.loser, loser];
    loserList.removeWhere((player) => player == "");

    await database
        .reference()
        .child("games")
        .child(lobby)
        .update({'loser': loserList}).catchError((error) => {print(error)});
  }

  Future<void> restartGame({@required String lobby}) async {
    Lobby playersLobby;
    List<dynamic> resetPlayersList;
    await database
        .reference()
        .child("games")
        .child(lobby)
        .once()
        .then((DataSnapshot snapshot) {
      playersLobby = Lobby.fromMap(snapshot.value);
      resetPlayersList = new List<dynamic>.from(playersLobby.players);
    }).catchError((error) => {print(error)});

    resetPlayersList.map((player) => [player[0], 0]);

    await database.reference().child("games").child(lobby).update({
      "players": resetPlayersList,
      "partyLeader": playersLobby.partyLeader,
      "partyLeaderUid": playersLobby.partyLeaderUid,
      "gameStarted": false,
      "gameAlive": true,
      "joinable": true,
      "turns": 0,
      "startTime": "",
      "loser": [""]
    }).catchError((error) => {print(error)});
  }

  // CRUD operations - implementations omitted for simplicity
  // Future<void> setJob(Job job) {  }
  // Future<void> deleteJob(Job job) {  }
  // Stream<Job> jobStream({@required String jobId}) {  }
  // Stream<List<Job>> jobsStream() { }
  // Future<void> setEntry(Entry entry) {  }
  // Future<void> deleteEntry(Entry entry) {  }
  // Stream<List<String>> playersStream({String lobby}) { }
}
