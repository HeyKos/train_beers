import 'package:flutter/material.dart';
import 'package:train_beers/src/app/pages/pages.dart';
import 'package:train_beers/src/app/utils/constants.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/usecases/countdown_use_case.dart';
import 'package:train_beers/src/domain/usecases/get_active_users_usecase.dart';
import 'package:train_beers/src/domain/usecases/get_avatar_url_usecase.dart';
import 'package:train_beers/src/domain/usecases/get_event_participants_usecase.%20copy.dart';
import 'package:train_beers/src/domain/usecases/get_next_event_usecase..dart';
import 'package:train_beers/src/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';

class HomePresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function getActiveUsersOnNext;
  Function getActiveUsersOnComplete;
  Function getActiveUsersOnError;
  Function getAvatarUrlOnNext;
  Function getAvatarUrlOnComplete;
  Function getAvatarUrlOnError;
  Function getEventParticipantsOnNext;
  Function getEventParticipantsOnComplete;
  Function getEventParticipantsOnError;
  Function getNextEventOnNext;
  Function getNextEventOnComplete;
  Function getNextEventOnError;
  Function logoutOnNext;
  Function logoutOnComplete;
  Function logoutOnError;
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;

  /// Use Case Objects
  final GetActiveUsersUseCase getActiveUsersUseCase;
  final GetAvatarUrlUseCase getAvatarUrlUseCase;
  final GetEventParticipantsUseCase getEventParticipantsUseCase;
  final GetNextEventUseCase getNextEventUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final CountdownUseCase countdownUseCase;

  /// Constructor
  HomePresenter(filesRepo, usersRepo, authRepo, eventsRepo, eventParticipantsRepo) :
    getActiveUsersUseCase = GetActiveUsersUseCase(usersRepo),
    getAvatarUrlUseCase = GetAvatarUrlUseCase(filesRepo),
    getEventParticipantsUseCase = GetEventParticipantsUseCase(eventParticipantsRepo),
    getNextEventUseCase = GetNextEventUseCase(eventsRepo),
    logoutUseCase = LogoutUseCase(authRepo),
    updateUserUseCase = UpdateUserUseCase(usersRepo),
    countdownUseCase = CountdownUseCase();

  /// Overrides
  @override
  void dispose() {
    getActiveUsersUseCase.dispose();
    getAvatarUrlUseCase.dispose();
    getEventParticipantsUseCase.dispose();
    getNextEventUseCase.dispose();
    logoutUseCase.dispose();
    updateUserUseCase.dispose();
  }

  /// Methods
  void getActiveUsers() {
    getActiveUsersUseCase.execute(_GetActiveUsersUseCaseObserver(this), null);
  }

  void getAvatarDownloadUrl(String id, String path) {
    getAvatarUrlUseCase.execute(_GetAvatarUrlUseCaseObserver(this), GetAvatarUrlUseCaseParams(id, path));
  }

  void getEventParticipants(String eventId) {
    getEventParticipantsUseCase.execute(_GetEventParticipantsUseCaseObserver(this), GetEventParticipantsUseCaseParams(eventId));
  }
  
  void getNextEvent() {
    getNextEventUseCase.execute(_GetNextEventUseCaseObserver(this), null);
  }

  void logout() {
    logoutUseCase.execute(_LogoutUseCaseObserver(this));
  }

  void updateUser(UserEntity user) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }

  void goToProfile(UserEntity user, BuildContext context) {
    Navigator.pushNamed(context, Pages.profile, arguments: {
      "user": user
    });
  }

  bool shouldDisplayCountdown() => countdownUseCase.shouldDisplayCountdown();

  void onMenuOptionChange(String value, UserEntity user, BuildContext context) {
    switch(value) {
      case Constants.PROFILE:
        goToProfile(user, context);
        break;
      case Constants.SETTINGS:
        print("Tapped Settings");
        break;
      case Constants.SIGN_OUT:
      default:
        logout();
        break;
    }
  }
}

/// Observer Classes

/// An observer class for the [GetActiveUsersUseCase].
class _GetActiveUsersUseCaseObserver extends Observer<GetActiveUsersUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _GetActiveUsersUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.getActiveUsersOnComplete != null);
    presenter.getActiveUsersOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getActiveUsersOnError != null);
    presenter.getActiveUsersOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getActiveUsersOnNext != null);
    presenter.getActiveUsersOnNext(response.users);
  }
}

/// An observer class for the [GetAvatarUrlUseCase].
class _GetAvatarUrlUseCaseObserver extends Observer<GetAvatarUrlUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _GetAvatarUrlUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.getAvatarUrlOnComplete != null);
    presenter.getAvatarUrlOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getAvatarUrlOnError != null);
    presenter.getAvatarUrlOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getAvatarUrlOnNext != null);
    presenter.getAvatarUrlOnNext(response.url);
  }
}

/// An observer class for the [GetEventParticipantsUseCase].
class _GetEventParticipantsUseCaseObserver extends Observer<GetEventParticipantsUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _GetEventParticipantsUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.getEventParticipantsOnComplete != null);
    presenter.getEventParticipantsOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getEventParticipantsOnError != null);
    presenter.getEventParticipantsOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getEventParticipantsOnNext != null);
    presenter.getEventParticipantsOnNext(response.eventParticipants);
  }
}

/// An observer class for the [GetNextEventUseCase].
class _GetNextEventUseCaseObserver extends Observer<GetNextEventUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _GetNextEventUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.getNextEventOnComplete != null);
    presenter.getNextEventOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getNextEventOnError != null);
    presenter.getNextEventOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getNextEventOnNext != null);
    presenter.getNextEventOnNext(response.event);
  }
}

/// An observer class for the [LogoutUserUseCase].
class _LogoutUseCaseObserver extends Observer<void> {
  /// Members
  final HomePresenter presenter;

  /// Constructor
  _LogoutUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.logoutOnComplete != null);
    presenter.logoutOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.logoutOnError != null);
    presenter.logoutOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.logoutOnNext != null);
    presenter.logoutOnNext();
  }
}

/// An observer class for the [UpdateUserUseCase].
class _UpdateUserUseCaseObserver extends Observer<UpdateUserUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _UpdateUserUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.updateUserOnComplete != null);
    presenter.updateUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.updateUserOnError != null);
    presenter.updateUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.updateUserOnNext != null);
    presenter.updateUserOnNext(response.user);
  }
}
