import 'package:train_beers/src/domain/entities/user_entity.dart';

abstract class UsersRepository {
    Future<void> addNewUser(UserEntity user);
    Future<void> deleteUser(UserEntity user);
    Stream<List<UserEntity>> users();
    Future<void> updateUser(UserEntity user);
}
