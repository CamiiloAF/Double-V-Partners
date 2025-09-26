import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/domain/nothing.dart';
import '../../../../core/exceptions/domain_exception.dart';
import '../../../../core/http/rest_client_functions.dart';
import '../../domain/repository/profile_repository.dart';

@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  Future<Either<DomainException, Nothing>> logout() async {
    return executeService(
      function: () async {
        await _firebaseAuth.signOut();

        return const Nothing();
      },
    );
  }
}
