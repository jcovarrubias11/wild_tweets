import 'dart:io';
import 'package:crazy_tweets_2/auth_widget.dart';
import 'package:crazy_tweets_2/frontend/pages/home/home.dart';
import 'package:crazy_tweets_2/frontend/pages/landing/landing.dart';
import 'package:crazy_tweets_2/providers/ad_provider.dart';
import 'package:crazy_tweets_2/providers/player_provider.dart';
import 'package:crazy_tweets_2/services/auth_services.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:crazy_tweets_2/constants/theme_data.dart';
import 'package:crazy_tweets_2/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/all.dart';

// Authentication Providers
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  final FirebaseApp app = Firebase.app("wild_tweets");
  if (app != null) {
    return FirebaseAuth.instanceFor(app: app);
  }
  return null;
});

final authStateChangesProvider = StreamProvider<User>(
    (ref) => ref.watch(firebaseAuthProvider).authStateChanges());

final signInProvider = StateNotifierProvider<FirebaseAuthService>(
    (ref) => FirebaseAuthService(ref.watch(firebaseAuthProvider)));
//

// Database Accessor For Wild Tweets
final databaseProvider = Provider<FirebaseDatabase>((ref) {
  final FirebaseApp app = Firebase.app("wild_tweets");
  if (app != null) {
    return FirebaseDatabase(app: app);
  }
  return null;
});
//

// DB function calls
final firebaseDatabaseServiceProvider = Provider<FirebaseDatabaseService>(
    (ref) => FirebaseDatabaseService(
        ref.watch(databaseProvider), ref.watch(playerStateProvider)));
//

//Home Page Provider
final playerStateProvider =
    StateNotifierProvider<PlayerProvider>((ref) => PlayerProvider());
//

final adProvider = StateNotifierProvider<AdProvider>((ref) => AdProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();

  await Firebase.initializeApp(
    name: 'wild_tweets',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: '1:23778610035:ios:2e83bd26660c603834d306',
            apiKey: 'AIzaSyCLG7odc-rkcckNZUyFByCU97ALrcXaa70',
            projectId: 'wildtweets-e54d7',
            messagingSenderId: '',
            databaseURL: 'https://wildtweets-e54d7.firebaseio.com/',
          )
        : FirebaseOptions(
            appId: '1:23778610035:android:2e83bd26660c603834d306',
            apiKey: 'AIzaSyCLG7odc-rkcckNZUyFByCU97ALrcXaa70',
            messagingSenderId: '',
            projectId: 'wildtweets-e54d7',
            databaseURL: 'https://wildtweets-e54d7.firebaseio.com/',
          ),
  );

  runApp(ProviderScope(
    child: MyApp(initFuture),
  ));
}

class MyApp extends HookWidget {
  MyApp(this.initFuture);

  final Future<InitializationStatus> initFuture;

  @override
  Widget build(BuildContext context) {
    final firebaseAuth = context.read(firebaseAuthProvider);
    context.read(adProvider).setAdModel(initialization: initFuture);

    return MaterialApp(
      theme: GeneralTheme().getTheme(),
      debugShowCheckedModeBanner: false,
      home: AuthWidget(
        nonSignedInBuilder: (_) => LandingPage(),
        signedInBuilder: (_) => HomePage(),
      ),
      onGenerateRoute: (settings) =>
          AppRouter.onGenerateRoute(settings, firebaseAuth),
    );
  }
}
