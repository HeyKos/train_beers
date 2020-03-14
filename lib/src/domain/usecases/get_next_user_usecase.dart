import 'dart:async';
import '../entities/user.dart';
import '../repositories/users_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetNextUserUseCase extends UseCase<GetNextUserUseCaseResponse, GetNextUserUseCaseParams> {
  final UsersRepository usersRepository;
  GetNextUserUseCase(this.usersRepository);

  @override
  Future<Stream<GetNextUserUseCaseResponse>> buildUseCaseStream(GetNextUserUseCaseParams params) async {
    final StreamController<GetNextUserUseCaseResponse> controller = StreamController();
    try {
      // get user
      User user = await usersRepository.getNextUser(params.currentSequence);
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetNextUserUseCaseResponse(user));
      logger.finest('GetNextUserUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetNextUserUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class GetNextUserUseCaseParams {
  final int currentSequence;
  GetNextUserUseCaseParams(this.currentSequence);
}

/// Wrapping response inside an object makes it easier to change later
class GetNextUserUseCaseResponse {
  final User user;
  GetNextUserUseCaseResponse(this.user);
}
