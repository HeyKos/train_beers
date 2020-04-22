import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetUserByUidUseCase
    extends UseCase<GetUserByUidUseCaseResponse, GetUserByUidUseCaseParams> {
  final UsersRepository usersRepository;
  GetUserByUidUseCase(this.usersRepository);

  @override
  Future<Stream<GetUserByUidUseCaseResponse>> buildUseCaseStream(
      GetUserByUidUseCaseParams params) async {
    final controller = StreamController<GetUserByUidUseCaseResponse>();

    try {
      var user = await usersRepository.getByUid(params.uid).first;

      controller.add(GetUserByUidUseCaseResponse(user));
      logger.finest('GetUserByUidUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetUserByUidUseCase unsuccessful.');
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
