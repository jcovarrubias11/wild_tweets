import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crazy_tweets_2/frontend/pages/game/game.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/game_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';

class Timer extends HookWidget {
  const Timer(this.player, {Key key}) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    final timerState = useProvider(timerStateProvider);
    final gameState = useProvider(gameStateProvider);

    // return futureForStream.when(data: (duration) {
    //   final timerAnimation =
    //       useAnimationController(duration: Duration(seconds: duration));
    //   timerAnimation.forward();

    //   return QuestionTimerDisplay(
    //       game: gameState,
    //       player: player,
    //       timerAnimation: timerAnimation,
    //       timerState: timerState);
    // }, loading: () {
    //   print("loading");
    //   return Container();
    // }, error: (e, __) {
    //   print(e);
    //   return Container();
    // });
    
    final timerAnimation =
        useAnimationController(duration: Duration(seconds: 120));
    timerAnimation.forward();

    return QuestionTimerDisplay(
        game: gameState,
        player: player,
        timerAnimation: timerAnimation,
        timerState: timerState);
  }
}

class QuestionTimerDisplay extends AnimatedWidget {
  QuestionTimerDisplay({
    Key key,
    @required this.game,
    @required this.player,
    @required this.timerAnimation,
    @required this.timerState,
  }) : super(
            listenable:
                Tween<double>(begin: 1, end: 0).animate(timerAnimation));

  final AnimationController timerAnimation;
  final TimerModel timerState;
  final Player player;
  final Game game;

  @override
  Widget build(BuildContext context) {
    Animation<double> animation = listenable;

    Future.delayed(Duration.zero, () {
      if (animation.value == 0) {
        timerAnimation.dispose();
        context.read(firebaseDatabaseServiceProvider).updatePlayerStats(
            lobby: player.lobbyCode,
            playerName: player.player,
            stats: game.correct.toString());
        context
            .read(playerStateProvider.notifier)
            .updateIncorrectAnswer(game.incorrect.toString());

        context
            .read(playerStateProvider.notifier)
            .updateCorrectAnswer(game.correct.toString());
        context.read(gameStateProvider.notifier).updateLiveGame(false);
      } else {
        context.read(timerStateProvider.notifier).updateTimerState(
            (animation.value * timerState.initialTime).toInt());
      }
    });

    return LiquidCircularProgressIndicator(
      value: animation.value,
      center: animation.value != 0.0
          ? DefaultTextStyle(
              style: Theme.of(context)
                  .accentTextTheme
                  .headline1
                  .copyWith(color: Color(0xFF1B263B)),
              child: AnimatedTextKit(
                animatedTexts: [
                  ScaleAnimatedText(timerState.timeLeftString),
                ],
                pause: Duration(microseconds: 1),
                repeatForever: true,
              ),
            )
          : Image.asset(
              "assets/images/okay_trump.png",
              fit: BoxFit.contain,
            ),
    );
  }
}
