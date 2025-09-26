import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/address.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/user_auth.dart';

class TestHelpers {
  static UserModel createUserModel({
    String id = 'user123',
    String firstName = 'John',
    String lastName = 'Doe',
    String email = 'test@example.com',
    DateTime? birthDate,
    List<AddressModel> addresses = const [],
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      birthDate: birthDate ?? DateTime(1990),
      addresses: addresses,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static SignUpModel createSignUpModel({
    String id = 'user123',
    String firstName = 'John',
    String lastName = 'Doe',
    String email = 'test@example.com',
    String password = 'password123',
    DateTime? birthDate,
    List<AddressModel> addresses = const [],
    DateTime? createdAt,
  }) {
    return SignUpModel(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      birthDate: birthDate ?? DateTime(1990),
      addresses: addresses,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static UserAuthModel createUserAuth({
    String email = 'test@example.com',
    String password = 'password123',
  }) {
    return UserAuthModel(email: email, password: password);
  }

  static AddressModel createAddress({
    String id = 'address1',
    String country = 'Colombia',
    String department = 'Bogotá D.C.',
    String municipality = 'Bogotá',
    String streetAddress = 'Calle 123 #45-67',
    String? complement,
    bool isDefault = true,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id,
      country: country,
      department: department,
      municipality: municipality,
      streetAddress: streetAddress,
      complement: complement,
      isDefault: isDefault,
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  static List<AddressModel> createAddressList({int count = 1}) {
    return List.generate(
      count,
      (index) =>
          createAddress(id: 'address${index + 1}', isDefault: index == 0),
    );
  }
}
