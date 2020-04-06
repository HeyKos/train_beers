import 'package:train_beers/src/app/pages/pages.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'profile_presenter.dart';

class ProfileController extends Controller {
  /// Members
  String _avatarPath;
  UserEntity _user;
  final ProfilePresenter profilePresenter;
  
  /// Properties
  String get avatarPath => _avatarPath;
  UserEntity get user => _user;

  // Constructor
  ProfileController(filesRepo, usersRepo, UserEntity user) :
    profilePresenter = ProfilePresenter(filesRepo, usersRepo),
    _user = user,
    super() {
      getAvatarDownloadUrl(_user.avatarPath);
    }

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initUpdateUserListeners();
    initGetAvatarUrlListeners();
  }

  @override
  void dispose() {
    profilePresenter.dispose();
    super.dispose();
  }

  /// Methods
  void initGetAvatarUrlListeners() {
    profilePresenter.getAvatarUrlOnNext = (String url) {
      print('Get avatar url onNext');
      _avatarPath = url;
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

  void getAvatarDownloadUrl(String path) => profilePresenter.getAvatarDownloadUrl(path);

  void goToUpdateProfilePicture() {
    Navigator.pushNamed(getContext(), Pages.updateProfilePicture, arguments: {
      "user": user
    });
  }

  void updateUser(UserEntity user) => profilePresenter.updateUser(user);
}
