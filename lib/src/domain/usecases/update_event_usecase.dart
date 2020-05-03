import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../entities/event_entity.dart';
import '../repositories/events_repository.dart';

class UpdateEventUseCase
    extends UseCase<UpdateEventUseCaseResponse, UpdateEventUseCaseParams> {
  final EventsRepository eventsRepository;
  UpdateEventUseCase(this.eventsRepository);

  @override
  Future<Stream<UpdateEventUseCaseResponse>> buildUseCaseStream(
      UpdateEventUseCaseParams params) async {
    final controller = StreamController<UpdateEventUseCaseResponse>();

    try {
      await eventsRepository.update(params.event);

      controller.add(UpdateEventUseCaseResponse(params.event));
      logger.finest('UpdateEventUseCase successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('UpdateEventUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}

class UpdateEventUseCaseParams {
  final EventEntity event;
  UpdateEventUseCaseParams(this.event);
}

class UpdateEventUseCaseResponse {
  final EventEntity event;
  UpdateEventUseCaseResponse(this.event);
}
