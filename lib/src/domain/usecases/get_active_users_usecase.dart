import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class GetActiveUsersUseCase
    extends UseCase<GetActiveUsersUseCaseResponse, void> {
  final UsersRepository usersRepository;
  GetActiveUsersUseCase(this.usersRepository);

  @override
  Future<Stream<GetActiveUsersUseCaseResponse>> buildUseCaseStream(
      void params) async {
    final controller = StreamController<GetActiveUsersUseCaseResponse>();
    
    try {
      List<UserEntity> users;
      users = await usersRepository.getActiveUsers().first;
      controller.add(GetActiveUsersUseCaseResponse(users));
      logger.finest('GetActiveUsersUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetActiveUsersUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping response inside an object makes it easier to change later
class GetActiveUsersUseCaseResponse {
  final List<UserEntity> users;
  GetActiveUsersUseCaseResponse(this.users);
}
