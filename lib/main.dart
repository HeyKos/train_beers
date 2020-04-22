import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';

import 'src/app/pages/login/login_view.dart';
import 'src/app/pages/splash/splash_view.dart';
import 'src/app/utils/router.dart';
import 'src/data/repositories/firebase_authentication_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp() : _router = Router() {
    initLogger();
  }

  final Router _router;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterCleanArchitecture.debugModeOn();
    return MaterialApp(
      title: 'Train Beers',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: StreamBuilder<String>(
        stream: FirebaseAuthenticationRepository().user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SplashPage(title: 'Splash', uid: snapshot.data.toString());
          } else {
            return LoginPage(title: 'Sign In');
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: _router.getRoute,
      navigatorObservers: [_router.routeObserver],
    );
  }
}

void initLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    final dynamic e = record.error;
    final loggerName = record.loggerName;
    final levelName = record.level.name;
    final message = record.message;
    final error = e != 'null' ? e.toString() : '';

    print('$loggerName: $levelName: $message $error');
  });

  Logger.root.info('Logger initialized.');
}
