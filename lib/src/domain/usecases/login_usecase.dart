import 'dart:async';
import '../repositories/authentication_repository.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

class LoginUseCase extends UseCase<LoginUseCaseResponse, LoginUseCaseParams> {
  final AuthenticationRepository authenticationRepository;
  LoginUseCase(this.authenticationRepository);

  @override
  Future<Stream<LoginUseCaseResponse>> buildUseCaseStream(LoginUseCaseParams params) async {
    final StreamController<LoginUseCaseResponse> controller = StreamController();
    try {
      bool success = false;
      String userIdentifier = await authenticationRepository.login(params.email, params.password);

      // If no user is returned, then return an unsuccessful login attempt
      if (userIdentifier == "") {
        logger.finest('Login attempt failed.');
        controller.add(LoginUseCaseResponse(success, ""));
        logger.finest('GetNextUserUseCase successful.');
        controller.close();  
        return controller.stream;
      }

      success = true;
      controller.add(LoginUseCaseResponse(success, userIdentifier));
      logger.finest('Login successful.');
      controller.close();
    } catch (e) {
      logger.severe('LoginUseCase unsuccessful.');
      // Trigger .onError
      controller.addError(e);
    }
    return controller.stream;
  }
}

/// Wrapping params inside an object makes it easier to change later
class LoginUseCaseParams {
  final String email;
  final String password;
  LoginUseCaseParams(this.email, this.password);
}

/// Wrapping response inside an object makes it easier to change later
class LoginUseCaseResponse {
  final bool success;
  final String userIdentifier;
  LoginUseCaseResponse(this.success, this.userIdentifier);
}
