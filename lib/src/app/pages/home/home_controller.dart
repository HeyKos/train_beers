import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomeController extends Controller {
  UserEntity _currentUser;
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
    initLogoutListeners();
  }

  void initGetNextUserListeners() {
    homePresenter.getNextUserOnNext = (UserEntity user) {
      print(user.toString());
      _currentUser = user;
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

  void getNextUser() =>
    homePresenter.getNextUser(_currentUser == null ? -1 : _currentUser.sequence);

  void logout() => 
    homePresenter.logout();

  @override
  void dispose() {
    homePresenter.dispose();
    super.dispose();
  }
}