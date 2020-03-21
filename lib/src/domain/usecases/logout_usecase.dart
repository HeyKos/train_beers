import 'dart:async';
import '../repositories/authentication_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LogoutUseCase extends UseCase<void, void> {
  final AuthenticationRepository authenticationRepository;
  LogoutUseCase(this.authenticationRepository);

  @override
  Future<Stream<void>> buildUseCaseStream(void params) async {
    final StreamController<void> controller = StreamController();
    try {
      await authenticationRepository.logout();
      logger.finest('Logout successful.');
      controller.close();
    } catch (e) {
      logger.severe('LogoutUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}