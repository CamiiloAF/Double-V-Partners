import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/user.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../model/sign_up_model.dart';
import '../repositories/sign_up_repository.dart';

@injectable
class SignUpUseCase {
  SignUpUseCase(this.repository);

  final SignUpRepository repository;

  Future<Either<DomainException, UserModel>> call(
    SignUpModel signUpModel,
  ) async {
    return repository.signUpUser(signUpModel);
  }
}
