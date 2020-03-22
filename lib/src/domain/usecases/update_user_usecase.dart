import 'dart:async';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import 'package:train_beers/src/domain/repositories/users_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class UpdateUserUseCase extends UseCase<UpdateUserUseCaseResponse, UpdateUserUseCaseParams> {
  final UsersRepository usersRepository;
  UpdateUserUseCase(this.usersRepository);

  @override
  Future<Stream<UpdateUserUseCaseResponse>> buildUseCaseStream(UpdateUserUseCaseParams params) async {
    final StreamController<UpdateUserUseCaseResponse> controller = StreamController();
    try {
      await usersRepository.updateUser(params.user);
      
      controller.add(UpdateUserUseCaseResponse(params.user));
      logger.finest('UpdateUserUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('UpdateUserUseCase unsuccessful.');
      // Trigger .onError
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
