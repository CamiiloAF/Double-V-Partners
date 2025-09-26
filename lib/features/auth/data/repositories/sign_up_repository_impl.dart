import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/user.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/firestore/domain/user_collection_repository.dart';
import '../../../../core/http/rest_client_functions.dart';
import '../../domain/model/sign_up_model.dart';
import '../../domain/repositories/sign_up_repository.dart';

@Injectable(as: SignUpRepository)
class SignUpRepositoryImpl implements SignUpRepository {
  SignUpRepositoryImpl(this._userCollectionRepository, this._firebaseAuth);

  final UserCollectionRepository _userCollectionRepository;
  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<DomainException, UserModel>> signUpUser(
    SignUpModel signUpModel,
  ) async {
    return await executeService(
      function: () async {
        final response = await _firebaseAuth.createUserWithEmailAndPassword(
          email: signUpModel.email,
          password: signUpModel.password,
        );

        if (response.user == null) {
          throw DomainException(message: 'User creation failed');
        }

        await _userCollectionRepository.addToUserCollection(signUpModel);

        return signUpModel;
      },
    );
  }
}
