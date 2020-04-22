import 'dart:async';

import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';

import '../repositories/authentication_repository.dart';

class LoginUseCase extends UseCase<LoginUseCaseResponse, LoginUseCaseParams> {
  final AuthenticationRepository authenticationRepository;
  LoginUseCase(this.authenticationRepository);

  @override
  Future<Stream<LoginUseCaseResponse>> buildUseCaseStream(
      LoginUseCaseParams params) async {
    final controller = StreamController<LoginUseCaseResponse>();

    try {
      var success = false;
      var userIdentifier =
          await authenticationRepository.login(params.email, params.password);

      // If no user is returned, then return an unsuccessful login attempt
      if (userIdentifier == "") {
        logger.finest('Login attempt failed.');
        controller.add(LoginUseCaseResponse("", success: success));
        logger.finest('GetNextUserUseCase successful.');
        controller.close();
        return controller.stream;
      }

      success = true;
      controller.add(LoginUseCaseResponse(userIdentifier, success: success));
      logger.finest('Login successful.');
      controller.close();
    } on Exception catch (e) {
      logger.severe('LoginUseCase unsuccessful.');
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
  LoginUseCaseResponse(this.userIdentifier, {this.success = false});
}
