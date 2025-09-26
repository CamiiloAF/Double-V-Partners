import '../../../../../core/domain/user.dart';
import '../../../domain/model/address.dart';
import '../address_dto.dart';
import '../user_dto.dart';

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
