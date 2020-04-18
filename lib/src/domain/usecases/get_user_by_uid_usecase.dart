import 'dart:async';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/repositories/users_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUserByUidUseCase extends UseCase<GetUserByUidUseCaseResponse, GetUserByUidUseCaseParams> {
  final UsersRepository usersRepository;
  GetUserByUidUseCase(this.usersRepository);

  @override
  Future<Stream<GetUserByUidUseCaseResponse>> buildUseCaseStream(GetUserByUidUseCaseParams params) async {
    final StreamController<GetUserByUidUseCaseResponse> controller = StreamController();
    try {
      UserEntity user = await usersRepository.getByUid(params.uid).first;
      
      controller.add(GetUserByUidUseCaseResponse(user));
      logger.finest('GetUserByUidUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetUserByUidUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class GetUserByUidUseCaseParams {
  final String uid;
  GetUserByUidUseCaseParams(this.uid);
}

/// Wrapping response inside an object makes it easier to change later
class GetUserByUidUseCaseResponse {
  final UserEntity user;
  GetUserByUidUseCaseResponse(this.user);
}
