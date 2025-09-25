import 'package:double_v_partners_tech/features/auth/data/dto/address_dto.dart';
import 'package:double_v_partners_tech/features/auth/data/dto/user_dto.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/user.dart';

import '../../../domain/model/address.dart';

extension SignUpMapper on UserModel {
  Map<String, dynamic> toJson() => UserDto(
    id: id,
    firstName: firstName,
    lastName: lastName,
    email: email,
    birthDate: birthDate,
    createdAt: createdAt,
    addresses: addresses.map((address) => address.toDto()).toList(),
  ).toJson();
}

extension AddressMapper on AddressModel {
  AddressDto toDto() => AddressDto(
    id: id,
    country: country,
    department: department,
    municipality: municipality,
    streetAddress: streetAddress,
    createdAt: createdAt,
    complement: complement,
    isDefault: isDefault,
  );
}
