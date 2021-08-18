import 'dart:convert';

import 'package:crazy_tweets_2/frontend/pages/game/game.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/constants/pics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:html_unescape/html_unescape.dart';

class TweetList extends HookWidget {
  const TweetList(this.player, {Key key}) : super(key: key);

  final Player player;

  @override
  Widget build(BuildContext context) {
    final gameState = useProvider(gameStateProvider.notifier);

    // ignore: unused_local_variable
    CardController controller;

    return new TinderSwapCard(
      swipeUp: false,
      swipeDown: false,
      orientation: AmassOrientation.TOP,
      totalNum: player.currTweets.length,
      stackNum: 4,
      swipeEdge: 4.0,
      maxWidth: MediaQuery.of(context).size.width * 0.9,
      maxHeight: MediaQuery.of(context).size.height * 0.6,
      minWidth: MediaQuery.of(context).size.width * 0.8,
      minHeight: MediaQuery.of(context).size.height * 0.5,
      cardBuilder: (context, index) => Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.6,
              child: Padding(
                padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, top: 15.0),
                            child: CircleAvatar(
                              radius: 30.0,
                              child: Image.asset(Pics.pic1[1]),
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.54,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 2.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Donald J. Trump',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text('@realDonaldTrump'),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text(HtmlUnescape().convert(
                                      player.currTweets[index][0].text)),
                                ],
                              ),
                            ),
                          ),
                        ])
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      cardController: controller = CardController(),
      swipeUpdateCallback: (DragUpdateDetails details, Alignment align) {
        /// Get swiping card's alignment
        if (align.x < 0) {
          //Card is LEFT swiping
        } else if (align.x > 0) {
          //Card is RIGHT swiping
        }
      },
      swipeCompleteCallback: (CardSwipeOrientation orientation, int index) {
        print(index);

        /// Get orientation & index of swiped card!
        if (orientation == CardSwipeOrientation.RIGHT &&
            player.currTweets[index][1] == true) {
          context.read(gameStateProvider.notifier).updateCorrect();
        } else if (orientation == CardSwipeOrientation.LEFT &&
            player.currTweets[index][1] == false) {
          context.read(gameStateProvider.notifier).updateCorrect();
        } else {
          context.read(gameStateProvider.notifier).updateIncorrect();
        }
        if (index == 19) {
          context.read(firebaseDatabaseServiceProvider).updatePlayerStats(
              lobby: player.lobbyCode,
              playerName: player.player,
              // ignore: invalid_use_of_protected_member
              stats: gameState.state.correct.toString());
          context
              .read(playerStateProvider.notifier)
              // ignore: invalid_use_of_protected_member
              .updateIncorrectAnswer(gameState.state.incorrect.toString());

          context
              .read(playerStateProvider.notifier)
              // ignore: invalid_use_of_protected_member
              .updateCorrectAnswer(gameState.state.correct.toString());
          context.read(gameStateProvider.notifier).updateLiveGame(false);
        }
      },
    );
  }
}
