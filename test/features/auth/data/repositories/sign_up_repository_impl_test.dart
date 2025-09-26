import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/user.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/core/firestore/domain/user_collection_repository.dart';
import 'package:double_v_partners_tech/features/auth/data/repositories/sign_up_repository_impl.dart';
import 'package:double_v_partners_tech/features/auth/domain/model/sign_up_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_up_repository_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuth, UserCollectionRepository, User])
void main() {
  late SignUpRepositoryImpl repository;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockUserCollectionRepository mockUserCollectionRepository;
  late MockUser mockFirebaseUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCollectionRepository = MockUserCollectionRepository();
    mockFirebaseUser = MockUser();
    repository = SignUpRepositoryImpl(
      mockUserCollectionRepository,
      mockFirebaseAuth,
    );
  });

  group('SignUpRepositoryImpl', () {
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

    test('should sign up successfully and return user model', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      when(mockUserCredential.user).thenReturn(mockFirebaseUser);

      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenAnswer((_) async => mockUserCredential);

      when(mockFirebaseUser.uid).thenReturn('user123');
      when(
        mockUserCollectionRepository.addToUserCollection(any),
      ).thenAnswer((_) async => userModel);

      // Act
      final result = await repository.signUpUser(signUpModel);

      // Assert
      expect(result, isA<Right<DomainException, UserModel>>());
      result.fold(
        (failure) =>
            fail('Expected success but got failure: ${failure.message}'),
        (user) => expect(user.email, equals('test@example.com')),
      );
    });

    test('should return DomainException when Firebase auth fails', () async {
      // Arrange
      when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
          email: anyNamed('email'),
          password: anyNamed('password'),
        ),
      ).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      // Act
      final result = await repository.signUpUser(signUpModel);

      // Assert
      expect(result, isA<Left<DomainException, UserModel>>());
      result.fold(
        (failure) => expect(failure, isA<DomainException>()),
        (user) => fail('Expected failure but got success'),
      );
    });

    test(
      'should return DomainException when user creation in Firestore fails',
      () async {
        // Arrange
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: anyNamed('email'),
            password: anyNamed('password'),
          ),
        ).thenAnswer((_) async => MockUserCredential());

        when(mockFirebaseAuth.currentUser).thenReturn(mockFirebaseUser);
        when(mockFirebaseUser.uid).thenReturn('user123');
        when(
          mockUserCollectionRepository.addToUserCollection(any),
        ).thenThrow(Exception('Firestore error'));

        // Act
        final result = await repository.signUpUser(signUpModel);

        // Assert
        expect(result, isA<Left<DomainException, UserModel>>());
      },
    );
  });
}

class MockUserCredential extends Mock implements UserCredential {}
