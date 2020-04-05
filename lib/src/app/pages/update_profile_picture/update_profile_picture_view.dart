import 'package:image_picker/image_picker.dart';
import 'package:train_beers/src/app/widgets/uploader.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/data/repositories/firebase_users_repository.dart';
import 'update_profile_picture_controller.dart';

class UpdateProfilePicturePage extends View {
  final String title;
  final UserEntity user;
  
  UpdateProfilePicturePage({
    Key key,
    this.title,
    @required this.user,
  }) : super(key: key);
  

  @override
  // inject dependencies inwards
  _UpdateProfilePicturePageState createState() => _UpdateProfilePicturePageState(user);
}

class _UpdateProfilePicturePageState extends ViewState<UpdateProfilePicturePage, UpdateProfilePictureController> {
  _UpdateProfilePicturePageState(user) : super(UpdateProfilePictureController(FirebaseUsersRepository(), user));

  @override
  Widget buildPage() {
    var hasImage = controller.userAvatar != null;
    return Scaffold(

      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => controller.pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => controller.pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (hasImage) ...[
            Image.file(controller.userAvatar),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: controller.cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: controller.clear,
                ),
              ],
            ),
            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.save),
                  onPressed: () => controller.updateUser(controller.user),
                ),
              ]
            ),
            Uploader(
              file: controller.userAvatar,
              updater: controller.uploadStatusOnChange
            ),
          ]
        ],
      ),
    );
  } 

  /// Methods
}
