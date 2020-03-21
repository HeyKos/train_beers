import 'package:train_beers/src/domain/usecases/get_next_user_usecase.dart';
import 'package:train_beers/src/domain/usecases/logout_usecase.dart';
import '../../../domain/usecases/get_next_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomePresenter extends Presenter {
  // Use Case Functions
  Function getNextUserOnNext;
  Function getNextUserOnComplete;
  Function getNextUserOnError;
  Function logoutOnNext;
  Function logoutOnComplete;
  Function logoutOnError;

  // Use Case Objects
  final GetNextUserUseCase getNextUserUseCase;
  final LogoutUseCase logoutUseCase;
  
  // Constructors
  HomePresenter(usersRepo, authRepo) :
    getNextUserUseCase = GetNextUserUseCase(usersRepo),
    logoutUseCase = LogoutUseCase(authRepo);

  void getNextUser(int currentSequence) {
    // execute getUseruserCase
    getNextUserUseCase.execute(_GetNextUserUseCaseObserver(this), GetNextUserUseCaseParams(currentSequence));
  }

  void logout() {
    logoutUseCase.execute(_GetLogoutUseCaseObserver(this));
  }

  @override
  void dispose() {
    getNextUserUseCase.dispose();
    logoutUseCase.dispose();
  }
}

class _GetNextUserUseCaseObserver extends Observer<GetNextUserUseCaseResponse> {
  final HomePresenter presenter;
  _GetNextUserUseCaseObserver(this.presenter);
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

class _GetLogoutUseCaseObserver extends Observer<void> {
  final HomePresenter presenter;
  _GetLogoutUseCaseObserver(this.presenter);
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
