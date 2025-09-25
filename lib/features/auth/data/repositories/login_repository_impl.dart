import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/firestore/domain/user_collection_repository.dart';
import '../../../../core/http/rest_client_functions.dart';
import '../../domain/model/user.dart';
import '../../domain/model/user_auth.dart';
import '../../domain/repositories/login_repository.dart';

@Injectable(as: LoginRepository)
class LoginRepositoryImpl implements LoginRepository {
  LoginRepositoryImpl(this.firebaseAuth, this.userCollectionRepository);

  final FirebaseAuth firebaseAuth;
  final UserCollectionRepository userCollectionRepository;

  @override
  Future<Either<DomainException, UserModel>> loginWithEmailAndPassword(
    UserAuthModel userAuth,
  ) async {
    return executeService(
      function: () async {
        final response = await firebaseAuth.createUserWithEmailAndPassword(
          email: userAuth.email,
          password: userAuth.password,
        );

        final user = response.user;

        if (user != null) {
          return await userCollectionRepository.getUserById(user.uid);
        } else {
          throw DomainException(message: 'Error inesperado, usuario nulo');
        }
      },
    );
  }
}
