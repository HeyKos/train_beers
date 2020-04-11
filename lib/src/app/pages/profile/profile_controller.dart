import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'profile_presenter.dart';

class ProfileController extends Controller {
  /// Members
  String _avatarPath;
  bool _isProcessing = false;
  StorageUploadTask _uploadTask;
  UserEntity _user;
  File _userAvatar;
  final ProfilePresenter profilePresenter;
  
  /// Properties
  String get avatarPath => _avatarPath;
  bool get isProcessing => _isProcessing;
  StorageUploadTask get uploadTask => _uploadTask;
  UserEntity get user => _user;
  File get userAvatar => _userAvatar;

  // Constructor
  ProfileController(filesRepo, usersRepo, UserEntity user) :
    profilePresenter = ProfilePresenter(filesRepo, usersRepo),
    _user = user,
    super() {
      getAvatarDownloadUrl(_user.id, _user.avatarPath);
    }

  /// Overrides
  // this is called automatically by the parent class
  @override
  void initListeners() {
    initCropImageListeners();
    initGetAvatarUrlListeners();
    initUpdateUserListeners();
    initUploadFileListeners();
  }

  @override
  void dispose() {
    profilePresenter.dispose();
    super.dispose();
  }

  /// Methods
  void cropImage() => profilePresenter.cropImage(userAvatar);
  
  Future<void> pickImage(ImageSource source) async {
    File selected = await ImagePicker.pickImage(source: source);
    _userAvatar = selected;
    cropImage();
    refreshUI();
  }

  void initCropImageListeners() {
    profilePresenter.cropImageOnNext = (File croppedImage) {
      print('Crop image onNext');
      _userAvatar = croppedImage;
      Navigator.of(getContext(), rootNavigator: true).pop();
      refreshUI();
    };

    profilePresenter.cropImageOnComplete = () {
      print('Crop image complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.cropImageOnError = (e) {
      print('Could not crop image.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initGetAvatarUrlListeners() {
    profilePresenter.getAvatarUrlOnNext = (String url) {
      print('Get avatar url onNext');
      _avatarPath = url;
      _userAvatar = null;
      refreshUI();
    };

    profilePresenter.getAvatarUrlOnComplete = () {
      print('Get avatar url complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.getAvatarUrlOnError = (e) {
      print('Could not get avatar url.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initUpdateUserListeners() {
    profilePresenter.updateUserOnNext = (UserEntity user) {
      print('Update user onNext');
      _user = user;
      getAvatarDownloadUrl(_user.id, _user.avatarPath);
      refreshUI();
    };

    profilePresenter.updateUserOnComplete = () {
      print('Update user complete');
      this._isProcessing = false;
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.updateUserOnError = (e) {
      print('Could not update user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initUploadFileListeners() {
    profilePresenter.uploadFileOnNext = (StorageUploadTask uploadTask) {
      print('Upload file onNext');
      _uploadTask = uploadTask;
      refreshUI();
    };

    profilePresenter.uploadFileOnComplete = () {
      print('Upload file complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.uploadFileOnError = (e) {
      print('Could not upload file.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getAvatarDownloadUrl(String id, String path) => profilePresenter.getAvatarDownloadUrl(id, path);

  void saveAvatar() {
    _isProcessing = true;
    profilePresenter.uploadAvatar(_userAvatar);
    refreshUI();
  }

  void uploadStatusOnChange(StorageTaskSnapshot event) {
    if (event == null) {
      return;
    }
    
    if (event.bytesTransferred != event.totalByteCount) {
      return;
    }

    if (event.storageMetadata == null) {
      return;
    }

    if (event.error != null && event.error > 0) {
      // TODO: Come up with a better UX for this scenario.
      print("An error code ($event.error) was returned.");
      return;
    }

    if (event.storageMetadata.name.isEmpty || event.storageMetadata.path.isEmpty) {
      return;
    }

    _user.avatarPath = "${event.storageMetadata.path}";
    _userAvatar = null;
    updateUser(user);
  }

  void updateUser(UserEntity user) => profilePresenter.updateUser(user);

  void uploadAvatar(File file) => profilePresenter.uploadAvatar(file);
}
