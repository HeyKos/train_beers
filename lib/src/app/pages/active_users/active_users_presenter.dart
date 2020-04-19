import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/get_avatar_url_usecase.dart';

class ActiveUsersPresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function getAvatarUrlOnNext;
  Function getAvatarUrlOnComplete;
  Function getAvatarUrlOnError;
  
  /// Use Case Objects
  final GetAvatarUrlUseCase getAvatarUrlUseCase;

  /// Constructor
  ActiveUsersPresenter(filesRepo, usersRepo) :
    getAvatarUrlUseCase = GetAvatarUrlUseCase(filesRepo);
    
  /// Overrides
  @override
  void dispose() {
    getAvatarUrlUseCase.dispose();
  }

  /// Methods
  void getAvatarDownloadUrl(String id, String path) {
    getAvatarUrlUseCase.execute(_GetAvatarUrlUseCaseObserver(this), GetAvatarUrlUseCaseParams(id, path));
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
