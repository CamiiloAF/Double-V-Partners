import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:double_v_partners_tech/features/auth/data/dto/mapper/sign_up_mapper.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:injectable/injectable.dart';

import '../../../features/auth/data/dto/user_dto.dart';
import '../../exceptions/domain_exception.dart';
import '../domain/user_collection_repository.dart';

@Injectable(as: UserCollectionRepository)
class UserCollectionRepositoryImpl implements UserCollectionRepository {
  UserCollectionRepositoryImpl(this.firestore);

  final FirebaseFirestore firestore;

  static const _collectionName = 'users';

  @override
  Future<UserModel> addToUserCollection(UserModel userModel) async {
    await firestore
        .collection(_collectionName)
        .doc(userModel.id)
        .set(userModel.toJson());

    return userModel;
  }

  @override
  Future<UserModel> updateUserCollection(UserModel userModel) async {
    await firestore
        .collection(_collectionName)
        .doc(userModel.id)
        .update(userModel.toJson());

    return userModel;
  }

  @override
  Future<UserModel> getUserById(String userId) async {
    final doc = await firestore.collection(_collectionName).doc(userId).get();
    if (doc.exists) {
      return UserDto.fromJson(doc.data()!).toDomainModel();
    } else {
      throw DomainException(
        message: 'Usuario no encontrado en la base de datos.',
      );
    }
  }
}
