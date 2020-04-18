import 'dart:async';
import 'package:train_beers/src/domain/entities/event_entity.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:train_beers/src/domain/repositories/events_repository.dart';

class GetNextEventUseCase extends UseCase<GetNextEventUseCaseResponse, void> {
  final EventsRepository eventsRepository;
  GetNextEventUseCase(this.eventsRepository);

  @override
  Future<Stream<GetNextEventUseCaseResponse>> buildUseCaseStream(void params) async {
    final StreamController<GetNextEventUseCaseResponse> controller = StreamController();
    try {
      EventEntity event = await eventsRepository.getNextEvent().first;
      
      controller.add(GetNextEventUseCaseResponse(event));
      logger.finest('GetNextEventUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetNextEventUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping response inside an object makes it easier to change later
class GetNextEventUseCaseResponse {
  final EventEntity event;
  GetNextEventUseCaseResponse(this.event);
}
