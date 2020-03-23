import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SplashPage extends View {
  SplashPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State {
  @override
  Widget build(BuildContext context) {  
    return Container(
      color: Colors.grey,
      child: Center(
        child: Image(
          image: AssetImage('assets/images/splash_image.png')
        ),
      )
    );
  }
}
