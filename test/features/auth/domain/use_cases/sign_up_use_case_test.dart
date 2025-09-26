import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:double_v_partners_tech/features/auth/domain/repositories/sign_up_repository.dart';
import 'package:double_v_partners_tech/features/auth/domain/use_cases/sign_up_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_use_case_test.mocks.dart';

@GenerateMocks([SignUpRepository])
void main() {
  late SignUpUseCase useCase;
  late MockSignUpRepository mockSignUpRepository;

  setUp(() {
    mockSignUpRepository = MockSignUpRepository();
    useCase = SignUpUseCase(mockSignUpRepository);
  });

  group('SignUpUseCase', () {
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

    test('should return user model when sign up is successful', () async {
      // Arrange
      when(
        mockSignUpRepository.signUpUser(signUpModel),
      ).thenAnswer((_) async => Right(userModel));

      // Act
      final result = await useCase(signUpModel);

      // Assert
      expect(result, isA<Right<DomainException, UserModel>>());
      result.fold((failure) => fail('Expected success but got failure'), (
        user,
      ) {
        expect(user.email, equals('test@example.com'));
        expect(user.firstName, equals('John'));
      });
      verify(mockSignUpRepository.signUpUser(signUpModel)).called(1);
    });

    test('should return DomainException when sign up fails', () async {
      // Arrange
      const domainException = DomainException(message: 'Email already exists');
      when(
        mockSignUpRepository.signUpUser(signUpModel),
      ).thenAnswer((_) async => const Left(domainException));

      // Act
      final result = await useCase(signUpModel);

      // Assert
      expect(result, isA<Left<DomainException, UserModel>>());
      result.fold(
        (failure) => expect(failure.message, equals('Email already exists')),
        (user) => fail('Expected failure but got success'),
      );
      verify(mockSignUpRepository.signUpUser(signUpModel)).called(1);
    });
  });
}
