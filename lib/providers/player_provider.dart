import 'dart:convert';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:crazy_tweets_2/models/tweet_model.dart';
import 'package:crazy_tweets_2/constants/tweets.dart';
import 'package:crazy_tweets_2/constants/fakeTweets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;

class PlayerProvider extends StateNotifier<Player> {
  PlayerProvider() : super(_initialState);

  static final _initialState = Player(
      player: '',
      lobbyCode: '',
      isCreator: false,
      points: '0',
      incorrect: '0',
      correct: '0',
      currTweets: List.filled(0, [], growable: true),
      previousTweets: [],
      previousFakeTweets: []);

  void reset() {
    state = _initialState;
  }

  void createdLobby(String lobby, String player) {
    state = Player(
        player: player,
        lobbyCode: lobby,
        isCreator: true,
        points: state.points,
        incorrect: state.incorrect,
        correct: state.correct,
        currTweets: state.currTweets,
        previousTweets: state.previousTweets,
        previousFakeTweets: state.previousFakeTweets);
  }

  void joinedLobby(String lobby, String player) {
    state = Player(
        player: player,
        lobbyCode: lobby,
        isCreator: false,
        points: state.points,
        incorrect: state.incorrect,
        correct: state.correct,
        currTweets: state.currTweets,
        previousTweets: state.previousTweets,
        previousFakeTweets: state.previousFakeTweets);
  }

  void updatePlayerName(String player) {
    state = Player(
        player: player,
        lobbyCode: state.lobbyCode,
        isCreator: state.isCreator,
        points: state.points,
        incorrect: state.incorrect,
        correct: state.correct,
        currTweets: state.currTweets,
        previousTweets: state.previousTweets,
        previousFakeTweets: state.previousFakeTweets);
  }

  void updateCurrentTweets(List<List<dynamic>> currentTweets,
      List<String> previousTweets, List<String> previousFakeTweets) {
    state = Player(
        player: state.player,
        lobbyCode: state.lobbyCode,
        isCreator: state.isCreator,
        points: state.points,
        incorrect: state.incorrect,
        correct: state.correct,
        currTweets: currentTweets,
        previousTweets: previousTweets,
        previousFakeTweets: previousFakeTweets);
  }

  void updateCorrectAnswer(String correct) {
    state = Player(
        player: state.player,
        lobbyCode: state.lobbyCode,
        isCreator: state.isCreator,
        points: state.points,
        incorrect: state.incorrect,
        correct: correct,
        currTweets: state.currTweets,
        previousTweets: state.previousTweets,
        previousFakeTweets: state.previousFakeTweets);
  }

  void updateIncorrectAnswer(String incorrect) {
    state = Player(
        player: state.player,
        lobbyCode: state.lobbyCode,
        isCreator: state.isCreator,
        points: state.points,
        incorrect: incorrect,
        correct: state.correct,
        currTweets: state.currTweets,
        previousTweets: state.previousTweets,
        previousFakeTweets: state.previousFakeTweets);
  }

  Future<void> getTweets() async {
    List<List<dynamic>> currentTweets = [];
    List<List<dynamic>> fakeListTweets = [];
    List<String> previousTweets = state.previousTweets;
    List<String> previousFakeTweets = state.previousFakeTweets;
    int correctTweetsLen = randomBetween(0, 20);
    int fakeTweetsLen = (20 - correctTweetsLen);

    for (var i = state.currTweets.length; i < correctTweetsLen; i++) {
      int rand = randomBetween(0, (tweets.length - 1));
      var idExists = previousTweets.contains(rand.toString());
      while (idExists) {
        rand = randomBetween(0, (tweets.length - 1));
        idExists = previousTweets.contains(rand.toString());
      }
      await http
          .get('https://www.thetrumparchive.com/tweets/' + tweets[rand])
          .then((value) async {
        var response = await jsonDecode(value.body);
        var tweet = Tweet.fromJson(response);
        if (!tweet.text.contains("https://") && !tweet.text.contains("RT")) {
          List<dynamic> tweetMap = [tweet, true];
          currentTweets.add(tweetMap);
        } else {
          i--;
        }
        previousTweets.add(rand.toString());
      });
    }

    for (var i = state.currTweets.length; i < fakeTweetsLen; i++) {
      int rand = randomBetween(0, (fakeTweets.length - 1));
      int randFav = randomBetween(50000, 200000);
      int randRet = randomBetween(10000, 30000);
      var idExists = previousFakeTweets.contains(rand.toString());

      while (idExists) {
        rand = randomBetween(0, (fakeTweets.length - 1));
        idExists = previousFakeTweets.contains(rand.toString());
      }
      var tweet = new Tweet(
          id: i.toString(),
          text: fakeTweets[rand],
          favorites: randFav.toString(),
          retweets: randRet.toString(),
          date: "");
      List<dynamic> tweetMap = [tweet, false];
      fakeListTweets.add(tweetMap);
      previousFakeTweets.add(rand.toString());
    }
    List<List<dynamic>> combinedTweetList = new List.from(currentTweets)
      ..addAll(fakeListTweets);
    combinedTweetList.shuffle();
    updateCurrentTweets(combinedTweetList, previousTweets, previousFakeTweets);
  }
}
