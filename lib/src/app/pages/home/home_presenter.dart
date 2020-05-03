import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/entities/event_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/usecases/countdown_use_case.dart';
import '../../../domain/usecases/get_avatar_url_usecase.dart';
import '../../../domain/usecases/get_event_participants_usecase.dart';
import '../../../domain/usecases/get_next_event_usecase.dart';
import '../../../domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/update_event_usecase.dart';
import '../../../domain/usecases/update_user_usecase.dart';
import '../../utils/constants.dart';
import '../pages.dart';

class HomePresenter extends Presenter {
  /// Members
  /// Use Case Functions
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
  Function updateEventOnNext;
  Function updateEventOnComplete;
  Function updateEventOnError;
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;

  /// Use Case Objects
  final CountdownUseCase countdownUseCase;
  final GetAvatarUrlUseCase getAvatarUrlUseCase;
  final GetEventParticipantsUseCase getEventParticipantsUseCase;
  final GetNextEventUseCase getNextEventUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateEventUseCase updateEventUseCase;
  final UpdateUserUseCase updateUserUseCase;

  /// Constructor
  HomePresenter(
      filesRepo, usersRepo, authRepo, eventsRepo, eventParticipantsRepo)
      : countdownUseCase = CountdownUseCase(),
        getAvatarUrlUseCase = GetAvatarUrlUseCase(filesRepo),
        getEventParticipantsUseCase =
            GetEventParticipantsUseCase(eventParticipantsRepo),
        getNextEventUseCase = GetNextEventUseCase(eventsRepo),
        logoutUseCase = LogoutUseCase(authRepo),
        updateEventUseCase = UpdateEventUseCase(eventsRepo),
        updateUserUseCase = UpdateUserUseCase(usersRepo);

  /// Overrides
  @override
  void dispose() {
    getAvatarUrlUseCase.dispose();
    getEventParticipantsUseCase.dispose();
    getNextEventUseCase.dispose();
    logoutUseCase.dispose();
    updateEventUseCase.dispose();
    updateUserUseCase.dispose();
  }

  /// Methods
  void getAvatarDownloadUrl(String id, String path) {
    getAvatarUrlUseCase.execute(_GetAvatarUrlUseCaseObserver(this),
        GetAvatarUrlUseCaseParams(id, path));
  }

  void getEventParticipants(String eventId) {
    getEventParticipantsUseCase.execute(
        _GetEventParticipantsUseCaseObserver(this),
        GetEventParticipantsUseCaseParams(eventId));
  }

  void getNextEvent() {
    getNextEventUseCase.execute(_GetNextEventUseCaseObserver(this), null);
  }

  void goToProfile(EventEntity event, UserEntity user, BuildContext context) {
    Navigator.pushNamed(context, Pages.profile,
        arguments: {"user": user, "event": event});
  }

  void logout() {
    logoutUseCase.execute(_LogoutUseCaseObserver(this));
  }

  void onMenuOptionChange(
      String value, EventEntity event, UserEntity user, BuildContext context) {
    switch (value) {
      case Constants.profile:
        goToProfile(event, user, context);
        break;
      case Constants.settings:
        print("Tapped Settings");
        break;
      case Constants.signOut:
      default:
        logout();
        break;
    }
  }

  bool shouldDisplayCountdown() => countdownUseCase.shouldDisplayCountdown();

  void updateEvent(EventEntity event) {
    updateEventUseCase.execute(
        _UpdateEventUseCaseObserver(this), UpdateEventUseCaseParams(event));
  }

  void updateUser(UserEntity user) {
    updateUserUseCase.execute(
        _UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }
}

/// Observer Classes

/// An observer class for the [GetAvatarUrlUseCase].
class _GetAvatarUrlUseCaseObserver
    extends Observer<GetAvatarUrlUseCaseResponse> {
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
  void onError(dynamic e) {
    assert(presenter.getAvatarUrlOnError != null);
    presenter.getAvatarUrlOnError(e);
  }

  @override
  void onNext(GetAvatarUrlUseCaseResponse response) {
    assert(presenter.getAvatarUrlOnNext != null);
    presenter.getAvatarUrlOnNext(response.url);
  }
}

/// An observer class for the [GetEventParticipantsUseCase].
class _GetEventParticipantsUseCaseObserver
    extends Observer<GetEventParticipantsUseCaseResponse> {
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
  void onError(dynamic e) {
    assert(presenter.getEventParticipantsOnError != null);
    presenter.getEventParticipantsOnError(e);
  }

  @override
  void onNext(GetEventParticipantsUseCaseResponse response) {
    assert(presenter.getEventParticipantsOnNext != null);
    presenter.getEventParticipantsOnNext(response.eventParticipants);
  }
}

/// An observer class for the [GetNextEventUseCase].
class _GetNextEventUseCaseObserver
    extends Observer<GetNextEventUseCaseResponse> {
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
  void onError(dynamic e) {
    assert(presenter.getNextEventOnError != null);
    presenter.getNextEventOnError(e);
  }

  @override
  void onNext(GetNextEventUseCaseResponse response) {
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
  void onError(dynamic e) {
    assert(presenter.logoutOnError != null);
    presenter.logoutOnError(e);
  }

  @override
  void onNext(void response) {
    assert(presenter.logoutOnNext != null);
    presenter.logoutOnNext();
  }
}

/// An observer class for the [UpdateEventUseCase].
class _UpdateEventUseCaseObserver extends Observer<UpdateEventUseCaseResponse> {
  /// Members
  final HomePresenter presenter;

  /// Constructor
  _UpdateEventUseCaseObserver(this.presenter);

  /// Overrides
  @override
  void onComplete() {
    assert(presenter.updateEventOnComplete != null);
    presenter.updateEventOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.updateEventOnError != null);
    presenter.updateEventOnError(e);
  }

  @override
  void onNext(UpdateEventUseCaseResponse response) {
    assert(presenter.updateEventOnNext != null);
    presenter.updateEventOnNext(response.event);
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
  void onError(dynamic e) {
    assert(presenter.updateUserOnError != null);
    presenter.updateUserOnError(e);
  }

  @override
  void onNext(UpdateUserUseCaseResponse response) {
    assert(presenter.updateUserOnNext != null);
    presenter.updateUserOnNext(response.user);
  }
}
