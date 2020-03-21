import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import './home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import '../../../data/repositories/firebase_users_repository.dart';

class HomePage extends View {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  // inject dependencies inwards
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState() : super(HomeController(FirebaseUsersRepository(), FirebaseAuthenticationRepository()));

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
        key:
            globalKey, // built in global key for the ViewState for easy access in the controller
        body: Center(
          child: Column(
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
              Text(
                controller.currentUser == null ? "" : controller.currentUser.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 40.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
