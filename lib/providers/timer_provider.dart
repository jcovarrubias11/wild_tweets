import 'dart:async';
import 'package:crazy_tweets_2/models/lobby_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimerNotifier extends StateNotifier<TimerModel> {
  TimerNotifier(this.database, this.player) : super(_initialState);

  final FirebaseDatabase database;
  final Player player;

  static const int _initialTimeLeft = 120;
  static const Duration _intitialDuration = Duration(seconds: 1);
  static final _initialState = TimerModel(
      _initialTimeLeft, _durationString(_initialTimeLeft), _intitialDuration);

  static String _durationString(int duration) {
    final minutes = ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final seconds = (duration % 60).floor().toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Future<int> startTimer() async {
    String startTime;
    await database.reference().child("games").child(player.lobbyCode).once().then(
        (DataSnapshot dataSnapshot) =>
            startTime = Lobby.fromMap(dataSnapshot.value).startTime);
    int timeDiff =
        DateTime.now().difference(DateTime.parse(startTime)).inSeconds;
    return state.initialTime - timeDiff;
  }

  void updateTimerState(timeLeftInt) {
    String timeLeftString = _durationString(timeLeftInt);
    state = TimerModel(state.initialTime, timeLeftString, state.timeLeftDuration);
  }
}

class TimerModel {
  const TimerModel(this.initialTime, this.timeLeftString, this.timeLeftDuration);
  final int initialTime;
  final String timeLeftString;
  final Duration timeLeftDuration;
}
