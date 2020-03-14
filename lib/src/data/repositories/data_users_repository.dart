import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';

class DataUsersRepository extends UsersRepository {
  List<User> users;
  // singleton
  static DataUsersRepository _instance = DataUsersRepository._internal();
  DataUsersRepository._internal() {
    users = List<User>();
    users.addAll([
      User('7', 'Brandon Scott', 7),
      User('2', 'Christopher Dubbins', 2),
      User('4', 'Frank Arendt', 4),
      User('3', 'Jobi Campbell', 3),
      User('1', 'Jon Hollinger', 1),
      User('6', 'Josh Peters', 6),
      User('8', 'Michael Tyson', 8),
      User('5', 'Mike Koser', 5),
    ]);

    // Ensure the user's list is ordered by sequence
    users.sort((a, b) => a.sequence.compareTo(b.sequence));
  }
  factory DataUsersRepository() => _instance;

  // #region Overrides
  @override
  Future<List<User>> getAllUsers() async {
    return users;
  }

  @override
  Future<User> getUser(String uid) async {
    return users.firstWhere((user) => user.uid == uid);
  }

  @override
  Future<User> getNextUser(int currentSequence) async {
    // Get the max sequence
    int maxSequence = getMaxUserSequence();
    
    // Return the user with the lowest sequence value.
    if (currentSequence == maxSequence) {
      // If the constructor ever changes, be sure to sort the list of users by sequence prior to returning the first user.
      return users.first;
    }

    // Otherwise return the next user in the sequence. 
    return users.firstWhere((user) => user.sequence > currentSequence);
  }
  // #endregion Overrides

  // #region Private Methods
  int getMaxUserSequence() {
    // If the constructor ever changes, be sure to sort the list of users by sequence prior to returning the last user's sequence.
    return users.last.sequence;
  }
  // #endregion Private Methods
}
