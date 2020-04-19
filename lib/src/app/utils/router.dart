import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:train_beers/src/app/pages/pages.dart';

class Router {
  final RouteObserver<PageRoute> routeObserver;

  Router() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.active_users:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            ActiveUsersPage(title: "Participants", participants: args['participants'])
        );
      case Pages.home:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            HomePage(title: "Home", user: args['user'])
        );
      case Pages.login:
        return _buildRoute(settings, LoginPage(title: "Sign In"));
      case Pages.profile:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(
            settings,
            ProfilePage(title: "Profile", user: args['user'])
        );
      case Pages.splash:
        Map<String, dynamic> args = settings.arguments as Map;
        return _buildRoute(settings, SplashPage(title: "Splash", uid: args['uid']));
      default:
        return null;
    }
  }

  MaterialPageRoute _buildRoute(RouteSettings settings, Widget builder) {
    return new MaterialPageRoute(
      settings: settings,
      builder: (ctx) => builder,
    );
  }
}