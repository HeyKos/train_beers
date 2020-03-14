import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import './src/app/pages/home/home_view.dart';
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
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: 'Train Beers'),
      debugShowCheckedModeBanner: false,
    );
  }
}
