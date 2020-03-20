abstract class AuthenticationRepository {
    Future<String> login(String email, String password);
}
