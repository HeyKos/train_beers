import 'dart:async';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/entities/event_participant_entity.dart';
import 'package:train_beers/src/domain/repositories/event_participants_repository.dart';

class GetEventParticipantsUseCase extends UseCase<GetEventParticipantsUseCaseResponse, GetEventParticipantsUseCaseParams> {
  final EventParticipantsRepository eventParticipantsRepository;
  GetEventParticipantsUseCase(this.eventParticipantsRepository);

  @override
  Future<Stream<GetEventParticipantsUseCaseResponse>> buildUseCaseStream(GetEventParticipantsUseCaseParams params) async {
    final StreamController<GetEventParticipantsUseCaseResponse> controller = StreamController();
    try {
      List<EventParticipantEntity> eventParticipants = await eventParticipantsRepository.getEventParticipants(params.eventId).first;
      
      controller.add(GetEventParticipantsUseCaseResponse(eventParticipants));
      logger.finest('GetEventParticipantsUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetEventParticipantsUseCase unsuccessful.');
      // Trigger .onError
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
