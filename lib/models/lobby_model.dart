import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
class Lobby extends Equatable {
  const Lobby(
      {@required this.players,
      @required this.playersUid,
      @required this.partyLeader,
      @required this.partyLeaderUid,
      @required this.startTime,
      @required this.gameStarted,
      @required this.gameAlive,
      @required this.joinable,
      @required this.turns,
      @required this.loser,
      @required this.playersDone});
  final List<dynamic> players;
  final List<dynamic> playersUid;
  final String partyLeader;
  final String partyLeaderUid;
  final String startTime;
  final bool gameAlive;
  final bool gameStarted;
  final bool joinable;
  final int turns;
  final List<dynamic> loser;
  final List<dynamic> playersDone;

  @override
  List<Object> get props => [
        players,
        playersUid,
        partyLeader,
        partyLeaderUid,
        startTime,
        gameStarted,
        gameAlive,
        joinable,
        turns,
        loser,
        playersDone
      ];

  @override
  bool get stringify => true;

  factory Lobby.fromMap(
    Map<dynamic, dynamic> data,
  ) {
    if (data == null) {
      return null;
    }
    final players = data['players'] as List<dynamic>;
    final playersUid = data['playersUid'] as List<dynamic>;
    final partyLeader = data['partyLeader'] as String;
    final partyLeaderUid = data['partyLeaderUid'] as String;
    final startTime = data['startTime'] as String;
    if (partyLeader == null) {
      return null;
    }
    final gameStarted = data['gameStarted'] as bool;
    final joinable = data['joinable'] as bool;
    final gameAlive = data['gameAlive'] as bool;
    final turns = data['turns'] as int;
    final loser = data['loser'] as List<dynamic>;
    final playersDone = data['playersDone'] as List<dynamic>;

    return Lobby(
        players: players,
        playersUid: playersUid,
        gameStarted: gameStarted,
        joinable: joinable,
        gameAlive: gameAlive,
        partyLeader: partyLeader,
        partyLeaderUid: partyLeaderUid,
        startTime: startTime,
        turns: turns,
        loser: loser,
        playersDone: playersDone);
  }

  Map<dynamic, dynamic> toMap() {
    return {
      'players': players,
      'playersUid': playersUid,
      'gameStarted': gameStarted,
      'joinable': joinable,
      "gameAlive": gameAlive,
      'partyLeader': partyLeader,
      'partyLeaderUid': partyLeaderUid,
      'startTime': startTime,
      'turns': turns,
      'loser': loser,
      'playersDone': playersDone
    };
  }
}
