import 'package:provider/provider.dart';
import 'package:train_beers/src/app/widgets/countdown_timer.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import './home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';

class HomePage extends View {
  HomePage({Key key, this.title, this.uid}) : super(key: key);

  final String title;
  final String uid;

  @override
  // inject dependencies inwards
  _HomePageState createState() => _HomePageState(this.uid);
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState(this.uid) : super(HomeController(FirebaseUsersRepository(), FirebaseAuthenticationRepository()));
  
  final String uid;

  @override
  Widget buildPage() {
    controller.getUserByUid(this.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign Out"),
            onPressed: controller.logout,
          ),
        ],
      ),
      body: Scaffold(
        key: globalKey, // built in global key for the ViewState for easy access in the controller
        body: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CountDownTimer()
                    ],
                  ),
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        getCurrentUserText(uid),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: controller.getNextUser,
                        child: Text(
                          "Who's up for train beers?",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        ),
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        controller.nextUser == null ? "" : controller.nextUser.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 30.0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  String getCurrentUserText(String uid) {
    if (controller.currentUser == null) {
      return "";
    }

    return "Current User: ${controller.currentUser.name}";
  }
}
