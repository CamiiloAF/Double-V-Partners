import 'address.dart';

class UserModel {
  const UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.birthDate,
    this.addresses = const [],
    required this.createdAt,
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

  int get age {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
