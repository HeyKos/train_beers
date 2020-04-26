import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_participant_entity.dart';
import '../repositories/event_participants_repository.dart';

class GetEventParticipantsUseCase extends UseCase<
    GetEventParticipantsUseCaseResponse, GetEventParticipantsUseCaseParams> {
  final EventParticipantsRepository eventParticipantsRepository;
  GetEventParticipantsUseCase(this.eventParticipantsRepository);

  @override
  Future<Stream<GetEventParticipantsUseCaseResponse>> buildUseCaseStream(
      GetEventParticipantsUseCaseParams params) async {
    final controller = StreamController<GetEventParticipantsUseCaseResponse>();
    
    try {
      var eventParticipants = await eventParticipantsRepository
          .getByEventId(params.eventId)
          .first;

      controller.add(GetEventParticipantsUseCaseResponse(eventParticipants));
      logger.finest('GetEventParticipantsUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('GetEventParticipantsUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class GetEventParticipantsUseCaseParams {
  final String eventId;
  GetEventParticipantsUseCaseParams(this.eventId);
}

class GetEventParticipantsUseCaseResponse {
  final List<EventParticipantEntity> eventParticipants;
  GetEventParticipantsUseCaseResponse(this.eventParticipants);
}
