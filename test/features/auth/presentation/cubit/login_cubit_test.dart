import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/result_state.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/user_auth.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/login_with_email_and_password_use_case.dart';
import 'package:double_v_partners_tech/features/auth/presentation/cubit/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_cubit_test.mocks.dart';

@GenerateMocks([LoginWithEmailAndPasswordUseCase])
void main() {
  late LoginCubit loginCubit;
  late MockLoginWithEmailAndPasswordUseCase mockLoginUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginWithEmailAndPasswordUseCase();
    loginCubit = LoginCubit(loginWithEmailAndPasswordUseCase: mockLoginUseCase);
  });

  tearDown(() {
    loginCubit.close();
  });

  group('LoginCubit', () {
    final userAuth = UserAuthModel(
      email: 'test@example.com',
      password: 'password123',
    );

    final userModel = UserModel(
      id: 'user123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'test@example.com',
      birthDate: DateTime(1990),
      createdAt: DateTime.now(),
    );

    test('initial state should be Initial', () {
      expect(loginCubit.state, equals(const ResultState<UserModel>.initial()));
    });

    blocTest<LoginCubit, ResultState<UserModel>>(
      'should emit [Loading, Data] when login is successful',
      build: () {
        when(
          mockLoginUseCase(userAuth),
        ).thenAnswer((_) async => Right(userModel));
        return loginCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(userAuth),
      expect: () => [
        const ResultState<UserModel>.loading(),
        ResultState<UserModel>.data(data: userModel),
      ],
      verify: (_) {
        verify(mockLoginUseCase(userAuth)).called(1);
      },
    );

    blocTest<LoginCubit, ResultState<UserModel>>(
      'should emit [Loading, Error] when login fails',
      build: () {
        const domainException = DomainException(message: 'Invalid credentials');
        when(
          mockLoginUseCase(userAuth),
        ).thenAnswer((_) async => const Left(domainException));
        return loginCubit;
      },
      act: (cubit) => cubit.loginWithEmailAndPassword(userAuth),
      expect: () => [
        const ResultState<UserModel>.loading(),
        const ResultState<UserModel>.error(
          error: DomainException(message: 'Invalid credentials'),
        ),
      ],
      verify: (_) {
        verify(mockLoginUseCase(userAuth)).called(1);
      },
    );
  });
}
