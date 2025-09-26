import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/repositories/sign_up_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/user.dart';
import '../../../../core/exceptions/domain_exception.dart';

@injectable
class SignUpUseCase {
  SignUpUseCase(this.repository);

  final SignUpRepository repository;

  Future<Either<DomainException, UserModel>> call(
    SignUpModel signUpModel,
  ) async {
    return await repository.signUpUser(signUpModel);
  }
}
