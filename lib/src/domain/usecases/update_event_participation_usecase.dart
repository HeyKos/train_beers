import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_entity.dart';
import '../entities/event_participant_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/event_participants_repository.dart';

class UpdateEventParticipationUseCase
    extends UseCase<void, UpdateEventParticipationUseCaseParams> {
  final EventParticipantsRepository participationRepository;

  UpdateEventParticipationUseCase(this.participationRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(
      UpdateEventParticipationUseCaseParams params) async {
    final controller =
        StreamController<UpdateEventParticipationUseCaseResponse>();

    try {
      var participant = await participationRepository.updateParticipationStatus(
          params.event, params.user);

      controller.add(UpdateEventParticipationUseCaseResponse(participant));
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
  UpdateEventParticipationUseCaseParams(this.event, this.user,
      {this.isParticipating = false});
}

class UpdateEventParticipationUseCaseResponse {
  final EventParticipantEntity participant;
  UpdateEventParticipationUseCaseResponse(this.participant);
}
