import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/users_repository.dart';

class UpdateEventParticipationUseCase
    extends UseCase<void, UpdateEventParticipationUseCaseParams> {
  final UsersRepository usersRepository;
  UpdateEventParticipationUseCase(this.usersRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateEventParticipationUseCaseParams params) async {
    final controller = StreamController<void>();

    try {
      await usersRepository.updateUser(params.user);

      logger.finest('UpdateEventParticipationUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('UpdateEventParticipationUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class UpdateEventParticipationUseCaseParams {
  final EventEntity event;
  final UserEntity user;
  final bool isParticipating;
  UpdateEventParticipationUseCaseParams(
      this.event, this.user, {this.isParticipating = false});
}
