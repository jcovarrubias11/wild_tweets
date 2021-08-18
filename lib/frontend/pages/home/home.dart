import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends HookWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(firebaseAuthProvider);

    var textTitle = Padding(
        padding: const EdgeInsets.only(left: 20),
        child: DefaultTextStyle(
          style: Theme.of(context).primaryTextTheme.headline1,
          child: AnimatedTextKit(
            animatedTexts: [
              RotateAnimatedText('NICE'),
              RotateAnimatedText('TWEETS'),
            ],
            repeatForever: true,
          ),
        )
        // child: Text(
        //   "NICE",
        //   style: Theme.of(context).primaryTextTheme.headline1,
        // ),
        );

    // var textSubtitle = Padding(
    //   padding: const EdgeInsets.only(left: 20),
    //   child: Text(
    //     "TWEETS",
    //     style: Theme.of(context).primaryTextTheme.headline1,
    //   ),
    // );

    final joinButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColorDark,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async => {
          await Navigator.of(context).pushNamed(
            AppRoutes.joinPage,
          )
        },
        child: Text(
          "Join Game",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    final createButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Theme.of(context).primaryColorDark,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async => {
          await Navigator.of(context).pushNamed(
            AppRoutes.createPage,
          )
        },
        child: Text(
          "New Game",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    var backgroundImage = Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        "assets/images/trump_bigLaughStill.png",
        fit: BoxFit.contain,
      ),
    );

    Future<void> _popScope() async {
      await auth.signOut().then((value) => true);
    }

    return WillPopScope(
      onWillPop: () => _popScope(),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Positioned(top: 10, child: textTitle),
                // Positioned(top: 100, child: textSubtitle),
                Positioned(bottom: 170, child: backgroundImage),
                Positioned(left: 30, right: 30, bottom: 130, child: joinButton),
                Positioned(left: 30, right: 30, bottom: 50, child: createButton)
              ],
            )),
      ),
    );
  }
}
