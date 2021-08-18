import 'package:crazy_tweets_2/main.dart';
import 'package:crazy_tweets_2/models/ad_model.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreatePage extends HookWidget {
  const CreatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = useProvider(firebaseAuthProvider);
    final _nameController = useTextEditingController();

    InterstitialAd interAd;

    final adState = context.read(adStateProvider);
    adState.initialization.then((status) {
      print("status: " + status.toString());
      interAd = InterstitialAd(
          adUnitId: adState.interstitialAdUnitId,
          request: AdRequest(),
          listener: adState.adListener);
      interAd.load();
    });

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

    final playerNameField = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.black.withOpacity(.75),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 5.0),
        child: TextField(
          controller: _nameController,
          style: TextStyle(color: Colors.white),
          maxLength: 10,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "Enter Name",
            border: InputBorder.none,
          ),
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
          if (_nameController.text.isEmpty)
            {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: new Text(
                      "Gotta Enter A Name!",
                      style: Theme.of(context).accentTextTheme.headline1,
                      textAlign: TextAlign.center,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: new Text("OK"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              )
            }
          else
            {
              context.read(firebaseDatabaseServiceProvider).createLobby(context,
                  _nameController.text, auth.currentUser.uid.toString()),
              Navigator.of(context).pushNamed(
                AppRoutes.lobbyPage,
              ),
              interAd.show(),
            }
        },
        child: Text(
          "Create Lobby",
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    );

    var backgroundImage = Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset(
        "assets/images/okay_trump.png",
        fit: BoxFit.contain,
      ),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Positioned(top: 50, child: textTitle),
              Positioned(top: 100, child: textSubtitle),
              Positioned(bottom: 0, child: backgroundImage),
              Positioned(
                  left: 30, right: 30, bottom: 160, child: playerNameField),
              Positioned(left: 30, right: 30, bottom: 80, child: createButton),
            ],
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {Navigator.of(context).pop()},
        tooltip: 'Back',
        child: Icon(Icons.arrow_back),
        elevation: 1.0,
        backgroundColor: Color.fromRGBO(255, 255, 255, 0.0),
      ),
    );
  }
}
