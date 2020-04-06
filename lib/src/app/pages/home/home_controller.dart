import 'package:train_beers/src/app/pages/pages.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomeController extends Controller {
  /// Members
  String _avatarPath;
  UserEntity _nextUser;
  UserEntity _user;
  final HomePresenter homePresenter;
  
  /// Properties
  String get avatarPath => _avatarPath;
  UserEntity get nextUser => _nextUser;
  UserEntity get user => _user;

  // Constructor
  HomeController(filesRepo, usersRepo, authRepo, UserEntity user) :
    homePresenter = HomePresenter(filesRepo, usersRepo, authRepo),
    _user = user,
    super() {
      getNextUser();
    }

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initGetAvatarUrlListeners();
    initGetNextUserListeners();
    initLogoutListeners();
    initUpdateUserListeners();
  }

  @override
  void dispose() {
    homePresenter.dispose();
    super.dispose();
  }

  /// Methods
  void initGetAvatarUrlListeners() {
    homePresenter.getAvatarUrlOnNext = (String url) {
      print('Get avatar url onNext');
      _avatarPath = url;
      refreshUI();
    };

    homePresenter.getAvatarUrlOnComplete = () {
      print('Get avatar url complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getAvatarUrlOnError = (e) {
      print('Could not get avatar url.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }
  
  void initGetNextUserListeners() {
    homePresenter.getNextUserOnNext = (UserEntity user) {
      print(user.toString());
      _nextUser = user;
      getAvatarDownloadUrl(_nextUser.avatarPath);
      refreshUI(); // Refreshes the UI manually
    };
    homePresenter.getNextUserOnComplete = () {
      print('User retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getNextUserOnError = (e) {
      print('Could not retrieve next user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      _nextUser = null;
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initLogoutListeners() {
    homePresenter.logoutOnNext = () {
      print('Logout onNext');
    };

    homePresenter.logoutOnComplete = () {
      // Take the user to the login page, and pop all existing routes.
      Navigator.of(getContext()).pushNamedAndRemoveUntil(Pages.login, ModalRoute.withName(Pages.login));
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.logoutOnError = (e) {
      print('Could not logout user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initUpdateUserListeners() {
    homePresenter.updateUserOnNext = (UserEntity user) {
      print('Update user onNext');
      _user = user;
      refreshUI();
    };

    homePresenter.updateUserOnComplete = () {
      print('Update user complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.updateUserOnError = (e) {
      print('Could not update user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getNextUser() => homePresenter.getNextUser(_nextUser == null ? -1 : _nextUser.sequence);
  // void getNextUser() {
  //   Navigator.of(getContext()).pushNamed(Pages.active_users);
  // }

  void getAvatarDownloadUrl(String path) => homePresenter.getAvatarDownloadUrl(path);

  void logout() => homePresenter.logout();

  void updateUser(UserEntity user) => homePresenter.updateUser(user);

  bool shouldDisplayCountdown() => homePresenter.shouldDisplayCountdown();

  void onMenuOptionChange(String value) => homePresenter.onMenuOptionChange(value, _user, getContext());
}