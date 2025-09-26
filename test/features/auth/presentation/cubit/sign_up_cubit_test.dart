import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/result_state.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/address.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:double_v_partners_tech/features/auth/presentation/cubit/sign_up/sign_up_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_cubit_test.mocks.dart';

@GenerateMocks([SignUpUseCase])
void main() {
  late SignUpCubit signUpCubit;
  late MockSignUpUseCase mockSignUpUseCase;

  setUp(() {
    mockSignUpUseCase = MockSignUpUseCase();
    signUpCubit = SignUpCubit(mockSignUpUseCase);
  });

  tearDown(() {
    signUpCubit.close();
  });

  group('SignUpCubit', () {
    final signUpModel = SignUpModel(
      id: 'user123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      password: 'password123',
      birthDate: DateTime(1990),
      addresses: const [],
      createdAt: DateTime.now(),
    );

    final userModel = UserModel(
      id: 'user123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      birthDate: DateTime(1990),
      createdAt: DateTime.now(),
    );

    final addresses = <AddressModel>[
      AddressModel(
        id: 'address1',
        country: 'Colombia',
        department: 'Bogotá D.C.',
        municipality: 'Bogotá',
        streetAddress: 'Calle 123 #45-67',
        isDefault: true,
        createdAt: DateTime.now(),
      ),
    ];

    test('initial state should be Initial', () {
      expect(signUpCubit.state, equals(const ResultState<UserModel>.initial()));
    });

    blocTest<SignUpCubit, ResultState<UserModel>>(
      'should emit [Loading, Data] when sign up is successful',
      build: () {
        when(mockSignUpUseCase(any)).thenAnswer((_) async => Right(userModel));
        return signUpCubit;
      },
      act: (cubit) {
        cubit.setSignUpModel(signUpModel);
        cubit.submitSignUp(addresses);
      },
      expect: () => [
        const ResultState<UserModel>.loading(),
        ResultState<UserModel>.data(data: userModel),
      ],
      verify: (_) {
        verify(mockSignUpUseCase(any)).called(1);
      },
    );

    blocTest<SignUpCubit, ResultState<UserModel>>(
      'should emit [Loading, Error] when sign up fails',
      build: () {
        const domainException = DomainException(
          message: 'Email already exists',
        );
        when(
          mockSignUpUseCase(any),
        ).thenAnswer((_) async => const Left(domainException));
        return signUpCubit;
      },
      act: (cubit) {
        cubit.setSignUpModel(signUpModel);
        cubit.submitSignUp(addresses);
      },
      expect: () => [
        const ResultState<UserModel>.loading(),
        const ResultState<UserModel>.error(
          error: DomainException(message: 'Email already exists'),
        ),
      ],
      verify: (_) {
        verify(mockSignUpUseCase(any)).called(1);
      },
    );
  });
}
