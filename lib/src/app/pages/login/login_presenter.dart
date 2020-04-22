import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/usecases/login_usecase.dart';

class LoginPresenter extends Presenter {
  Function loginOnNext;
  Function loginOnComplete;
  Function loginOnError;

  final LoginUseCase loginUseCase;
  LoginPresenter(loginRepo) : loginUseCase = LoginUseCase(loginRepo);

  void login(String email, String password) {
    loginUseCase.execute(
        _LoginUseCaseObserver(this), LoginUseCaseParams(email, password));
  }

  @override
  void dispose() {
    loginUseCase.dispose();
  }
}

class _LoginUseCaseObserver extends Observer<LoginUseCaseResponse> {
  final LoginPresenter presenter;
  _LoginUseCaseObserver(this.presenter);
  @override
  void onComplete() {
    assert(presenter.loginOnComplete != null);
    presenter.loginOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.loginOnError != null);
    presenter.loginOnError(e);
  }

  @override
  void onNext(LoginUseCaseResponse response) {
    assert(presenter.loginOnNext != null);
    presenter.loginOnNext(response.success, response.userIdentifier);
  }
}
