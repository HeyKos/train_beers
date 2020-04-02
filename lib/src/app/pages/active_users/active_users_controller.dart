import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'active_users_presenter.dart';

class ActiveUsersController extends Controller {
  /// Members
  List<UserEntity> _users;
  final ActiveUsersPresenter activeUsersPresenter;
  
  /// Properties
  List<UserEntity> get users => _users;

  // Constructor
  ActiveUsersController(usersRepo) :
    activeUsersPresenter = ActiveUsersPresenter(usersRepo),
    super() {
      getActiveUsers();
    }

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initGetActiveUsersListeners();
  }

  @override
  void dispose() {
    activeUsersPresenter.dispose();
    super.dispose();
  }

  /// Methods
  void initGetActiveUsersListeners() {
    activeUsersPresenter.getActiveUsersOnNext = (List<UserEntity> users) {
      print(users.toString());
      _users = users;
      refreshUI(); // Refreshes the UI manually
    };
    
    activeUsersPresenter.getActiveUsersOnComplete = () {
      print('Active users retrieved');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    activeUsersPresenter.getActiveUsersOnError = (e) {
      print('Could not retrieve active users.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      _users = null;
      refreshUI(); // Refreshes the UI manually
    };
  }

  void getActiveUsers() => activeUsersPresenter.getActiveUsers();
}