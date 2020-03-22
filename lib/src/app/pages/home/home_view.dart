import 'package:train_beers/src/app/widgets/countdown_timer.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';

class HomePage extends View {
  HomePage({Key key, this.title, this.user}) : super(key: key);

  final String title;
  final UserEntity user;

  @override
  // inject dependencies inwards
  _HomePageState createState() => _HomePageState(this.user);
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState(this.user) : super(HomeController(FirebaseUsersRepository(), FirebaseAuthenticationRepository()));
  
  final UserEntity user;

  @override
  Widget buildPage() {

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
                        getCurrentUserText(user),
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
                      Text(
                        getActiveStatusMessage(user),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
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
                        onPressed: () {
                          user.userIsActive = !user.isActive;
                          controller.updateUser(user);
                        },
                        child: Text(
                          "Count me ${user.isActive ? 'out' : 'in'}!",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.black,
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

  String getCurrentUserText(UserEntity user) {
    if (user == null) {
      return "";
    }

    return "Hi there ${user.name}!";
  }

  String getActiveStatusMessage(UserEntity user) {
    if (user == null) {
      return "";
    }

    if (user.isActive) {
      return "You're currently in for beers!";
    }

    return "You're not drinking beers this week.";
  }
}
