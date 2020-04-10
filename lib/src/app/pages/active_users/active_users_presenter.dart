import 'package:train_beers/src/domain/usecases/get_active_users_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/get_avatar_url_usecase.dart';

class ActiveUsersPresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function getActiveUsersOnNext;
  Function getActiveUsersOnComplete;
  Function getActiveUsersOnError;
  Function getAvatarUrlOnNext;
  Function getAvatarUrlOnComplete;
  Function getAvatarUrlOnError;
  
  /// Use Case Objects
  final GetActiveUsersUseCase getActiveUsersUseCase;
  final GetAvatarUrlUseCase getAvatarUrlUseCase;

  /// Constructor
  ActiveUsersPresenter(filesRepo, usersRepo) :
    getActiveUsersUseCase = GetActiveUsersUseCase(usersRepo),
    getAvatarUrlUseCase = GetAvatarUrlUseCase(filesRepo);
    
  /// Overrides
  @override
  void dispose() {
    getActiveUsersUseCase.dispose();
  }

  /// Methods
  void getActiveUsers() {
    getActiveUsersUseCase.execute(_GetActiveUsersUseCaseObserver(this), null);
  }

  void getAvatarDownloadUrl(String id, String path) {
    getAvatarUrlUseCase.execute(_GetAvatarUrlUseCaseObserver(this), GetAvatarUrlUseCaseParams(id, path));
  }
}

/// An observer class for the [GetActiveUsersUseCase].
class _GetActiveUsersUseCaseObserver extends Observer<GetActiveUsersUseCaseResponse> {
  /// Members
  final ActiveUsersPresenter presenter;
  
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
  final ActiveUsersPresenter presenter;
  
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
    presenter.getAvatarUrlOnNext(response.id, response.url);
  }
}
