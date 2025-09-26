import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/nothing.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/profile/domain/repository/profile_repository.dart';
import 'package:double_v_partners_tech/features/profile/domain/use_case/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'logout_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepository])
void main() {
  late LogoutUseCase useCase;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockProfileRepository = MockProfileRepository();
    useCase = LogoutUseCase(mockProfileRepository);
  });

  group('LogoutUseCase', () {
    test('should logout successfully', () async {
      // Arrange
      when(
        mockProfileRepository.logout(),
      ).thenAnswer((_) async => const Right(Nothing()));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Right<DomainException, void>>());
      result.fold(
        (failure) => fail('Expected success but got failure'),
        (_) => expect(true, isTrue), // Success case
      );
      verify(mockProfileRepository.logout()).called(1);
    });

    test('should return DomainException when logout fails', () async {
      // Arrange
      const domainException = DomainException(message: 'Logout failed');
      when(
        mockProfileRepository.logout(),
      ).thenAnswer((_) async => const Left(domainException));

      // Act
      final result = await useCase();

      // Assert
      expect(result, isA<Left<DomainException, void>>());
      result.fold(
        (failure) => expect(failure.message, equals('Logout failed')),
        (_) => fail('Expected failure but got success'),
      );
      verify(mockProfileRepository.logout()).called(1);
    });
  });
}
