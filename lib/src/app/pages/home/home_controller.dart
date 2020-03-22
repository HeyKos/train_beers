import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomeController extends Controller {
  UserEntity _nextUser;
  UserEntity _currentUser;
  
  UserEntity get nextUser => _nextUser;
  UserEntity get currentUser => _currentUser;
  final HomePresenter homePresenter;
  // Presenter should always be initialized this way
  HomeController(usersRepo, authRepo) :
    homePresenter = HomePresenter(usersRepo, authRepo),
    super();

  @override
  // this is called automatically by the parent class
  void initListeners() {
    initGetNextUserListeners();
    initGetUserByUidListeners();
    initLogoutListeners();
  }

  void initGetNextUserListeners() {
    homePresenter.getNextUserOnNext = (UserEntity user) {
      print(user.toString());
      _nextUser = user;
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

  void initGetUserByUidListeners() {
    homePresenter.getUserByUidOnNext = (UserEntity user) {
      print(user.toString());
      _currentUser = user;
      refreshUI(); // Refreshes the UI manually
    };
    homePresenter.getUserByUidOnComplete = () {
      print('Current User retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getUserByUidOnError = (e) {
      print('Could not retrieve current user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      _currentUser = null;
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initLogoutListeners() {
    homePresenter.logoutOnNext = () {
      print('Logout onNext');
    };
    homePresenter.logoutOnComplete = () {
      print('Logout complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.logoutOnError = (e) {
      print('Could not logout user.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getNextUser() => homePresenter.getNextUser(_nextUser == null ? -1 : _nextUser.sequence);

  void logout() => homePresenter.logout();

  void getUserByUid(String uid) => homePresenter.getUserByUid(uid);

  @override
  void dispose() {
    homePresenter.dispose();
    super.dispose();
  }
}