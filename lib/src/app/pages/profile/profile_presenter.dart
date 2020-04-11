import 'dart:io';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/usecases/crop_image_usecase.dart';
import 'package:train_beers/src/domain/usecases/get_avatar_url_usecase.dart';
import 'package:train_beers/src/domain/usecases/update_user_usecase.dart';
import 'package:train_beers/src/domain/usecases/upload_file_usecase.dart';

class ProfilePresenter extends Presenter {
  /// Members
  /// Use Case Functions
  Function cropImageOnNext;
  Function cropImageOnComplete;
  Function cropImageOnError;
  Function getAvatarUrlOnNext;
  Function getAvatarUrlOnComplete;
  Function getAvatarUrlOnError;
  Function updateUserOnNext;
  Function updateUserOnComplete;
  Function updateUserOnError;
  Function uploadFileOnNext;
  Function uploadFileOnComplete;
  Function uploadFileOnError;

  /// Use Case Objects
  final CropImageUseCase cropImageUseCase;
  final GetAvatarUrlUseCase getAvatarUrlUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UploadFileUseCase uploadFileUseCase;

  /// Constructor
  ProfilePresenter(filesRepo, usersRepo) :
    cropImageUseCase = CropImageUseCase(),
    getAvatarUrlUseCase = GetAvatarUrlUseCase(filesRepo),
    updateUserUseCase = UpdateUserUseCase(usersRepo),
    uploadFileUseCase = UploadFileUseCase(filesRepo);

  /// Overrides
  @override
  void dispose() {
    cropImageUseCase.dispose();
    getAvatarUrlUseCase.dispose();
    updateUserUseCase.dispose();
    uploadFileUseCase.dispose();
  }

  /// Methods
  void cropImage(File image) {
    cropImageUseCase.execute(_CropImageUseCaseObserver(this), CropImageUseCaseParams(image));
  }

  void getAvatarDownloadUrl(String id, String path) {
    getAvatarUrlUseCase.execute(_GetAvatarUrlUseCaseObserver(this), GetAvatarUrlUseCaseParams(id, path));
  }

  void updateUser(UserEntity user) {
    updateUserUseCase.execute(_UpdateUserUseCaseObserver(this), UpdateUserUseCaseParams(user));
  }

  void uploadAvatar(File file) {
    uploadFileUseCase.execute(_UploadFileUseCaseObserver(this), UploadFileUseCaseParams(file));
  }
}

/// Observers
/// An observer class for the [CropImageUseCase].
class _CropImageUseCaseObserver extends Observer<CropImageUseCaseResponse> {
  /// Members
  final ProfilePresenter presenter;
  
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

/// An observer class for the [GetAvatarUrlUseCase].
class _GetAvatarUrlUseCaseObserver extends Observer<GetAvatarUrlUseCaseResponse> {
  /// Members
  final ProfilePresenter presenter;
  
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
    presenter.getAvatarUrlOnNext(response.url);
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

/// An observer class for the [UploadFileUseCase].
class _UploadFileUseCaseObserver extends Observer<UploadFileUseCaseResponse> {
  /// Members
  final ProfilePresenter presenter;
  
  /// Constructor
  _UploadFileUseCaseObserver(this.presenter);
  
  /// Overrides
  @override
  void onComplete() {
    assert(presenter.uploadFileOnComplete != null);
    presenter.uploadFileOnComplete();
  }

  @override
  void onError(e) {
    assert(presenter.uploadFileOnError != null);
    presenter.uploadFileOnError(e);
  }

  @override
  void onNext(response) {
    assert(presenter.uploadFileOnNext != null);
    presenter.uploadFileOnNext(response.uploadTask);
  }
}
