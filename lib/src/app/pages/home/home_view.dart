import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:train_beers/src/app/widgets/empty_container.dart';

import '../../../data/repositories/firebase_authentication_repository.dart';
import '../../../data/repositories/firebase_event_participants_repository.dart';
import '../../../data/repositories/firebase_events_repository.dart';
import '../../../data/repositories/firebase_files_repository.dart';
import '../../../data/repositories/firebase_users_repository.dart';
import '../../../domain/entities/user_entity.dart';
import '../../utils/constants.dart';
import '../../widgets/countdown_timer.dart';
import './home_controller.dart';

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
  _HomePageState(user)
      : super(HomeController(
            FirebaseFilesRepository(),
            FirebaseUsersRepository(),
            FirebaseAuthenticationRepository(),
            FirebaseEventsRepository(),
            FirebaseEventParticipantsRepository(),
            user));

  /// Properties
  String get participantMessage {
    var hasParticipants = controller.participants != null;
    var count = hasParticipants ? controller.participants.length : 0;
    var countText = "There are $count people drinking this week.";
    return hasParticipants ? countText : '';
  }

  /// Overrides
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
        key: globalKey,
        body: RefreshIndicator(
          onRefresh: controller.getNextEvent,
          child: ListView(
            shrinkWrap: false,
            children: <Widget>[
              countdownWidget,
              nextTrainBeerBuyer,
              eventProgress,
              actionsContainer,
              activeDrinkers,
            ],
          ),
        ),
      ),
    );
  }

  /// Methods
  List<PopupMenuItem<String>> getMenuItems(BuildContext context) {
    return Constants.homeMenuOptions.map((option) {
      return PopupMenuItem<String>(
        value: option,
        child: Text(option),
      );
    }).toList();
  }

  /// Properties (Widgets)
  Widget get actionsContainer {
    var userId = controller.user?.id;
    var hostUserId = controller.event?.hostUser?.id;
    var isCurrentUserHost = userId != null && userId == hostUserId;

    return Conditional.single(
      context: context,
      conditionBuilder: (context) => isCurrentUserHost,
      widgetBuilder: (context) => Container(
        color: Colors.pink,
        height: 100,
        width: 100,
      ),
      fallbackBuilder: (context) => EmptyContainer());
  }

  Widget get countdownWidget => Conditional.single(
      context: context,
      conditionBuilder: (context) => controller.shouldDisplayCountdown(),
      widgetBuilder: (context) {
        return CountDownTimer();
      },
      fallbackBuilder: (context) {
        return ColorizeAnimatedTextKit(
            text: [
              "WE'RE DRINKING!",
              "BEER IS LIFE!",
              "CHECK PLEASE!",
            ],
            isRepeatingAnimation: true,
            textStyle: TextStyle(fontSize: 40.0, fontFamily: "Horizon"),
            colors: [
              Colors.red,
              Colors.orange,
              Colors.purple,
              Colors.green,
              Colors.yellow,
              Colors.blue,
            ],
            textAlign: TextAlign.start,
            alignment: AlignmentDirectional.topStart);
      });

  Widget get eventProgress {
    return Container(
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.only(left: 20, right: 20),
      child: SleekCircularSlider(
        appearance: CircularSliderAppearance(
          customWidths: CustomSliderWidths(progressBarWidth: 10),
          customColors: CustomSliderColors(
            trackColor: Colors.grey,
            progressBarColor: controller.eventProgressColor,
            hideShadow: true,
          ),
        ),
        innerWidget: (curentValue) => Container(
          margin: EdgeInsets.only(top: 25),
          child: Column(
            children: <Widget>[
              nextTrainBeerBuyerAvatar,
              Text(controller.eventProgressMessage)
            ],
          ),
        ),
        min: 0,
        max: 100,
        initialValue: controller.eventProgressPercent,
      ),
    );
  }

  Widget get nextTrainBeerBuyerAvatar {
    return Center(
        child: ClipRRect(
      borderRadius: BorderRadius.circular(75.0),
      child: Conditional.single(
        context: context,
        conditionBuilder: (context) => controller.avatarPath != null,
        widgetBuilder: (context) {
          return CachedNetworkImage(
            imageUrl: controller.avatarPath,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            width: 100.0,
            height: 100.0,
          );
        },
        fallbackBuilder: (context) => CircularProgressIndicator(),
      ),
    ));
  }

  Widget get nextTrainBeerBuyer {
    var hasUser = controller.event != null && controller.event.hostUser != null;
    var name = hasUser ? "${controller.event.hostUser.name}" : "";
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        children: <Widget>[
          Text(
            "This Week's Buyer",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 25.0,
            ),
          ),
          Text(
            name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget get activeDrinkers {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 40.0),
            child: Text(
              participantMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
          activeDrinkerListButton,
        ],
      ),
    );
  }

  Widget get activeDrinkerListButton => FlatButton(
        onPressed: controller.goToActiveDrinkers,
        child: Text(
          "View Drinkers",
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        color: Colors.blueAccent,
      );
}
