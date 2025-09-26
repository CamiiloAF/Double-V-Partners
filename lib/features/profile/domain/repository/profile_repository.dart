import 'package:dartz/dartz.dart';

import '../../../../core/domain/nothing.dart';
import '../../../../core/exceptions/domain_exception.dart';

abstract class ProfileRepository {
  Future<Either<DomainException, Nothing>> logout();
}
