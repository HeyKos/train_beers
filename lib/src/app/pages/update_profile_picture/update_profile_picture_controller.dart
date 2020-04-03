import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'update_profile_picture_presenter.dart';

class UpdateProfilePictureController extends Controller {
  /// Members
  UserEntity _user;
  final UpdateProfilePicturePresenter profilePresenter;
  
  /// Properties
  UserEntity get user => _user;

  // Constructor
  UpdateProfilePictureController(usersRepo, UserEntity user) :
    profilePresenter = UpdateProfilePicturePresenter(usersRepo),
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
    profilePresenter.dispose();
    super.dispose();
  }

  /// Methods
  void initUpdateUserListeners() {
    profilePresenter.updateUserOnNext = (UserEntity user) {
      print('Update user onNext');
      _user = user;
      refreshUI();
    };

    profilePresenter.updateUserOnComplete = () {
      print('Update user complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    profilePresenter.updateUserOnError = (e) {
      print('Could not update user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void updateUser(UserEntity user) => profilePresenter.updateUser(user);
}
