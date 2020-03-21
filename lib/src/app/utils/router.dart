import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:train_beers/src/app/pages/pages.dart';

class Router {
  final RouteObserver<PageRoute> routeObserver;

  Router() : routeObserver = RouteObserver<PageRoute>();

  Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Pages.home:
        return _buildRoute(settings, HomePage(title: "Home"));
      case Pages.login:
        return _buildRoute(settings, LoginPage(title: "Sign In"));
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