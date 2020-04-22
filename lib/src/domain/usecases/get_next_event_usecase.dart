import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class GetNextEventUseCase extends UseCase<GetNextEventUseCaseResponse, void> {
  final EventsRepository eventsRepository;
  GetNextEventUseCase(this.eventsRepository);

  @override
  Future<Stream<GetNextEventUseCaseResponse>> buildUseCaseStream(
      void params) async {
    final controller = StreamController<GetNextEventUseCaseResponse>();

    try {
      var event = await eventsRepository.getNextEvent().first;

      controller.add(GetNextEventUseCaseResponse(event));
      logger.finest('GetNextEventUseCase successful.');
      controller.close();
    } on Exception catch (e) {
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
