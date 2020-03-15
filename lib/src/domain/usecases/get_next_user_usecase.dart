import 'dart:async';
import 'package:train_beers/src/domain/entities/user_entity.dart';
import '../repositories/users_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetNextUserUseCase extends UseCase<GetNextUserUseCaseResponse, GetNextUserUseCaseParams> {
  final UsersRepository usersRepository;
  GetNextUserUseCase(this.usersRepository);

  @override
  Future<Stream<GetNextUserUseCaseResponse>> buildUseCaseStream(GetNextUserUseCaseParams params) async {
    final StreamController<GetNextUserUseCaseResponse> controller = StreamController();
    try {
      UserEntity user;
      // get user
      List<UserEntity> users = await usersRepository.users().first;
      users.sort((a, b) => a.sequence.compareTo(b.sequence));
      int maxSequence = users.last.sequence;

      if (params.currentSequence == maxSequence) {
        user = users.first;
      }
      else {
        user = users.firstWhere((u) => u.sequence > params.currentSequence);
      }
      
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
  final UserEntity user;
  GetNextUserUseCaseResponse(this.user);
}
