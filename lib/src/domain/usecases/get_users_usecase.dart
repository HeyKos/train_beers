import 'dart:async';
import '../entities/user.dart';
import '../repositories/users_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class GetUsersUseCase extends UseCase<GetUsersUseCaseResponse, void> {
  final UsersRepository usersRepository;
  GetUsersUseCase(this.usersRepository);

  @override
  Future<Stream<GetUsersUseCaseResponse>> buildUseCaseStream(void ignore) async {
    final StreamController<GetUsersUseCaseResponse> controller = StreamController();
    try {
      // get user
      List<User> users = await usersRepository.getAllUsers();
      // Adding it triggers the .onNext() in the `Observer`
      // It is usually better to wrap the reponse inside a respose object.
      controller.add(GetUsersUseCaseResponse(users));
      logger.finest('GetUsersUseCase successful.');
      controller.close();
    } catch (e) {
      logger.severe('GetUsersUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping response inside an object makes it easier to change later
class GetUsersUseCaseResponse {
  final List<User> users;
  GetUsersUseCaseResponse(this.users);
}
