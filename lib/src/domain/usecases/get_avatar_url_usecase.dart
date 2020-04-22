import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/files_repository.dart';

class GetAvatarUrlUseCase
    extends UseCase<GetAvatarUrlUseCaseResponse, GetAvatarUrlUseCaseParams> {
  final FilesRepository filesRepository;
  GetAvatarUrlUseCase(this.filesRepository);

  @override
  Future<Stream<GetAvatarUrlUseCaseResponse>> buildUseCaseStream(
      GetAvatarUrlUseCaseParams params) async {
    final controller = StreamController<GetAvatarUrlUseCaseResponse>();
    
    try {
      var url = await filesRepository.getDownloadUrl(params.path);
      if (url.isEmpty) {
        logger.warning('No image found at path: ${params.path}.');
        controller.close();
      }

      controller.add(GetAvatarUrlUseCaseResponse(params.id, url));
      logger.finest('GetAvatarUrlUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetAvatarUrlUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class GetAvatarUrlUseCaseParams {
  final String id;
  final String path;
  GetAvatarUrlUseCaseParams(this.id, this.path);
}

/// Wrapping response inside an object makes it easier to change later
class GetAvatarUrlUseCaseResponse {
  final String id;
  final String url;
  GetAvatarUrlUseCaseResponse(this.id, this.url);
}
