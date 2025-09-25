import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/firestore/domain/user_collection_repository.dart';
import '../../../../core/http/rest_client_functions.dart';
import '../../domain/model/user.dart';
import '../../domain/repositories/sign_up_repository.dart';

@Injectable(as: SignUpRepository)
class SignUpRepositoryImpl implements SignUpRepository {
  SignUpRepositoryImpl(this.userCollectionRepository);

  final UserCollectionRepository userCollectionRepository;

  @override
  Future<Either<DomainException, UserModel>> signUpUser(UserModel userModel) {
    return executeService(
      function: () async {
        return await userCollectionRepository.addToUserCollection(userModel);
      },
    );
  }
}
