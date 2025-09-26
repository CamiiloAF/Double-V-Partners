import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/nothing.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../repository/profile_repository.dart';

@injectable
class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Either<DomainException, Nothing>> call() async {
    return _repository.logout();
  }
}
