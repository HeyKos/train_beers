import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetNextUserUseCase extends UseCase<GetNextUserUseCaseResponse, void> {
  final UsersRepository usersRepository;
  GetNextUserUseCase(this.usersRepository);

  @override
  Future<Stream<GetNextUserUseCaseResponse>> buildUseCaseStream(
      void params) async {
    final controller = StreamController<GetNextUserUseCaseResponse>();

    try {
      var user = await usersRepository.getLongestSincePurchased().first;

      controller.add(GetNextUserUseCaseResponse(user));
      logger.finest('GetNextUserUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetNextUserUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping response inside an object makes it easier to change later
class GetNextUserUseCaseResponse {
  final UserEntity user;
  GetNextUserUseCaseResponse(this.user);
}
