import '../../../../core/domain/user.dart';
import 'address.dart';

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

  SignUpModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    DateTime? birthDate,
    List<AddressModel>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SignUpModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      password: password ?? this.password,
    );
  }
}
