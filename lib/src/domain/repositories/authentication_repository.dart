abstract class AuthenticationRepository {
  Stream<String> get user;
  Future<String> login(String email, String password);
  Future logout();
}
