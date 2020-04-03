import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';
import 'profile_controller.dart';

class ProfilePage extends View {
  final String title;
  final UserEntity user;
  
  ProfilePage({
    Key key,
    this.title,
    @required this.user,
  }) : super(key: key);
  

  @override
  // inject dependencies inwards
  _ProfilePageState createState() => _ProfilePageState(user);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
  _ProfilePageState(user) : super(ProfileController(FirebaseUsersRepository(), user));

  @override
  Widget buildPage() {
    String name = controller.user != null ? controller.user.name : "";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                      Text(name,
                        style: TextStyle(
                          fontSize: 30.0
                        ),
                      ),
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
                      FlatButton.icon(
                        label: Text("Update Profile Image"),
                        icon: Icon(Icons.people),
                        onPressed: controller.goToUpdateProfilePicture,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  } 

  /// Properties (Widgets)
}
