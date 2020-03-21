import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:logging/logging.dart';
import 'package:train_beers/src/app/pages/auth_wrapper.dart';
import 'package:train_beers/src/app/utils/router.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return StreamProvider<String>.value(
      // TODO: Should I be using a use case here, or is it okay to reference the repository?
      value: FirebaseAuthenticationRepository().user,
      child: MaterialApp(
        title: 'Train Beers',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
        onGenerateRoute: _router.getRoute,
        navigatorObservers: [_router.routeObserver],
      ),
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