import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/model/address.dart';

part 'address_dto.g.dart';

@JsonSerializable()
class AddressDto extends AddressModel {
  AddressDto({
    required super.id,
    required super.country,
    required super.department,
    required super.municipality,
    required super.streetAddress,
    super.complement,
    super.isDefault = false,
    required super.createdAt,
  });

  factory AddressDto.fromJson(Map<String, dynamic> json) =>
      _$AddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressDtoToJson(this);

  AddressModel toModel() {
    return AddressModel(
      id: id,
      country: country,
      department: department,
      municipality: municipality,
      streetAddress: streetAddress,
      complement: complement,
      isDefault: isDefault,
      createdAt: createdAt,
    );
  }
}
