import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import './src/app/pages/login/login_view.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    FlutterCleanArchitecture.debugModeOn();
    return MaterialApp(
      title: 'Train Beers',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      // home: HomePage(title: 'Train Beers'),
      home: LoginPage(title: 'Sign In'),
      debugShowCheckedModeBanner: false,
    );
  }
}
