import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class UpdateUserUseCase
    extends UseCase<UpdateUserUseCaseResponse, UpdateUserUseCaseParams> {
  final UsersRepository usersRepository;
  UpdateUserUseCase(this.usersRepository);

  @override
  Future<Stream<UpdateUserUseCaseResponse>> buildUseCaseStream(
      UpdateUserUseCaseParams params) async {
    final controller = StreamController<UpdateUserUseCaseResponse>();

    try {
      await usersRepository.updateUser(params.user);

      controller.add(UpdateUserUseCaseResponse(params.user));
      logger.finest('UpdateUserUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('UpdateUserUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class UpdateUserUseCaseParams {
  final UserEntity user;
  UpdateUserUseCaseParams(this.user);
}

/// Wrapping response inside an object makes it easier to change later
class UpdateUserUseCaseResponse {
  final UserEntity user;
  UpdateUserUseCaseResponse(this.user);
}
