class AddressModel {
  const AddressModel({
    required this.id,
    required this.country,
    required this.department,
    required this.municipality,
    required this.streetAddress,
    required this.createdAt,
    this.complement,
    this.isDefault = false,
  });

  final String id;
  final String country;
  final String department;
  final String municipality;
  final String streetAddress;
  final String? complement;
  final bool isDefault;
  final DateTime createdAt;
}
