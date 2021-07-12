import 'package:meta/meta.dart';

@immutable
class Player {
  Player(
      {@required this.player,
      @required this.isCreator,
      @required this.lobbyCode,
      @required this.points,
      @required this.correct,
      @required this.incorrect,
      @required this.currTweets,
      @required this.previousTweets,
      @required this.previousFakeTweets});
  final String player;
  final bool isCreator;
  final String lobbyCode;
  final String points;
  final String correct;
  final String incorrect;
  final List<List<dynamic>> currTweets;
  final List<String> previousTweets;
  final List<String> previousFakeTweets;
}
