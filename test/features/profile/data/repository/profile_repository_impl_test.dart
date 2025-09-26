import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/profile/data/repository/profile_repository_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repository_impl_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late ProfileRepositoryImpl repository;
  late MockFirebaseAuth mockFirebaseAuth;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    repository = ProfileRepositoryImpl(mockFirebaseAuth);
  });

  group('ProfileRepositoryImpl', () {
    test('should logout successfully', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async => {});

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<Right<DomainException, void>>());
      verify(mockFirebaseAuth.signOut()).called(1);
    });

    test('should return DomainException when logout fails', () async {
      // Arrange
      when(mockFirebaseAuth.signOut()).thenThrow(Exception('Network error'));

      // Act
      final result = await repository.logout();

      // Assert
      expect(result, isA<Left<DomainException, void>>());
      result.fold(
        (failure) => expect(failure, isA<DomainException>()),
        (_) => fail('Expected failure but got success'),
      );
    });
  });
}
