import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ChooseLose extends HookWidget {
  const ChooseLose({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
            child: Image.asset(
          'assets/images/chooselose.gif',
          width: 300,
          height: 450,
          fit: BoxFit.contain,
        )),
        Container(
          height: 60,
          child: Text(
            'Everyone gets to choose someone to "Impeach" (or choose as the loser). ' +
                'You can choose anyone except the winner.',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .accentTextTheme
                .headline1
                .copyWith(fontSize: 18.0),
          ),
        )
      ],
    );
  }
}
