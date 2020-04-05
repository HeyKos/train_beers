import 'dart:async';
import 'package:train_beers/src/domain/repositories/files_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetAvatarUrlUseCase extends UseCase<GetAvatarUrlUseCaseResponse, GetAvatarUrlUseCaseParams> {
  final FilesRepository filesRepository;
  GetAvatarUrlUseCase(this.filesRepository);

  @override
  Future<Stream<GetAvatarUrlUseCaseResponse>> buildUseCaseStream(GetAvatarUrlUseCaseParams params) async {
    final StreamController<GetAvatarUrlUseCaseResponse> controller = StreamController();
    try {
      String url = await filesRepository.getDownloadUrl(params.path);
      if (url.isEmpty) {
        logger.warning('No image found at path: ${params.path}.');
        controller.close();  
      }
      
      controller.add(GetAvatarUrlUseCaseResponse(url));
      logger.finest('GetAvatarUrlUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetAvatarUrlUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class GetAvatarUrlUseCaseParams {
  final String path;
  GetAvatarUrlUseCaseParams(this.path);
}

/// Wrapping response inside an object makes it easier to change later
class GetAvatarUrlUseCaseResponse {
  final String url;
  GetAvatarUrlUseCaseResponse(this.url);
}
