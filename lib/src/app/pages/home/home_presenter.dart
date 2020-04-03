import 'package:train_beers/src/app/utils/constants.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/usecases/countdown_use_case.dart';
import 'package:train_beers/src/domain/usecases/get_next_user_usecase.dart';
import 'package:train_beers/src/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';

class HomePresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function getNextUserOnNext;
  Function getNextUserOnComplete;
  Function getNextUserOnError;
  Function logoutOnNext;
  Function logoutOnComplete;
  Function logoutOnError;
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;

  /// Use Case Objects
  final GetNextUserUseCase getNextUserUseCase;
  final LogoutUseCase logoutUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final CountdownUseCase countdownUseCase;

  /// Constructor
  HomePresenter(usersRepo, authRepo) :
    getNextUserUseCase = GetNextUserUseCase(usersRepo),
    logoutUseCase = LogoutUseCase(authRepo),
    updateUserUseCase = UpdateUserUseCase(usersRepo),
    countdownUseCase = CountdownUseCase();

  /// Overrides
  @override
  void dispose() {
    getNextUserUseCase.dispose();
    logoutUseCase.dispose();
    updateUserUseCase.dispose();
  }

  /// Methods
  void getNextUser(int currentSequence) {
    // execute getUseruserCase
    getNextUserUseCase.execute(_GetNextUserUseCaseObserver(this), GetNextUserUseCaseParams(currentSequence));
  }

  void logout() {
    logoutUseCase.execute(_LogoutUseCaseObserver(this));
  }

  void updateUser(UserEntity user) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }

  bool shouldDisplayCountdown() => countdownUseCase.shouldDisplayCountdown();

  void onMenuOptionChange(String value) {
    switch(value) {
      case Constants.PRIFULE:
        print("Tapped Profile");
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

/// An observer class for the [GetNextUserUseCase].
class _GetNextUserUseCaseObserver extends Observer<GetNextUserUseCaseResponse> {
  /// Members
  final HomePresenter presenter;
  
  /// Constructor
  _GetNextUserUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.getNextUserOnComplete != null);
    presenter.getNextUserOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getNextUserOnError != null);
    presenter.getNextUserOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getNextUserOnNext != null);
    presenter.getNextUserOnNext(response.user);
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
