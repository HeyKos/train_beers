import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';

class ProfilePresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;

  /// Use Case Objects
  final UpdateUserUseCase updateUserUseCase;

  /// Constructor
  ProfilePresenter(usersRepo) :
    updateUserUseCase = UpdateUserUseCase(usersRepo);

  /// Overrides
  @override
  void dispose() {
    updateUserUseCase.dispose();
  }

  /// Methods
  void updateUser(UserEntity user) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }
}

/// An observer class for the [UpdateUserUseCase].
class _UpdateUserUseCaseObserver extends Observer<UpdateUserUseCaseResponse> {
  /// Members
  final ProfilePresenter presenter;
  
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
