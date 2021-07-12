import 'package:meta/meta.dart';

@immutable
class Game {
  const Game({
    @required this.correct,
    @required this.incorrect,
    @required this.isGameLive,
    @required this.nameVoted,
    @required this.submittedName,
    @required this.gameOver,
  });
  final String correct;
  final String incorrect;
  final bool isGameLive;
  final String nameVoted;
  final bool submittedName;
  final bool gameOver;
}
