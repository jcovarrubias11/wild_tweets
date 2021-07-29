import 'package:crazy_tweets_2/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class EditPage extends HookWidget {
  const EditPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _nameController = useTextEditingController();
    final playerProvider = useProvider(playerStateProvider);

    var textTitle = Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          "YOU DONT LIKE",
          style: Theme.of(context).primaryTextTheme.headline2,
        ),
      ),
    );

    var textSubtitle = Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Text(
          playerProvider.player + "?",
          style: Theme.of(context).primaryTextTheme.headline1,
        ),
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
          maxLength: 20,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            hintText: "OK, I guess you can change your name...",
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
              context.read(firebaseDatabaseServiceProvider).updatePlayerName(
                  lobby: playerProvider.lobbyCode,
                  oldplayer: playerProvider.player,
                  newplayer: _nameController.text),
              Navigator.of(context).pop()
            }
        },
        child: Text(
          "Done",
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
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartFloat,
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
