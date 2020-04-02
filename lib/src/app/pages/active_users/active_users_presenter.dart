import 'package:train_beers/src/app/utils/constants.dart';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/usecases/countdown_use_case.dart';
import 'package:train_beers/src/domain/usecases/get_active_users_usecase.dart';
import 'package:train_beers/src/domain/usecases/get_next_user_usecase.dart';
import 'package:train_beers/src/domain/usecases/logout_usecase.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';

class ActiveUsersPresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function getActiveUsersOnNext;
  Function getActiveUsersOnComplete;
  Function getActiveUsersOnError;
  
  /// Use Case Objects
  final GetActiveUsersUseCase getActiveUsersUseCase;

  /// Constructor
  ActiveUsersPresenter(usersRepo) :
    getActiveUsersUseCase = GetActiveUsersUseCase(usersRepo),
    
  /// Overrides
  @override
  void dispose() {
    getActiveUsersUseCase.dispose();
  }

  /// Methods
  void getActiveUsers() {
    // execute getUseruserCase
    getActiveUsersUseCase.execute(_GetActiveUsersUseCaseObserver(this), null);
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
