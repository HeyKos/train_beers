import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/event_participant_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/enums/event_status.dart';
import '../../../domain/repositories/authentication_repository.dart';
import '../../../domain/repositories/event_participants_repository.dart';
import '../../../domain/repositories/events_repository.dart';
import '../../../domain/repositories/files_repository.dart';
import '../../../domain/repositories/users_repository.dart';
import '../pages.dart';
import './home_presenter.dart';

class HomeController extends Controller {
  // Constructor
  HomeController(
      FilesRepository filesRepo,
      UsersRepository usersRepo,
      AuthenticationRepository authRepo,
      EventsRepository eventsRepo,
      EventParticipantsRepository eventParticipantsRepo,
      UserEntity user)
      : homePresenter = HomePresenter(
            filesRepo, usersRepo, authRepo, eventsRepo, eventParticipantsRepo),
        _user = user,
        super() {
    getNextEvent();
  }

  /// Members
  String _avatarPath;
  EventEntity _event;
  Color _eventProgressColor = Colors.blue;
  String _eventProgressMessage = EventStatus.buyBeer.value;
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

  /// Overrides
  @override
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

  /// Listener Initializers
  void initGetAvatarUrlListeners() {
    homePresenter.getAvatarUrlOnNext = (url) {
      print('Get avatar url onNext');
      _avatarPath = url;
      refreshUI();
    };

    homePresenter.getAvatarUrlOnComplete = () {
      print('Get avatar url complete');
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.getAvatarUrlOnError = (dynamic e) {
      print('Could not get avatar url.');
      final ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message.toString())));
      refreshUI(); // Refreshes the UI manually
    };
  }

  void initGetEventParticipantsListeners() {
    homePresenter.getEventParticipantsOnNext = (eventParticipants) {
      _participants = eventParticipants;
      updateProgress();
      refreshUI();
    };
    homePresenter.getEventParticipantsOnComplete = () {
      print('Event participants retrieved');
    };

    // On error, show a snackbar, and refresh the UI
    homePresenter.getEventParticipantsOnError = (dynamic e) {
      print('Could not retrieve event participants.');
      final ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message.toString())));
      refreshUI();
    };
  }

  void initGetNextEventListeners() {
    homePresenter.getNextEventOnNext = (event) {
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
      final ScaffoldState state = getState();
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
      var route = ModalRoute.withName(Pages.login);
      Navigator.of(getContext()).pushNamedAndRemoveUntil(Pages.login, route);
    };

    // On error, show a snackbar, remove the user, and refresh the UI
    homePresenter.logoutOnError = (e) {
      print('Could not logout user.');
      final ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI();
    };
  }

  void initUpdateUserListeners() {
    homePresenter.updateUserOnNext = (user) {
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
      final ScaffoldState state = getState();
      state.showSnackBar(SnackBar(content: Text(e.message)));
      refreshUI();
    };
  }

  /// Methods  
  void getAvatarDownloadUrl(String id, String path) {
    homePresenter.getAvatarDownloadUrl(id, path);
  }

  void getEventParticipants(String eventId) {
    homePresenter.getEventParticipants(eventId);
  }

  /// Note: In order to allow this method to work with a [RefreshIndicator]
  /// we have to make it a Future. The functionality is already async,
  /// but accomplishes it with an observer.
  Future<void> getNextEvent() async => await homePresenter.getNextEvent();

  String getNextStep() {
    if (_event == null) {
      return EventStatus.buyBeer.value;
    }

    switch(_event.status) {
      case EventStatus.buyBeer:
        return EventStatus.bringBeer.value;
      case EventStatus.bringBeer:
      default:
        return EventStatus.drinkBeer.value;
    }
  }

  void goToActiveDrinkers() {
    Navigator.of(getContext()).pushNamed(Pages.participants, arguments: {
      "participants": _participants,
    });
  }

  void logout() => homePresenter.logout();

  void onMenuOptionChange(String value) {
    homePresenter.onMenuOptionChange(value, _event, _user, getContext());
  }

  bool shouldDisplayCountdown() => homePresenter.shouldDisplayCountdown();

  Future<void> updateProgress() async {
    while (_eventProgressPercent < 100) {
      _eventProgressPercent++;
      if (_eventProgressPercent < 33) {
        _eventProgressMessage = EventStatus.buyBeer.value;
      } else if (_eventProgressPercent < 100) {
        _eventProgressMessage = EventStatus.bringBeer.value;
      } else {
        _eventProgressMessage = EventStatus.drinkBeer.value;
        _eventProgressColor = Colors.green;
      }
      refreshUI();
      return await Future<dynamic>.delayed(const Duration(milliseconds: 10));
    }
  }

  void updateUser(UserEntity user) => homePresenter.updateUser(user);
}
