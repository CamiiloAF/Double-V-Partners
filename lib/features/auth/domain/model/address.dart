class AddressModel {
  const AddressModel({
    required this.id,
    required this.country,
    required this.department,
    required this.municipality,
    required this.streetAddress,
    this.complement,
    this.isDefault = false,
    required this.createdAt,
  });

  final String id;
  final String country;
  final String department;
  final String municipality;
  final String streetAddress;
  final String? complement;
  final bool isDefault;
  final DateTime createdAt;

  String get fullAddress {
    final parts = [streetAddress];
    if (complement?.isNotEmpty == true) {
      parts.add(complement!);
    }
    parts.addAll([municipality, department, country]);
    return parts.join(', ');
  }
}
