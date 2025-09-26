import 'package:double_v_partners_tech/core/domain/user.dart';

class SignUpModel extends UserModel {
  SignUpModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.email,
    required super.birthDate,
    required super.createdAt,
    required super.addresses,
    required this.password,
  });

  final String password;
}
