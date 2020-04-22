import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_conditional_rendering/conditional.dart';

import '../../../data/repositories/firebase_files_repository.dart';
import '../../../data/repositories/firebase_users_repository.dart';
import '../../../domain/entities/event_participant_entity.dart';
import '../../../domain/entities/user_entity.dart';
import 'participants_controller.dart';

class ParticipantsPage extends View {
  final String title;
  final List<EventParticipantEntity> participants;

  ParticipantsPage({
    Key key,
    this.title,
    @required this.participants,
  }) : super(key: key);

  @override
  // inject dependencies inwards
  _ParticipantsPageState createState() => _ParticipantsPageState(participants);
}

class _ParticipantsPageState
    extends ViewState<ParticipantsPage, ParticipantsController> {
  _ParticipantsPageState(participants)
      : super(ParticipantsController(FirebaseFilesRepository(),
            FirebaseUsersRepository(), participants));

  @override
  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        key: globalKey,
        body: participantsListView(context),
      ),
    );
  }

  /// Methods
  String getInitials(int index) {
    if (controller.participants == null) {
      return "";
    }

    return controller.participants[index].user.initials;
  }

  UserEntity getParticipantAtIndex(int index) {
    if (controller.participants == null) {
      return null;
    }

    return controller.participants[index].user;
  }

  /// Properties (Widgets)
  Widget participantCard(BuildContext context, int index) {
    var user = getParticipantAtIndex(index);
    var text = user != null ? user.name : "";
    var url = user != null ? user.avatarUrl : "";

    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(5.0),
        leading: Conditional.single(
            context: context,
            conditionBuilder: (context) => url != null,
            widgetBuilder: (context) {
              return CircleAvatar(
                backgroundImage: NetworkImage(url),
              );
            },
            fallbackBuilder: (context) {
              var initials = getInitials(index);

              return CircleAvatar(
                backgroundColor: Colors.grey,
                foregroundColor: Colors.black,
                child: Text(initials),
              );
            }),
        title: Text(text),
      ),
    );
  }

  Widget participantsListView(BuildContext context) {
    var hasParticipants = controller.participants != null;
    var participantCount = hasParticipants ? controller.participants.length : 0;
    return ListView.builder(
      itemCount: participantCount,
      itemBuilder: participantCard,
    );
  }
}
