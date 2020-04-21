import 'package:train_beers/src/app/pages/pages.dart';
import 'package:train_beers/src/domain/entities/event_entity.dart';
import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import './home_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomeController extends Controller {
  /// Members
  String _avatarPath;
  EventEntity _event;
  Color _eventProgressColor = Colors.blue;
  String _eventProgressMessage = "Buy Beer";
  double _eventProgressPercent = 0;
  List<EventParticipantEntity> _participants;
  UserEntity _user;
  final HomePresenter homePresenter;
  
  /// Properties
  String get avatarPath => _avatarPath;
  EventEntity get event => _event;
  Color get eventProgressColor => _eventProgressColor;
  String get eventProgressMessage => _eventProgressMessage;
  double get eventProgressPercent => _eventProgressPercent;
  List<EventParticipantEntity> get participants => _participants;
  UserEntity get user => _user;

  // Constructor
  HomeController(filesRepo, usersRepo, authRepo, eventsRepo, eventParticipantsRepo, UserEntity user) :
    homePresenter = HomePresenter(filesRepo, usersRepo, authRepo, eventsRepo, eventParticipantsRepo),
    _user = user,
    super() {
      getNextEvent();
    }

  /// Overrides
  @override
  // this is called automatically by the parent class
  void initListeners() {
    initGetAvatarUrlListeners();
    initGetEventParticipantsListeners();
    initGetNextEventListeners();
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

  void initGetEventParticipantsListeners() {
    homePresenter.getEventParticipantsOnNext = (List<EventParticipantEntity> eventParticipants) {
      _participants = eventParticipants;
      setPercent();
      refreshUI();
    };
    homePresenter.getEventParticipantsOnComplete = () {
      print('Event participants retrieved');
    };

    // On error, show a snackbar, and refresh the UI
    homePresenter.getEventParticipantsOnError = (e) {
      print('Could not retrieve event participants.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI();
    };
  }

  Future<void> setPercent() async {
    while (_eventProgressPercent < 100) {
      _eventProgressPercent++;
      if (_eventProgressPercent < 33) {
        _eventProgressMessage = "Buy Beer";
      } 
      else if (_eventProgressPercent < 100) {
        _eventProgressMessage = "Bring Beer";
      }
      else {
        _eventProgressMessage = "Drink Beer";
        _eventProgressColor = Colors.green;
      }
      refreshUI();
      await new Future.delayed(const Duration(milliseconds: 10));
    }
  }
  
  void initGetNextEventListeners() {
    homePresenter.getNextEventOnNext = (EventEntity event) {
      _event = event;
      if (_event.hostUser != null) {
        getAvatarDownloadUrl(_event.hostUser.id, _event.hostUser.avatarPath);
      }

      getEventParticipants(_event.id);
      refreshUI();
    };
    homePresenter.getNextEventOnComplete = () {
      print('Event retrieved');
    };

    // On error, show a snackbar, and refresh the UI
    homePresenter.getNextEventOnError = (e) {
      print('Could not retrieve next event.');
      ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI();
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
      refreshUI();
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
      refreshUI();
    };
  }

  void goToActiveDrinkers() {
    Navigator.of(getContext()).pushNamed(Pages.participants, arguments: {
      "participants": _participants,
    });
  }

  void getAvatarDownloadUrl(String id, String path) => homePresenter.getAvatarDownloadUrl(id, path);

  void getEventParticipants(String eventId) => homePresenter.getEventParticipants(eventId);

  /// Note: In order to allow this method to work with a [RefreshIndicator]
  /// we have to make it a Future. The functionality is already async, 
  /// but accomplishes it with an observer.
  Future<void> getNextEvent() async => await homePresenter.getNextEvent();

  void logout() => homePresenter.logout();

  void updateUser(UserEntity user) => homePresenter.updateUser(user);

  bool shouldDisplayCountdown() => homePresenter.shouldDisplayCountdown();

  void onMenuOptionChange(String value) => homePresenter.onMenuOptionChange(value, _user, getContext());
}