import '../../domain/user.dart';

abstract class UserCollectionRepository {
  Future<UserModel> addToUserCollection(UserModel userModel);

  Future<UserModel> updateUserCollection(UserModel userModel);

  Future<UserModel> getUserById(String userId);
}
