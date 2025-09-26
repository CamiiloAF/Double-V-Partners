import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/user_auth.dart';
import 'package:double_v_partners_tech/features/auth/domain/repositories/login_repository.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/login_with_email_and_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_with_email_and_password_use_case_test.mocks.dart';

@GenerateMocks([LoginRepository])
void main() {
  late LoginWithEmailAndPasswordUseCase useCase;
  late MockLoginRepository mockLoginRepository;

  setUp(() {
    mockLoginRepository = MockLoginRepository();
    useCase = LoginWithEmailAndPasswordUseCase(mockLoginRepository);
  });

  group('LoginWithEmailAndPasswordUseCase', () {
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

    test('should return user model when login is successful', () async {
      // Arrange
      when(
        mockLoginRepository.loginWithEmailAndPassword(userAuth),
      ).thenAnswer((_) async => Right(userModel));

      // Act
      final result = await useCase(userAuth);

      // Assert
      expect(result, isA<Right<DomainException, UserModel>>());
      result.fold((failure) => fail('Expected success but got failure'), (
        user,
      ) {
        expect(user.email, equals('test@example.com'));
        expect(user.firstName, equals('John'));
      });
      verify(mockLoginRepository.loginWithEmailAndPassword(userAuth)).called(1);
    });

    test('should return DomainException when login fails', () async {
      // Arrange
      const domainException = DomainException(message: 'Invalid credentials');
      when(
        mockLoginRepository.loginWithEmailAndPassword(userAuth),
      ).thenAnswer((_) async => const Left(domainException));

      // Act
      final result = await useCase(userAuth);

      // Assert
      expect(result, isA<Left<DomainException, UserModel>>());
      result.fold(
        (failure) => expect(failure.message, equals('Invalid credentials')),
        (user) => fail('Expected failure but got success'),
      );
      verify(mockLoginRepository.loginWithEmailAndPassword(userAuth)).called(1);
    });
  });
}
