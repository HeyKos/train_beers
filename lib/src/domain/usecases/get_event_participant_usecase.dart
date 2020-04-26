import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_entity.dart';
import '../entities/event_participant_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/event_participants_repository.dart';

class GetEventParticipantUseCase extends UseCase<
    GetEventParticipantUseCaseResponse, GetEventParticipantUseCaseParams> {
  final EventParticipantsRepository eventParticipantsRepository;
  GetEventParticipantUseCase(this.eventParticipantsRepository);

  @override
  Future<Stream<GetEventParticipantUseCaseResponse>> buildUseCaseStream(
      GetEventParticipantUseCaseParams params) async {
    final controller = StreamController<GetEventParticipantUseCaseResponse>();

    try {
      var eventParticipant = await eventParticipantsRepository
          .getByEventAndUser(params.event, params.user);

      controller.add(GetEventParticipantUseCaseResponse(eventParticipant));
      logger.finest('GetEventParticipantUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetEventParticipantUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetEventParticipantUseCaseParams {
  final EventEntity event;
  final UserEntity user;
  GetEventParticipantUseCaseParams(this.event, this.user);
}

class GetEventParticipantUseCaseResponse {
  final EventParticipantEntity eventParticipant;
  GetEventParticipantUseCaseResponse(this.eventParticipant);
}
