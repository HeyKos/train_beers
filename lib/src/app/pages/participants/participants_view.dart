import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:train_beers/src/data/repositories/firebase_files_repository.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';
import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
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

class _ParticipantsPageState extends ViewState<ParticipantsPage, ParticipantsController> {
  _ParticipantsPageState(participants) : super(ParticipantsController(FirebaseFilesRepository(), FirebaseUsersRepository(), participants));

  @override
  Widget buildPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        key: globalKey, // built in global key for the ViewState for easy access in the controller
        body: this.participantsListView(context),
      ),
    );
  } 

  /// Methods
  String getInitials(int index) {
    if (controller.participants == null) return "";

    return controller.participants[index].user.initials;
  }

  /// Properties (Widgets)
  Widget participantsListView(BuildContext context) {
    return ListView.builder(
      itemCount: controller.participants != null ? controller.participants.length : 0,
      itemBuilder: (context, index) {
        var text = controller.participants != null ? controller.participants[index].user.name : "";
        var initials = getInitials(index);
        var url =  controller.participants != null ? controller.participants[index].user.avatarUrl : "";
        return Card(
          child: ListTile(
            contentPadding: EdgeInsets.all(5.0),
            leading: Conditional.single(
              context: context,
              conditionBuilder: (BuildContext context) => url != null,
              widgetBuilder: (BuildContext context) {
                return CircleAvatar(
                  backgroundImage: NetworkImage(url),
                );
              },
              fallbackBuilder: (BuildContext context) {
                return CircleAvatar(
                  backgroundColor: Colors.grey,
                  foregroundColor: Colors.black,
                  child: Text (initials),
                );
              }
            ),
            title: Text(text),
          ),
        );
      },
    );
  }
}
