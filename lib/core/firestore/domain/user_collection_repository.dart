import 'package:dartz/dartz.dart';

import '../../domain/user.dart';
import '../../exceptions/domain_exception.dart';

abstract class UserCollectionRepository {
  Future<UserModel> addToUserCollection(UserModel userModel);

  Future<Either<DomainException, UserModel>> updateUserCollection(
    UserModel userModel,
  );

  Future<UserModel> getUserById(String userId);
}
