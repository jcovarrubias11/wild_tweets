import 'package:crazy_tweets_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LandingPage extends HookWidget {
  const LandingPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var textIntroTitle = Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Text(
        "Welcome To",
        style: Theme.of(context).primaryTextTheme.headline2,
      ),
    );

    var textTitle = Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "SWEET",
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
    );

    var textSubtitle = Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Text(
        "TWEETS",
        style: Theme.of(context).primaryTextTheme.headline1,
      ),
    );

    var subtitleImage = Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          "assets/images/trump-cartoon-png-4.png",
          fit: BoxFit.contain,
        ),
      ),
    );

    return WillPopScope(
      onWillPop: () => showDialog<bool>(
        context: context,
        builder: (c) => AlertDialog(
          title: Text(
            'Warning',
            style: Theme.of(context).accentTextTheme.headline1,
            textAlign: TextAlign.center,
          ),
          content: Text(
            'Do you really want to exit',
            style: Theme.of(context).accentTextTheme.headline1,
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              child: Text('Yes'),
              onPressed: () => Navigator.pop(c, true),
            ),
            ElevatedButton(
              child: Text('No'),
              onPressed: () => Navigator.pop(c, false),
            ),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Color.fromRGBO(3, 9, 23, 1),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(children: <Widget>[
            Positioned(
              top: 150,
              left: 30,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  textIntroTitle,
                  textTitle,
                  textSubtitle,
                ],
              ),
            ),
            subtitleImage
          ]),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read(signInProvider.notifier).signInAnon(),
          tooltip: 'Next',
          child: Icon(Icons.arrow_forward),
          elevation: 1.0,
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.2),
        ),
      ),
    );
  }
}
