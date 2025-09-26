import 'package:dartz/dartz.dart';

import '../../../../core/domain/user.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../model/sign_up_model.dart';

abstract class SignUpRepository {
  Future<Either<DomainException, UserModel>> signUpUser(
    SignUpModel signUpModel,
  );
}
