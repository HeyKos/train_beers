import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/event_participant_entity.dart';
import '../../../domain/entities/user_entity.dart';
import 'profile_presenter.dart';

class ProfileController extends Controller {
  /// Members
  String _avatarPath;
  final EventEntity _event;
  bool _isParticipating = false;
  bool _isProcessing = false;
  EventParticipantEntity _participant;
  String _participationImageUrl;
  StorageUploadTask _uploadTask;
  UserEntity _user;
  File _userAvatar;
  final ProfilePresenter profilePresenter;

  /// Properties
  String get avatarPath => _avatarPath;
  EventEntity get event => _event;
  bool get isParticipating => _isParticipating;
  bool get isProcessing => _isProcessing;
  EventParticipantEntity get participant => _participant;
  String get participationImageUrl => _participationImageUrl;
  StorageUploadTask get uploadTask => _uploadTask;
  UserEntity get user => _user;
  File get userAvatar => _userAvatar;

  // Constructor
  ProfileController(filesRepo, usersRepo, participationRepo, EventEntity event,
      UserEntity user)
      : profilePresenter =
            ProfilePresenter(filesRepo, usersRepo, participationRepo),
        _event = event,
        _user = user,
        super() {
    getAvatarDownloadUrl(_user.id, _user.avatarPath);
    getParticipant(event, user);
    _participationImageUrl =
        getParticipationImage(isParticipating: _isParticipating);
  }

  /// Overrides
  // this is called automatically by the parent class
  @override
  void initListeners() {
    initCropImageListeners();
    initGetAvatarUrlListeners();
    initGetEventParticipantListeners();
    initUpdateParticipationListeners();
    initUpdateUserListeners();
    initUploadFileListeners();
  }

  @override
  void dispose() {
    profilePresenter.dispose();
    super.dispose();
  }

  /// Listener Initializers
  void initCropImageListeners() {
    profilePresenter.cropImageOnNext = (croppedImage) {
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
    profilePresenter.getAvatarUrlOnNext = (url) {
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

  void initGetEventParticipantListeners() {
    profilePresenter.getEventParticipantOnNext = (participant) {
      print('Get event participant onNext');
      _participant = participant;
      refreshUI();
    };

    profilePresenter.getEventParticipantOnComplete = () {
      print('Get event participant complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.getEventParticipantOnError = (e) {
      print('Could not get event participant.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initUpdateParticipationListeners() {
    profilePresenter.updateParticipationOnNext = (participant) {
      _participant = participant;
      print('Update participation onNext');
    };

    profilePresenter.updateUserOnComplete = () {
      print('Update participation complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.updateParticipationOnError = (e) {
      print('Could not update participation.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initUpdateUserListeners() {
    profilePresenter.updateUserOnNext = (user) {
      print('Update user onNext');
      _user = user;
      getAvatarDownloadUrl(_user.id, _user.avatarPath);
      refreshUI();
    };

    profilePresenter.updateUserOnComplete = () {
      print('Update user complete');
      _isProcessing = false;
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
    profilePresenter.uploadFileOnNext = (uploadTask) {
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

  /// Methods
  void cropImage() => profilePresenter.cropImage(userAvatar);

  Future<void> pickImage(ImageSource source) async {
    var selected = await ImagePicker.pickImage(source: source);
    _userAvatar = selected;
    cropImage();
    refreshUI();
  }

  void getAvatarDownloadUrl(String id, String path) =>
    profilePresenter.getAvatarDownloadUrl(id, path);

  void getParticipant(EventEntity event, UserEntity user) =>
    profilePresenter.getEventParticipant(event, user);

  String getParticipationImage({bool isParticipating = false}) {
    final random = Random();

    if (isParticipating) {
      var activeImages = [
        "https://media.giphy.com/media/xT1R9XnFJkL1S2BFqo/giphy.gif",
        "https://media.giphy.com/media/J0ySNzZ5APILC/giphy.gif",
        "https://media.giphy.com/media/l0Iy8G3PwyahZST2E/giphy.gif",
        "https://media.giphy.com/media/SikKQ1GKktmFy/giphy.gif",
        "https://media.giphy.com/media/AwkqAwhwqGzg4/giphy-downsized-large.gif",
        "https://media.giphy.com/media/jJqWEAYkWrxWE/giphy.gif",
        "https://media.giphy.com/media/NJH9I3N8E9bEI/giphy-downsized-large.gif",
        "https://media.giphy.com/media/NmeQFehO2NQDC/giphy.gif",
        "https://media.giphy.com/media/xPvFvShnCDsoU/giphy-downsized-large.gif",
        "https://media.giphy.com/media/d1E1wpmnxLbCgtEs/giphy.gif",
        "https://media.giphy.com/media/11RZG9KdXd1Nrk0ppD/giphy.gif",
        "https://media.giphy.com/media/SEre9eirTBgdO/giphy.gif",
      ];

      return activeImages[random.nextInt(activeImages.length)];
    }

    var inactiveImages = [
      "https://media.giphy.com/media/cOkd84no1LuKc/giphy.gif",
      "https://media.giphy.com/media/jHns0TlgQSdDa/giphy.gif",
      "https://media.giphy.com/media/1JyWrrkCIUQyQ/giphy.gif",
      "https://media.giphy.com/media/U4VXRfcY3zxTi/giphy.gif",
      "https://media.giphy.com/media/H4zeDO4ocDYqY/giphy.gif",
      "https://media.giphy.com/media/44Eq3Ab5LPYn6/giphy.gif",
      "https://media.giphy.com/media/Qe5oD5aXjEbKw/giphy.gif",
      "https://media.giphy.com/media/aZ3LDBs1ExsE8/giphy.gif",
      "https://media.giphy.com/media/eIPM3j6YXHKXC/giphy.gif",
      "https://media.giphy.com/media/xUOxf3GAHOVjTG3Juw/giphy-downsized-large.gif",
      "https://media.giphy.com/media/BIN2S0sgQwdeE/giphy.gif",
    ];

    return inactiveImages[random.nextInt(inactiveImages.length)];
  }

  void onParticipationStatusChanged({bool isParticipating = false}) {
    _isParticipating = isParticipating;
    _participationImageUrl =
        getParticipationImage(isParticipating: isParticipating);
    refreshUI();
    updateParticipation(_event, _user);
  }

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

    if (event.storageMetadata.name.isEmpty) {
      return;
    }

    if (event.storageMetadata.path.isEmpty) {
      return;
    }

    _user.avatarPath = "${event.storageMetadata.path}";
    _userAvatar = null;
    updateUser(user);
  }

  void updateParticipation(EventEntity event, UserEntity user) =>
      profilePresenter.updateParticipation(event, user);

  void updateUser(UserEntity user) => profilePresenter.updateUser(user);

  void uploadAvatar(File file) => profilePresenter.uploadAvatar(file);
}
