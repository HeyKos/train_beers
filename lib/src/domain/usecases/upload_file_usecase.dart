import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/files_repository.dart';

class UploadFileUseCase
    extends UseCase<UploadFileUseCaseResponse, UploadFileUseCaseParams> {
  final FilesRepository filesRepository;
  UploadFileUseCase(this.filesRepository);

  @override
  Future<Stream<UploadFileUseCaseResponse>> buildUseCaseStream(
      UploadFileUseCaseParams params) async {
    final controller = StreamController<UploadFileUseCaseResponse>();

    try {
      var uploadTask = filesRepository.uploadFile(params.file);
      if (uploadTask == null) {
        logger.warning('The upload process failed to return an uploadTask.');
        controller.close();
      }

      controller.add(UploadFileUseCaseResponse(uploadTask));
      logger.finest('UploadFileUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('UploadFileUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class UploadFileUseCaseParams {
  final File file;
  UploadFileUseCaseParams(this.file);
}

/// Wrapping response inside an object makes it easier to change later
class UploadFileUseCaseResponse {
  final StorageUploadTask uploadTask;
  UploadFileUseCaseResponse(this.uploadTask);
}
