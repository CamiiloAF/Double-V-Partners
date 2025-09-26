import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:double_v_partners_tech/core/domain/nothing.dart';
import 'package:double_v_partners_tech/core/domain/result_state.dart';
import 'package:double_v_partners_tech/core/exceptions/domain_exception.dart';
import 'package:double_v_partners_tech/features/profile/domain/use_case/logout_use_case.dart';
import 'package:double_v_partners_tech/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_cubit_test.mocks.dart';

@GenerateMocks([LogoutUseCase])
void main() {
  late ProfileCubit profileCubit;
  late MockLogoutUseCase mockLogoutUseCase;

  setUp(() {
    mockLogoutUseCase = MockLogoutUseCase();
    profileCubit = ProfileCubit(mockLogoutUseCase);
  });

  tearDown(() {
    profileCubit.close();
  });

  group('ProfileCubit', () {
    test('initial state should be Initial', () {
      expect(profileCubit.state, equals(const ResultState<Nothing>.initial()));
    });

    blocTest<ProfileCubit, ResultState<Nothing>>(
      'should emit [Loading, Data] when logout is successful',
      build: () {
        when(
          mockLogoutUseCase(),
        ).thenAnswer((_) async => const Right(Nothing()));
        return profileCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const ResultState<Nothing>.loading(),
        const ResultState<Nothing>.data(data: Nothing()),
      ],
      verify: (_) {
        verify(mockLogoutUseCase()).called(1);
      },
    );

    blocTest<ProfileCubit, ResultState<Nothing>>(
      'should emit [Loading, Error] when logout fails',
      build: () {
        const domainException = DomainException(message: 'Logout failed');
        when(
          mockLogoutUseCase(),
        ).thenAnswer((_) async => const Left(domainException));
        return profileCubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        const ResultState<Nothing>.loading(),
        const ResultState<Nothing>.error(
          error: DomainException(message: 'Logout failed'),
        ),
      ],
      verify: (_) {
        verify(mockLogoutUseCase()).called(1);
      },
    );
  });
}
