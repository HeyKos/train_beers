import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/authentication_repository.dart';

class LogoutUseCase extends UseCase<void, void> {
  final AuthenticationRepository authenticationRepository;
  LogoutUseCase(this.authenticationRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    final controller = StreamController<void>();

    try {
      await authenticationRepository.logout();
      logger.finest('Logout successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('LogoutUseCase unsuccessful.');
      controller.addError(e);
    }
    return controller.stream;
  }
}
