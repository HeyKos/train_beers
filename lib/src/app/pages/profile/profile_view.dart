import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:train_beers/src/data/repositories/firebase_files_repository.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';
import 'profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  _ProfilePageState(user): 
    super(ProfileController(FirebaseFilesRepository(), FirebaseUsersRepository(), user));

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
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(75.0),
                          child: Conditional.single(
                            context: context,
                            conditionBuilder: (BuildContext context) => controller.avatarPath != null,
                            widgetBuilder: (BuildContext context) {
                              return CachedNetworkImage(
                                imageUrl: controller.avatarPath,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                                width: 150.0,
                                height: 150.0,
                              );
                            },
                            fallbackBuilder: (BuildContext context) => CircularProgressIndicator(),
                          ),
                        )
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
                        // onPressed: controller.goToUpdateProfilePicture,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => buildProfileImageDialog(context),
                          );
                        },
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
  Widget buildProfileImageDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.photo_camera),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Take a photo", 
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                )
              ],
            ),
            onPressed: () => print("Tapped Camera"),
            // onPressed: () => controller.pickImage(ImageSource.camera),
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Icon(Icons.photo_library),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text("Choose a photo",
                     style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                )
              ],
            ),
            onPressed: () => print("Tapped Library"),
            // onPressed: () => controller.pickImage(ImageSource.camera),
          ),
        ],
      ),
    );
  }
}
