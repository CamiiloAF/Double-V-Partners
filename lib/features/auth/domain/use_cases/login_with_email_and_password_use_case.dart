import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/domain/user.dart';
import '../model/user_auth.dart';
import '../repositories/login_repository.dart';

@injectable
class LoginWithEmailAndPasswordUseCase {
  LoginWithEmailAndPasswordUseCase(this.repository);

  final LoginRepository repository;

  Future<Either<DomainException, UserModel>> call(
    UserAuthModel userAuth,
  ) async {
    return await repository.loginWithEmailAndPassword(userAuth);
  }
}
