import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/user.dart';
import '../../../exceptions/domain_exception.dart';
import '../user_collection_repository.dart';

@injectable
class GetUserByIdUseCase {
  const GetUserByIdUseCase(this._userCollectionRepository);

  final UserCollectionRepository _userCollectionRepository;

  Future<Either<DomainException, UserModel>> call(String userId) async {
    try {
      final user = await _userCollectionRepository.getUserById(userId);
      return Right(user);
    } catch (error) {
      return Left(
        DomainException(
          message: 'Error al obtener el usuario: ${error}',
        ),
      );
    }
  }
}
