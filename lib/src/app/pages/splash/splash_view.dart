import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../data/repositories/firebase_users_repository.dart';
import 'splash_controller.dart';

class SplashPage extends View {
  final String uid;
  final String title;

  SplashPage({
    Key key,
    this.title,
    @required this.uid,
  }) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState(uid);
}

class _SplashPageState extends ViewState<SplashPage, SplashController> {
  _SplashPageState(String uid) : super(
    SplashController(FirebaseUsersRepository(), uid)
  );
  
  @override
  Widget buildPage() {  
    return Scaffold(
      key: globalKey,
      body: Container(
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/splash_image.png')
            ),
            ScaleAnimatedTextKit(
              text: [
                "Loading..."
              ],
              textStyle: TextStyle(
                  fontSize: 30.0,
                  color: Colors.white,
                  decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.center,
              alignment: AlignmentDirectional.topStart
            ),
          ],
        )
      ),
    );
  }
}
