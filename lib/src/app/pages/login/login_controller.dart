import 'package:train_beers/src/app/pages/pages.dart';

import './login_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LoginController extends Controller {
  // Text Field controllers
  TextEditingController emailTextController;
  TextEditingController passwordTextController;
  final LoginPresenter loginPresenter;
  bool _success;
  bool get success => _success;
  String _userIdentifier;
  String get userIdentifier => _userIdentifier;
  // Presenter should always be initialized this way
  LoginController(loginRepo) : loginPresenter = LoginPresenter(loginRepo), super() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  // this is called automatically by the parent class
  @override
  void initListeners() {
    loginPresenter.loginOnNext = (bool success, String userIdentifier) {
      _success = success;
      _userIdentifier = userIdentifier;
    };
    loginPresenter.loginOnComplete = () {
      Navigator.of(getContext()).pushReplacementNamed(Pages.splash, arguments: {
        "uid": _userIdentifier
      });
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    loginPresenter.loginOnError = (e) {
      print('Login attemp failed.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      _success = false;
      _userIdentifier = "";
      refreshUI(); // Refreshes the UI manually
    };
  }

  void login() {
    loginPresenter.login(emailTextController.text, passwordTextController.text);
  }

  @override
  void onResumed() {
    print("On resumed");
    super.onResumed();
  }

  @override
  void dispose() {
    loginPresenter.dispose();
    super.dispose();
  }
}