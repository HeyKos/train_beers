import 'package:train_beers/src/app/pages/pages.dart';
import './splash_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';

class SplashController extends Controller {
  final SplashPresenter splashPresenter;

  // Presenter should always be initialized this way
  SplashController(userRepo, uid) : splashPresenter = SplashPresenter(userRepo, uid), super() {
    getUserbyUid(uid);
  }

  @override
  void initListeners() {
    splashPresenter.getUserByUidOnNext = (UserEntity user) async {
      await new Future.delayed(const Duration(seconds: 5));
      goHome(user);
    };

    splashPresenter.getUserByUidOnComplete = () {};

    // On error, show a snackbar, remove the user, and refresh the UI
    splashPresenter.getUserByUidOnError = (e) {
      print('Error getting user data.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getUserbyUid(String uid) {
    splashPresenter.getUser(uid);
  }

  void goHome(UserEntity user) {
    Navigator.of(getContext()).pushReplacementNamed(Pages.home, arguments: {
      "key": "Home",
      "user": user
    });
  }

  @override
  void onResumed() {
    print("On resumed");
    super.onResumed();
  }

  @override
  void dispose() {
    splashPresenter.dispose();
    super.dispose();
  }
}