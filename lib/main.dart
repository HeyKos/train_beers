import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/app/pages/auth_wrapper.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
      ),
    );
  }
}
