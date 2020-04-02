import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:train_beers/src/app/utils/constants.dart';
import 'package:train_beers/src/app/widgets/countdown_timer.dart';
import 'package:train_beers/src/data/repositories/firebase_authenticaion_repository.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';

import 'active_users_controller.dart';

class ActiveUsersPage extends View {
  final String title;
  
  ActiveUsersPage({
    Key key,
    this.title,
  }) : super(key: key);
  

  @override
  // inject dependencies inwards
  _ActiveUsersPageState createState() => _ActiveUsersPageState();
}

class _ActiveUsersPageState extends ViewState<ActiveUsersPage, ActiveUsersController> {
  _ActiveUsersPageState() : super(ActiveUsersController(FirebaseUsersRepository()));

  @override
  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        key: globalKey, // built in global key for the ViewState for easy access in the controller
        body: this.usersListView(context),
      ),
    );
  } 

  /// Methods

  /// Properties (Widgets)
  Widget usersListView(BuildContext context) {
    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(controller.users[index].name),
        );
      },
    );
  }
}
