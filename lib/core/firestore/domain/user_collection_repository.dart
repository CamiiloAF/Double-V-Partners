import 'package:double_v_partners_tech/core/domain/user.dart';

abstract class UserCollectionRepository {
  Future<UserModel> addToUserCollection(UserModel userModel);

  Future<UserModel> updateUserCollection(UserModel userModel);

  Future<UserModel> getUserById(String userId);
}
