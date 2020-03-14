import '../entities/user.dart';

abstract class UsersRepository {
  Future<User> getUser(String uid);
  Future<User> getNextUser(int currentSequence);
  Future<List<User>> getAllUsers();
}
