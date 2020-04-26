import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/repositories/firebase_event_participants_repository.dart';
import '../../../data/repositories/firebase_files_repository.dart';
import '../../../data/repositories/firebase_users_repository.dart';
import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../widgets/empty_container.dart';
import 'profile_controller.dart';

class ProfilePage extends View {
  final EventEntity event;
  final String title;
  final UserEntity user;

  ProfilePage({
    Key key,
    this.title,
    @required this.event,
    @required this.user,
  }) : super(key: key);

  @override
  // inject dependencies inwards
  _ProfilePageState createState() => _ProfilePageState(event, user);
}

class _ProfilePageState extends ViewState<ProfilePage, ProfileController> {
  _ProfilePageState(event, user)
      : super(ProfileController(
            FirebaseFilesRepository(),
            FirebaseUsersRepository(),
            FirebaseEventParticipantsRepository(),
            event,
            user));

  @override
  Widget buildPage() {
    var name = controller.user != null ? controller.user.name : "";
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Scaffold(
        key: globalKey,
        body: Container(
            child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.grey[800],
                  height: 115.0,
                ),
                nameText(name),
                avatarImage,
                updateAvatarButton,
                saveAvatarButton,
              ],
            ),
            participationStatus,
            participationImage,
          ],
        )),
      ),
    );
  }

  /// Properties (Widgets)
  Widget get avatarImage {
    var hasAvatarPath = controller.avatarPath != null;
    var hasAvatar = controller.userAvatar != null;
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 65.0),
      child: Conditional.single(
        context: context,
        conditionBuilder: (context) => hasAvatarPath || hasAvatar,
        widgetBuilder: (context) {
          return Conditional.single(
            context: context,
            conditionBuilder: (context) => controller.userAvatar != null,
            widgetBuilder: (context) {
              return ClipRRect(
                  borderRadius: BorderRadius.circular(75.0),
                  child: Image(
                    height: 100.0,
                    width: 100.0,
                    image: FileImage(controller.userAvatar),
                  ));
            },
            fallbackBuilder: (context) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(55.0)),
                    border: Border.all(
                      color: Colors.white,
                      width: 5.0,
                    )),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50.0),
                  child: CachedNetworkImage(
                    imageUrl: controller.avatarPath,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    width: 100.0,
                    height: 100.0,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
        fallbackBuilder: (context) => CircularProgressIndicator(),
      ),
    );
  }

  Widget get avatarSavingButton => StreamBuilder<StorageTaskEvent>(
      stream: controller.uploadTask.events,
      builder: (_, snapshot) {
        var event = snapshot?.data?.snapshot;

        if (controller.uploadTask.isComplete) {
          controller.uploadStatusOnChange(event);
        }

        return Container(
          alignment: Alignment(.85, 1),
          padding: EdgeInsets.only(top: 120.0),
          child: FlatButton(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Saving...",
              style: TextStyle(
                color: Colors.lightBlue,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.lightBlue)),
            onPressed: () => {},
          ),
        );
      });

  Widget buildProfileImageDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.photo_camera),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Take a photo",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            ),
            onPressed: () => controller.pickImage(ImageSource.camera),
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.photo_library),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(
                    "Choose a photo",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )
              ],
            ),
            onPressed: () => controller.pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget nameText(String name) => Center(
        child: Container(
          padding: EdgeInsets.only(top: 15.0),
          child: Text(
            name,
            style: TextStyle(color: Colors.white30, fontSize: 30.0),
          ),
        ),
      );

  Widget get participationImage {
    var imageUrlNotNull = controller.participationImageUrl != null;
    var hasImageUrl = controller.participationImageUrl.isNotEmpty;

    return Conditional.single(
      context: context,
      conditionBuilder: (context) => imageUrlNotNull && hasImageUrl,
      widgetBuilder: (context) => Container(
        margin: EdgeInsets.only(top: 20.0),
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Image(image: NetworkImage(controller.participationImageUrl)),
      ),
      fallbackBuilder: (context) => EmptyContainer(),
    );
  }

  Widget get participationStatus {
    var isParticipating = controller.participant != null;

    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Row(
          children: <Widget>[
            Text(
              "Participation Status",
              style: TextStyle(fontSize: 20.0),
            ),
            Spacer(),
            Switch(
              activeColor: Colors.lightBlue,
              value: isParticipating,
              onChanged: (value) => controller.onParticipationStatusChanged(
                  isParticipating: value),
            ),
          ],
        ),
      ),
    );
  }

  Widget get saveAvatarButton => Conditional.single(
      context: context,
      conditionBuilder: (context) => controller.userAvatar != null,
      widgetBuilder: (context) => Conditional.single(
            context: context,
            conditionBuilder: (context) => !controller.isProcessing,
            widgetBuilder: (context) => Container(
              alignment: Alignment(.85, 1),
              padding: EdgeInsets.only(top: 120.0),
              child: FlatButton(
                color: Colors.white,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.lightBlue),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.lightBlue)),
                onPressed: controller.saveAvatar,
              ),
            ),
            fallbackBuilder: (context) => avatarSavingButton,
          ),
      fallbackBuilder: (context) => EmptyContainer());

  Widget get updateAvatarButton => Conditional.single(
        context: context,
        conditionBuilder: (context) => controller.userAvatar == null,
        widgetBuilder: (context) => Container(
          alignment: Alignment(.85, 1),
          padding: EdgeInsets.only(top: 120.0),
          child: FlatButton(
            color: Colors.white,
            padding: EdgeInsets.all(10.0),
            child: Text(
              "Update Avatar",
              style: TextStyle(color: Colors.lightBlue),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.lightBlue)),
            onPressed: () {
              showDialog(
                context: context,
                builder: buildProfileImageDialog,
              );
            },
          ),
        ),
        fallbackBuilder: (context) => EmptyContainer(),
      );
}
