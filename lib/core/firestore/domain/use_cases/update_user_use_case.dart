import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/user.dart';
import '../../../exceptions/domain_exception.dart';
import '../user_collection_repository.dart';

@injectable
class UpdateUserUseCase {
  const UpdateUserUseCase(this._userCollectionRepository);

  final UserCollectionRepository _userCollectionRepository;

  Future<Either<DomainException, UserModel>> call(UserModel user) async {
    return _userCollectionRepository.updateUserCollection(user);
  }
}
