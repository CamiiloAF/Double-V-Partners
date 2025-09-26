import '../../../../core/domain/user.dart';

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

  factory SignUpModel.fromUser(UserModel user, String password) => SignUpModel(
    id: user.id,
    firstName: user.firstName,
    lastName: user.lastName,
    email: user.email,
    birthDate: user.birthDate,
    createdAt: user.createdAt,
    addresses: user.addresses,
    password: password,
  );
}
