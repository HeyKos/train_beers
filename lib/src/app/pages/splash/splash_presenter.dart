import 'package:train_beers/src/domain/usecases/get_user_by_uid_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class SplashPresenter extends Presenter {
  Function getUserByUidOnNext;
  Function getUserByUidOnComplete;
  Function getUserByUidOnError;

  final GetUserByUidUseCase getUserByUidUseCase;
  SplashPresenter(userRepo, uid) : getUserByUidUseCase = GetUserByUidUseCase(userRepo);

  void getUser(String uid) {
    getUserByUidUseCase.execute(_GetUserByUidUseCaseObserver(this), GetUserByUidUseCaseParams(uid));
  }

  @override
  void dispose() {
    getUserByUidUseCase.dispose();
  }
}

class _GetUserByUidUseCaseObserver extends Observer<GetUserByUidUseCaseResponse> {
  final SplashPresenter presenter;
  _GetUserByUidUseCaseObserver(this.presenter);
  
  @override
  void onComplete() {
    assert(presenter.getUserByUidOnComplete != null);
    presenter.getUserByUidOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.getUserByUidOnError != null);
    presenter.getUserByUidOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.getUserByUidOnNext != null);
    presenter.getUserByUidOnNext(response.user);
  }
}
