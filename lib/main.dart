import 'dart:io';
import 'package:crazy_tweets_2/models/ad_model.dart';
import 'package:crazy_tweets_2/models/player_model.dart';
import 'package:flutter/services.dart';
import 'package:crazy_tweets_2/auth_widget.dart';
import 'package:crazy_tweets_2/frontend/pages/home/home.dart';
import 'package:crazy_tweets_2/frontend/pages/landing/landing.dart';
import 'package:crazy_tweets_2/providers/ad_provider.dart';
import 'package:crazy_tweets_2/providers/player_provider.dart';
import 'package:crazy_tweets_2/services/auth_services.dart';
import 'package:crazy_tweets_2/router/app_router.dart';
import 'package:crazy_tweets_2/constants/theme_data.dart';
import 'package:crazy_tweets_2/services/database_service.dart';
import 'package:crazy_tweets_2/utils/config_reader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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

final signInProvider = StateNotifierProvider<FirebaseAuthService, void>(
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
        ref.watch(databaseProvider), ref.watch(playerStateProvider.notifier)));
//

//Home Page Provider
final playerStateProvider =
    StateNotifierProvider<PlayerProvider, Player>((ref) => PlayerProvider());
//

final adProvider = StateNotifierProvider<AdProvider, AdModel>((ref) => AdProvider());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigReader.initialize();
  final initFuture = MobileAds.instance.initialize();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Firebase.initializeApp(
    name: 'wild_tweets',
    options: Platform.isIOS || Platform.isMacOS
        ? FirebaseOptions(
            appId: ConfigReader.getiOSAppId(),
            apiKey: ConfigReader.getApiKey(),
            projectId: ConfigReader.getProjectId(),
            messagingSenderId: '',
            databaseURL: ConfigReader.getDatabaseURL(),
          )
        : FirebaseOptions(
            appId: ConfigReader.getAndroidAppId(),
            apiKey: ConfigReader.getApiKey(),
            messagingSenderId: '',
            projectId: ConfigReader.getProjectId(),
            databaseURL: ConfigReader.getDatabaseURL(),
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
    context.read(adProvider.notifier).setAdModel(initialization: initFuture);

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
