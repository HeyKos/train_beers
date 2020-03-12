import '../../domain/entities/user.dart';
import '../../domain/repositories/users_repository.dart';

class DataUsersRepository extends UsersRepository {
  List<User> users;
  // sigleton
  static DataUsersRepository _instance = DataUsersRepository._internal();
  DataUsersRepository._internal() {
    users = List<User>();
    users.addAll([
      User('1', 'Jon Hollinger'),
      User('2', 'Christopher Dubbins'),
      User('3', 'Jobi Campbell'),
      User('4', 'Frank Arendt'),
      User('5', 'Mike Koser'),
      User('6', 'Josh Peters'),
      User('7', 'Brandon Scott'),
      User('8', 'Michael Tyson'),
    ]);
  }
  factory DataUsersRepository() => _instance;

  @override
  Future<List<User>> getAllUsers() async {
    // Here, do some heavy work lke http requests, async tasks, etc to get data
    return users;
  }

  @override
  Future<User> getUser(String uid) async {
    // Here, do some heavy work lke http requests, async tasks, etc to get data

    return users.firstWhere((user) => user.uid == uid);
  }
}
