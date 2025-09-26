import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/domain/user.dart';
import '../model/user_auth.dart';

abstract class LoginRepository {
  Future<Either<DomainException, UserModel>> loginWithEmailAndPassword(
    UserAuthModel userAuth,
  );
}
