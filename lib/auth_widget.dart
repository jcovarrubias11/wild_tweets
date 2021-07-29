import 'package:crazy_tweets_2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AuthWidget extends HookWidget {
  const AuthWidget({
    Key key,
    @required this.signedInBuilder,
    @required this.nonSignedInBuilder,
  });
  final WidgetBuilder nonSignedInBuilder;
  final WidgetBuilder signedInBuilder;

  @override
  Widget build(BuildContext context) {
    final authStateChanges = useProvider(authStateChangesProvider);

    return authStateChanges.when(
      data: (user) => _data(context, user),
      loading: () => const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      error: (_, __) => const Scaffold(),
    );
  }

  Widget _data(BuildContext context, User user) {
    if (user != null) {
      print(user.uid);
      return signedInBuilder(context);
    }
    return nonSignedInBuilder(context);
  }
}
