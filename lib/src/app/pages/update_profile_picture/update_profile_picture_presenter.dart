import 'dart:io';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/crop_image_usecase.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';

class UpdateProfilePicturePresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function cropImageOnNext;
  Function cropImageOnComplete;
  Function cropImageOnError;
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;

  /// Use Case Objects
  final CropImageUseCase cropImageUseCase;
  final UpdateUserUseCase updateUserUseCase;

  /// Constructor
  UpdateProfilePicturePresenter(usersRepo) :
    cropImageUseCase = CropImageUseCase(),
    updateUserUseCase = UpdateUserUseCase(usersRepo);

  /// Overrides
  @override
  void dispose() {
    updateUserUseCase.dispose();
  }

  /// Methods
  void cropImage(File image) {
    cropImageUseCase.execute(_CropImageUseCaseObserver(this), CropImageUseCaseParams(image));
  }
  
  void updateUser(UserEntity user) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }
}

/// An observer class for the [CropImageUseCase].
class _CropImageUseCaseObserver extends Observer<CropImageUseCaseResponse> {
  /// Members
  final UpdateProfilePicturePresenter presenter;
  
  /// Constructor
  _CropImageUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.cropImageOnComplete != null);
    presenter.cropImageOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.cropImageOnError != null);
    presenter.cropImageOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.cropImageOnNext != null);
    presenter.cropImageOnNext(response.croppedImage);
  }
}

/// An observer class for the [UpdateUserUseCase].
class _UpdateUserUseCaseObserver extends Observer<UpdateUserUseCaseResponse> {
  /// Members
  final UpdateProfilePicturePresenter presenter;
  
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
