import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/app/pages/splash/splash_controller.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';

class SplashPage extends View {
  SplashPage({Key key, this.uid, this.title}) : super(key: key);

  final String uid;
  final String title;

  @override
  _SplashPageState createState() => _SplashPageState(this.uid);
}

class _SplashPageState extends ViewState<SplashPage, SplashController> {
  _SplashPageState(String uid) : super(SplashController(FirebaseUsersRepository(), uid));
  
  @override
  Widget buildPage() {  
    return Container(
      key: globalKey, // built in global key for the ViewState for easy access in the controller,
      color: Colors.grey,
      child: Center(
        child: Image(
          image: AssetImage('assets/images/splash_image.png')
        ),
      )
    );
  }
}
