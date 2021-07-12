import 'package:crazy_tweets_2/frontend/pages/create/create.dart';
import 'package:crazy_tweets_2/frontend/pages/edit/edit.dart';
import 'package:crazy_tweets_2/frontend/pages/game/game.dart';
import 'package:crazy_tweets_2/frontend/pages/home/home.dart';
import 'package:crazy_tweets_2/frontend/pages/join/join.dart';
import 'package:crazy_tweets_2/frontend/pages/landing/landing.dart';
import 'package:crazy_tweets_2/frontend/pages/lobby/lobby.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const landingPage = '/landing-page';
  static const homePage = '/home-page';
  static const createPage = '/create-page';
  static const lobbyPage = '/lobby-page';
  static const joinPage = '/join-page';
  static const editPage = '/edit-page';
  static const gamePage = '/game-page';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(
      RouteSettings settings, FirebaseAuth firebaseAuth) {
    final args = settings.arguments;
    switch (settings.name) {
      case AppRoutes.landingPage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => LandingPage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              LandingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.homePage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => HomePage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.createPage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => CreatePage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => CreatePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.joinPage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => JoinPage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => JoinPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.lobbyPage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => LobbyPage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => LobbyPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.editPage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => EditPage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => EditPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRoutes.gamePage:
        // return MaterialPageRoute<dynamic>(
        //   builder: (_) => GamePage(),
        //   settings: settings,
        //   fullscreenDialog: true,
        // );
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => GamePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      default:
        // TODO: Throw
        return null;
    }
  }
}
