import 'package:firebase_storage/firebase_storage.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'update_profile_picture_presenter.dart';

class UpdateProfilePictureController extends Controller {
  /// Members
  UserEntity _user;
  final UpdateProfilePicturePresenter updateProfilePicturePresenter;
  
  /// Properties
  UserEntity get user => _user;

  // Constructor
  UpdateProfilePictureController(usersRepo, UserEntity user) :
    updateProfilePicturePresenter = UpdateProfilePicturePresenter(usersRepo),
    _user = user,
    super();

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initUpdateUserListeners();
  }

  @override
  void dispose() {
    updateProfilePicturePresenter.dispose();
    super.dispose();
  }

  /// Methods
  void initUpdateUserListeners() {
    updateProfilePicturePresenter.updateUserOnNext = (UserEntity user) {
      print('Update user onNext');
      _user = user;
      refreshUI();
    };

    updateProfilePicturePresenter.updateUserOnComplete = () {
      print('Update user complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    updateProfilePicturePresenter.updateUserOnError = (e) {
      print('Could not update user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void updateUser(UserEntity user) => updateProfilePicturePresenter.updateUser(user);

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
  }
}
