import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
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
  
  /// Members
  File _imageFile;

  @override
  Widget buildPage() {
    return Scaffold(

      // Select an image from the camera or gallery
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () => _pickImage(ImageSource.camera),
            ),
            IconButton(
              icon: Icon(Icons.photo_library),
              onPressed: () => _pickImage(ImageSource.gallery),
            ),
          ],
        ),
      ),

      // Preview the image and crop it
      body: ListView(
        children: <Widget>[
          if (_imageFile != null) ...[

            Image.file(_imageFile),

            Row(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.crop),
                  onPressed: _cropImage,
                ),
                FlatButton(
                  child: Icon(Icons.refresh),
                  onPressed: _clear,
                ),
              ],
            ),

            // TODO: Add the below line once the Uploader widget exists
            Uploader(file: _imageFile)
          ]
        ],
      ),
    );
  } 

  /// Methods
  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
        androidUiSettings: AndroidUiSettings(
          lockAspectRatio: true,
          toolbarTitle: "Crop Image",
        ),
      );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  /// Properties (Widgets)
}
