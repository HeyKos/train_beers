import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../../../domain/usecases/get_user_by_uid_usecase.dart';

class SplashPresenter extends Presenter {
  /// Members
  Function getUserByUidOnNext;
  Function getUserByUidOnComplete;
  Function getUserByUidOnError;

  final GetUserByUidUseCase getUserByUidUseCase;

  /// Constructor
  SplashPresenter(userRepo, uid)
      : getUserByUidUseCase = GetUserByUidUseCase(userRepo);

  void getUser(String uid) {
    getUserByUidUseCase.execute(
        _GetUserByUidUseCaseObserver(this), GetUserByUidUseCaseParams(uid));
  }

  @override
  void dispose() {
    getUserByUidUseCase.dispose();
  }
}

class _GetUserByUidUseCaseObserver
    extends Observer<GetUserByUidUseCaseResponse> {
  /// Members
  final SplashPresenter presenter;

  /// Constructor
  _GetUserByUidUseCaseObserver(this.presenter);

  @override
  void onComplete() {
    assert(presenter.getUserByUidOnComplete != null);
    presenter.getUserByUidOnComplete();
  }

  @override
  void onError(dynamic e) {
    assert(presenter.getUserByUidOnError != null);
    presenter.getUserByUidOnError(e);
  }

  @override
  void onNext(GetUserByUidUseCaseResponse response) {
    assert(presenter.getUserByUidOnNext != null);
    presenter.getUserByUidOnNext(response.user);
  }
}
