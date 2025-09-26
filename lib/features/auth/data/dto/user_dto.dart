import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/domain/user.dart';
import 'address_dto.dart';

part 'user_dto.g.dart';

@JsonSerializable(explicitToJson: true)
class UserDto {
  UserDto({
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
  final List<AddressDto> addresses;
  final DateTime createdAt;
  final DateTime? updatedAt;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserModel toDomainModel() {
    return UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate,
      addresses: addresses.map((address) => address.toModel()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
