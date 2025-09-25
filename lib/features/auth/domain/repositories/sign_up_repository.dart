import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../model/user.dart';

abstract class SignUpRepository {
  Future<Either<DomainException, UserModel>> signUpUser(UserModel userModel);
}
