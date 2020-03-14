import 'package:train_beers/src/domain/usecases/get_next_user_usecase.dart';
import '../../../domain/usecases/get_next_user_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class HomePresenter extends Presenter {
  Function getNextUserOnNext;
  Function getNextUserOnComplete;
  Function getNextUserOnError;

  final GetNextUserUseCase getNextUserUseCase;
  HomePresenter(usersRepo) : getNextUserUseCase = GetNextUserUseCase(usersRepo);

  void getNextUser(int currentSequence) {
    // execute getUseruserCase
    getNextUserUseCase.execute(_GetNextUserUseCaseObserver(this), GetNextUserUseCaseParams(currentSequence));
  }

  @override
  void dispose() {
    getNextUserUseCase.dispose();
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
