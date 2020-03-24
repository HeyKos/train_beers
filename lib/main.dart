import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:train_beers/src/app/pages/login/login_view.dart';
import 'package:train_beers/src/app/pages/splash/splash_view.dart';
import 'package:train_beers/src/app/utils/router.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Router _router;
  MyApp() : _router = Router() {
    initLogger();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterCleanArchitecture.debugModeOn();
    return MaterialApp(
      title: 'Train Beers',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: StreamBuilder(
        stream: FirebaseAuthenticationRepository().user, // TODO: This should probably use a use case, not reference the repository directly.
        builder: (context, snapshot) {
          if(snapshot.hasData){
            return SplashPage(title: "Splash", uid: snapshot.data); 
          } else {
            return LoginPage(title: "Sign In");
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
    dynamic e = record.error;
    print(
        '${record.loggerName}: ${record.level.name}: ${record.message} ${e != 'null' ? e.toString() : ''}');
  });
  Logger.root.info("Logger initialized.");
}