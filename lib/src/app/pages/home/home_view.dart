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

class HomePage extends View {
  final String title;
  final UserEntity user;
  
  HomePage({
    Key key,
    this.title,
    @required this.user,
  }) : super(key: key);
  

  @override
  // inject dependencies inwards
  _HomePageState createState() => _HomePageState(user);
}

class _HomePageState extends ViewState<HomePage, HomeController> {
  _HomePageState(user) : super(HomeController(FirebaseUsersRepository(), FirebaseAuthenticationRepository(), user));

  @override
  Widget buildPage() {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: controller.onMenuOptionChange,
            itemBuilder: getMenuItems,
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
                      countdownWidget,
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
                        controller.user != null ? controller.user.getWelcomeText() : "",
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
                        controller.user != null ? controller.user.getActiveStatusMessage() : "",
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
      floatingActionButton: actionButton
    );
  } 

  /// Methods
  List<PopupMenuItem<String>> getMenuItems(BuildContext context) {
    return Constants.homeMenuOptions.map((String option) {
      return PopupMenuItem<String>(
        value: option,
        child: Text(option),
      );
    }).toList();    
  }

  /// Properties (Widgets)
  FloatingActionButton get actionButton => FloatingActionButton(
    foregroundColor: controller.user.isActive ? Colors.white : Colors.black,
    backgroundColor: controller.user.isActive ? Colors.redAccent : Colors.greenAccent,
    tooltip: "Count me ${controller.user.isActive ? 'out' : 'in'}!",
    child: Conditional.single(
      context: context,
      conditionBuilder: (BuildContext context) => controller.user.isActive,
      widgetBuilder: (BuildContext context) {
        return Icon(Icons.thumb_down);
      },
      fallbackBuilder: (BuildContext context) {
        return Icon(Icons.thumb_up);
      },
    ),
    onPressed: () {
      controller.user.userIsActive = !controller.user.isActive;
      controller.updateUser(controller.user);
    },
  );

  Widget get countdownWidget => Conditional.single(
    context: context,
    conditionBuilder: (BuildContext context) => controller.shouldDisplayCountdown(),
    widgetBuilder: (BuildContext context) {
      return CountDownTimer();
    },
    fallbackBuilder: (BuildContext context) {
      return ColorizeAnimatedTextKit(
        text: [
          "WE'RE DRINKING!",
          "BEER IS LIFE!",
          "CHECK PLEASE!",
        ],
        isRepeatingAnimation: true,
        textStyle: TextStyle(
            fontSize: 40.0, 
            fontFamily: "Horizon"
        ),
        colors: [
          Colors.red,
          Colors.orange,
          Colors.purple,
          Colors.green,
          Colors.yellow,
          Colors.blue,
        ],
        textAlign: TextAlign.start,
        alignment: AlignmentDirectional.topStart // or Alignment.topLeft
      );
    }
  );
}
