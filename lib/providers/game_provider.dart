import 'package:crazy_tweets_2/models/game_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GameProvider extends StateNotifier<Game> {
  GameProvider() : super(_initialState);

  static final _initialState = Game(
      correct: '0',
      incorrect: '0',
      isGameLive: true,
      nameVoted: "",
      submittedName: false,
      gameOver: false);

  void updateCorrect() {
    state = Game(
        incorrect: state.incorrect,
        correct: (int.parse(state.correct) + 1).toString(),
        isGameLive: state.isGameLive,
        nameVoted: state.nameVoted,
        submittedName: state.submittedName,
        gameOver: state.gameOver);
  }

  void updateIncorrect() {
    state = Game(
        incorrect: (int.parse(state.incorrect) + 1).toString(),
        correct: state.correct,
        isGameLive: state.isGameLive,
        nameVoted: state.nameVoted,
        submittedName: state.submittedName,
        gameOver: state.gameOver);
  }

  void updateLiveGame(bool gameLive) {
    state = Game(
        incorrect: state.incorrect,
        correct: state.correct,
        isGameLive: gameLive,
        nameVoted: state.nameVoted,
        submittedName: state.submittedName,
        gameOver: state.gameOver);
  }

  void updateNameVoted(String name) {
    state = Game(
        incorrect: state.incorrect,
        correct: state.correct,
        isGameLive: state.isGameLive,
        nameVoted: name,
        submittedName: state.submittedName,
        gameOver: state.gameOver);
  }

  void updatesubmittedName(bool submitted) {
    state = Game(
        incorrect: state.incorrect,
        correct: state.correct,
        isGameLive: state.isGameLive,
        nameVoted: state.nameVoted,
        submittedName: submitted,
        gameOver: state.gameOver);
  }

  void updateGameOver(bool gameoh) {
    state = Game(
        incorrect: state.incorrect,
        correct: state.correct,
        isGameLive: state.isGameLive,
        nameVoted: state.nameVoted,
        submittedName: state.submittedName,
        gameOver: gameoh);
  }
}
