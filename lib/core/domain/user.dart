import '../../features/auth/domain/model/address.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    required this.createdAt,
    this.addresses = const [],
    this.updatedAt,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthDate;
  final List<AddressModel> addresses;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AddressModel? get defaultAddress => addresses.isNotEmpty
      ? addresses.firstWhere(
          (address) => address.isDefault,
          orElse: () => addresses.first,
        )
      : null;

  UserModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    List<AddressModel>? addresses,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      addresses: addresses ?? this.addresses,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
