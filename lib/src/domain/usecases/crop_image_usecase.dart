import 'dart:async';
import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class CropImageUseCase extends UseCase<CropImageUseCaseResponse, CropImageUseCaseParams> {
  CropImageUseCase();

  @override
  Future<Stream<CropImageUseCaseResponse>> buildUseCaseStream(CropImageUseCaseParams params) async {
    final StreamController<CropImageUseCaseResponse> controller = StreamController();
    try {
      File cropped = await ImageCropper.cropImage(
        sourcePath: params.imageFile.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        maxHeight: 512,
        maxWidth: 512,
        androidUiSettings: AndroidUiSettings(
          lockAspectRatio: true,
          toolbarTitle: "Crop Image",
        ),
      );
      
      controller.add(CropImageUseCaseResponse(cropped));
      logger.finest('CropImageUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('CropImageUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class CropImageUseCaseParams {
  final File imageFile;
  CropImageUseCaseParams(this.imageFile);
}

/// Wrapping response inside an object makes it easier to change later
class CropImageUseCaseResponse {
  final File croppedImage;
  CropImageUseCaseResponse(this.croppedImage);
}
